# ----------- Cài đặt & nạp thư viện -----------

library(sparklyr)
library(dplyr)
library(ggplot2)
library(stringr)
library(viridis)

# ----------- Kết nối Spark -----------
sc <- spark_connect(master = "local")

# ----------- Đọc dữ liệu -----------
df <- spark_read_csv(sc, "chess_games", "chess_games.csv", infer_schema = TRUE, header = TRUE)

# ----------- Xem danh sách cột -----------
print(colnames(df))

# ----------- Phân tích thống kê Elo -----------
elo_stats <- df %>%
  select(white_rating, black_rating, moves) %>%
  collect()

# ----------- Biểu đồ phân bố Elo -----------
ggplot(elo_stats, aes(x = white_rating)) +
  geom_histogram(fill = "#0073e6", bins = 30, color = "black", alpha = 0.8) +
  labs(title = "Phân bố Elo người chơi trắng", x = "Elo Rating", y = "Số lượng") +
  theme_minimal()

ggplot(elo_stats, aes(x = black_rating)) +
  geom_histogram(fill = "#e60000", bins = 30, color = "black", alpha = 0.8) +
  labs(title = "Phân bố Elo người chơi đen", x = "Elo Rating", y = "Số lượng") +
  theme_minimal()

# ----------- Xác định cột khai cuộc -----------
df <- df %>% collect()
cols <- colnames(df)

opening_col <- if ("opening_shortname" %in% cols) {
  "opening_shortname"
} else if ("opening_fullname" %in% cols) {
  "opening_fullname"
} else if ("opening_code" %in% cols) {
  "opening_code"
} else if ("opening_name" %in% cols) {
  "opening_name"
} else if ("opening" %in% cols) {
  "opening"
} else if ("eco_opening" %in% cols) {
  "eco_opening"
} else {
  stop("Không tìm thấy cột khai cuộc nào trong dữ liệu!")
}

# ----------- Phân tích khai cuộc -----------
openings <- df %>%
  group_by(across(all_of(opening_col))) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(desc(count))

top_openings <- head(openings, 10)

ggplot(top_openings, aes(x = reorder(.data[[opening_col]], count), y = count)) +
  geom_bar(stat = "identity", fill = "#009933", color = "black") +
  coord_flip() +
  labs(title = "Top 10 khai cuộc phổ biến", x = "Số lượng", y = "Khai cuộc") +
  theme_minimal()

# ----------- Xác định giai đoạn theo số nước đi -----------
elo_stats$stage <- sapply(elo_stats$moves, function(moves) {
  n <- str_count(moves, " ") + 1
  if (n <= 15) {
    return("Opening")
  } else if (n <= 40) {
    return("Middlegame")
  } else {
    return("Endgame")
  }
})

stage_stats <- elo_stats %>%
  group_by(stage) %>%
  summarise(count = n(), .groups = "drop")

ggplot(stage_stats, aes(x = stage, y = count, fill = stage)) +
  geom_bar(stat = "identity", color = "black", alpha = 0.8) +
  scale_fill_manual(values = c("Opening" = "#0066cc", 
                               "Middlegame" = "#ff9900", 
                               "Endgame" = "#cc0000")) +
  labs(title = "Số lượng ván theo giai đoạn", x = "Giai đoạn", y = "Số lượng") +
  theme_minimal()


# ----------- Xác định cột kết quả -----------
result_col <- if ("result" %in% cols) {
  "result"
} else if ("winner" %in% cols) {
  "winner"
} else {
  stop("Không tìm thấy cột kết quả nào!")
}

# ----------- Chuẩn bị dữ liệu huấn luyện -----------
model_data <- df %>%
  select(white_rating, black_rating, all_of(result_col)) %>%
  mutate(across(all_of(result_col), as.character))

# ----------- Upload dữ liệu huấn luyện lên Spark -----------
model_tbl <- copy_to(sc, model_data, "model_data_tbl", overwrite = TRUE)

# ----------- Huấn luyện mô hình Random Forest -----------
rf_model <- ml_random_forest(
  model_tbl,
  response = result_col,
  features = c("white_rating", "black_rating"),
  type = "classification"
)

# ----------- Dự đoán và đánh giá mô hình -----------
predictions <- rf_model %>%
  ml_predict(model_tbl) %>%
  select(all_of(result_col), prediction) %>%
  collect()

confusion_matrix <- table(predictions[[result_col]], predictions$prediction)
print("Confusion Matrix:")
print(confusion_matrix)

accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)
print(paste("Accuracy:", round(accuracy * 100, 2), "%"))

# ----------- Hàm dự đoán kết quả ván mới -----------
predict_game <- function(white_elo, black_elo) {
  new_game <- data.frame(white_rating = white_elo, black_rating = black_elo)
  new_game_tbl <- copy_to(sc, new_game, "new_game_tbl", overwrite = TRUE)
  
  prediction <- rf_model %>%
    ml_predict(new_game_tbl) %>%
    select(prediction) %>%
    collect()
  
  return(prediction$prediction[1])
}

cat("Dự đoán kết quả trận đấu giữa trắng Elo 2000 và đen Elo 1900: ",
    predict_game(2000, 1900), "\n")

# ----------- Dự đoán nước đi tiếp theo -----------
predict_next_move <- function(moves_input, df) {
  df_moves <- df %>% select(moves) %>% collect()
  
  matched_moves <- df_moves %>%
    filter(str_starts(moves, moves_input)) %>%
    pull(moves)
  
  if (length(matched_moves) == 0) {
    return("Không tìm thấy dữ liệu gợi ý.")
  }
  
  next_moves <- c()
  input_length <- str_count(moves_input, " ") + 1
  
  for (game_moves in matched_moves) {
    moves_list <- unlist(str_split(game_moves, " "))
    if (length(moves_list) >= input_length + 1) {
      next_moves <- c(next_moves, moves_list[input_length + 1])
    }
  }
  
  if (length(next_moves) == 0) {
    return("Không tìm thấy nước đi tiếp theo.")
  }
  
  next_move_freq <- table(next_moves)
  next_move <- names(sort(next_move_freq, decreasing = TRUE))[1]
  
  return(next_move)
}

# ----------- Nhập và dự đoán nước đi tiếp theo -----------
moves_input <- readline(prompt = "Nhập chuỗi nước đi (vd: e4 e5 Nf3 Nc6): ")

# ----------- in dự đoán nước đi tiếp theo -----------
cat("Nước đi tiếp theo gợi ý:", predict_next_move(moves_input, df), "\n")

# ----------- Ngắt kết nối Spark -----------
spark_disconnect(sc)