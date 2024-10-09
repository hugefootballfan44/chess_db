# Hayden C. Epinette
# Generates onlinerating data

# Import relevant package
library(dplyr)

# Select, group by, and summarise columns relevant to onlinerating data
chesscom <- database %>%
  # Need to select correct rating of relevant player
  mutate(rating = case_when(color == 'White' ~ whiteelo,
                            color == 'Black' ~ blackelo)) %>%
  select(c('username', 'gamerules', 'timeclass',
           'enddate', 'endtime', 'rating')) %>%
  filter(gamerules == 'chess') %>%
  group_by(username, gamerules, timeclass, enddate) %>%
  #summarise(endtime = max(endtime))
  # Select only last entry on each day
  filter(row_number() == n())

# Failed experiment through row 28
# Get all rating data for each game each day
#chesscom_2 <- database %>%
  #mutate(rating = case_when(color == 'White' ~ whiteelo,
                            #color == 'Black' ~ blackelo)) %>%
  #select(c('username', 'gamerules', 'timeclass',
           #'enddate', 'endtime', 'rating')) %>%
  #filter(gamerules == 'chess')

# Join two tables to only have ratings after last game of each day
#chesscom_3 <- chesscom %>%
  #inner_join(chesscom_2, by = c('username', 'gamerules', 'timeclass', 'enddate', 'endtime'))

# Better, simpler method
# Left join chesscom with tt_players to get player_id
chesscom_4 <- chesscom %>%
  left_join(tt_players, by = 'username') %>%
  select(c("player_id", "timeclass", "enddate", "rating"))

# Select desired columns
chesscom_4 <- chesscom_4[,3:6]

# Convert rating to numeric and change column names
chesscom_4$rating_2 <- as.numeric(chesscom_4$rating)
chesscom_4 <- chesscom_4[,c(1:3, 5)]
colnames(chesscom_4)[c(1, 3, 4)] <- c("account_id", "date", "rating")

# Write to csv
write.csv(chesscom_4, 'rating.csv', row.names = FALSE)
