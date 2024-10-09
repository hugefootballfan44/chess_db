# Hayden C. Epinette
# Generates titledtuesday table data

# Import relevant packages
library(dplyr)
library(stringr)
library(tidyr)

# Initialize dataframe
tt_complete <- NULL

# For each file in the folder, bind it to the dataframe
for (csv in list.files('archive')) {
  tt <- read.csv(file = paste0('archive/', csv))
  
  #Using the file name to get time and date columns
  words <- strsplit(csv, '-')
  tt <- tt %>%
    mutate(time = words[[1]][1]) %>%
    mutate(date = paste0(words[[1]][6], "-", substr(words[[1]][5], 1, 3), "-", words[[1]][7]))
  tt_complete <- rbind(tt_complete, tt)
}

# Select desired columns
tt_complete <- tt_complete %>%
  select(c('date', 'time', 'round', 'pairing', 'White', 'Result', 'Black'))

# Backup in case something goes awry
tt_test <- tt_complete

# Split column White into three new columns
tt_test[c('White_Title', 'White_Username', 'White_Rating')] <- str_split_fixed(tt_complete$White, "\\s+", 3)
tt_test$White_Rating <- str_sub(tt_test$White_Rating, 2, -2)

# Split column Black into three new columns
tt_test[c('Black_Title', 'Black_Username', 'Black_Rating')] <- str_split_fixed(tt_test$Black, "\\s+", 3)
tt_test$Black_Rating <- str_sub(tt_test$Black_Rating, 2, -2)

# Split column Result into three new columns
tt_test[c('White_Result', 'Dash', 'Black_Result')] <- str_split_fixed(tt_test$Result, "\\s+", 3)

# Add a Game ID
tt_test <- tt_test %>%
  mutate(Game_ID = row_number())

# Create a dataframe for players with white pieces
tt_white <- tt_test %>%
  mutate(Color = 'White') %>%
  select(c('Game_ID', 'Color', 'date', 'time', 'round', 'pairing', 'White_Title', 'White_Username', 'White_Rating', 'White_Result'))

# Create a dataframe for players with black pieces
tt_black <- tt_test %>%
  mutate(Color = 'Black') %>%
  select(c('Game_ID', 'Color', 'date', 'time', 'round', 'pairing', 'Black_Title', 'Black_Username', 'Black_Rating', 'Black_Result'))

# Change column names to match each other
colnames(tt_white)[7:10] <- c('title', 'username', 'rating', 'result')
colnames(tt_black)[7:10] <- c('title', 'username', 'rating', 'result')

# Combine two dataframes
tt_total <- rbind(tt_white, tt_black)

# Run tt_players.R here

# Form vector of desired columns after join
z <- colnames(tt_total)
z[8] <- 'account_id'

# Join tt_total with tt_players_3 from tt_players.R
tt_total_2 <- tt_total %>%
  left_join(tt_players_3, by = 'username') %>%
  select(all_of(z))

# Convert result to numeric and account for 1/2 turning into NA
result <- as.numeric(tt_total_2$result)
for (i in 1:3875) {
  result[i] <- case_when(is.na(result[i]) ~ 0.5,
                         !is.na(result[i]) ~ result[i])
}

# Convert rating into numeric
rating <- as.numeric(tt_total_2$rating)
tt_total_2$rating_2 <- rating

# Select desired columns
tt_total_2 <- tt_total_2[c(1:8, 12, 11)]
colnames(tt_total_2)[9:10] <- c("rating", "result")

# Backup in case something goes awry and convert date data into desired format
tt_total_3 <- tt_total_2
tt_total_3$realdate <- str_replace_all(tt_total_2$date, "-[jfmasond]", toupper)

# Drop useless column and change column name
tt_total_3 <- tt_total_3[,-3]
colnames(tt_total_3)[10] <- "gamedate"

# Backup in case something goes awry
tt_total_4 <- tt_total_3

# Change NA ratings to 0
tt_total_4[is.na(tt_total_4)] <- 0

# Account for poorly collected data
tt_total_4 <- tt_total_4 %>%
  mutate(title = ifelse(account_id %in% c(1259, 1904, 2038, 2186, 2920, 2948), "", title)) %>%
  mutate(rating = ifelse(account_id %in% c(1259, 1904, 2038, 2186, 2920, 2948), case_when(account_id == 1259 ~ 2565,
                                                                                          account_id == 1904 ~ 2898,
                                                                                          account_id == 2038 ~ 2587,
                                                                                          account_id == 2186 ~ 2159,
                                                                                          account_id == 2920 ~ 2732,
                                                                                          account_id == 2948 ~ 2680), rating))

# Write to csv
write.csv(tt_total_4, 'titled_tuesday.csv', row.names = FALSE)
