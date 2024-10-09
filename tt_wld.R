# Hayden C. Epinette
# Creates onlinewld and repertoire data

# Import relevant packages
#install.packages("devtools")
library(devtools)
#devtools::install_github("JaseZiv/chessR")
library(chessR)

# Initialize database
database <- NULL

# Create vector of desired column names in database; important to maintain consistent dimensions in loop
vec <- c("GameRules", "TimeClass", "Event", "Site", "Date", "Round", "White", "Black", "Result", "Tournament",
         "CurrentPosition", "Timezone", "ECO", "ECOUrl", "UTCDate", "UTCTime", "WhiteElo", "BlackElo", "TimeControl",
         "Termination", "StartTime", "EndDate", "EndTime", "Link", "Moves", "Username", "Color")

# Loop through each username and use chessR function to access chess.com game information
for(i in 1:3875) {
  
  chesscom = tt_players$username[i]
  
  # Not every url works, so tryCatch is necessary
  tryCatch({
    
  test <- get_raw_chessdotcom(usernames = chesscom)
  
  # Add Color column and mutate Result column as desired
  test_2 <- test %>%
    mutate(Color = case_when(White == Username ~ 'White',
                             Black == Username ~ 'Black')) %>%
    mutate(Result = case_when(Color == 'White' & Result == '1-0' ~ 'W',
                              Color == 'White' & Result == '0-1' ~ 'L',
                              Color == 'Black' & Result == '1-0' ~ 'L',
                              Color == 'Black' & Result == '0-1' ~ 'W',
                              Result == '1/2-1/2' ~ 'D')) %>%
    select(all_of(vec))
  
  database <- rbind(database, test_2)},
  
  error = function(e){})
  
}

# Made it through 313 players before stopping loop; took five hours

# Select, group, and summarise columns relevant to onlinewld data
onlinewld <- database %>%
  group_by(Username, GameRules, TimeClass, Result) %>%
  summarise(freq = n()) %>%
  filter(GameRules == 'chess')

# Change column name
colnames(onlinewld)[1] <- "username"

# Lowercase column names
colnames(database) <- tolower(colnames(database))
colnames(onlinewld) <- tolower(colnames(onlinewld))

# Join with tt_players_3 to get account_id
onlinewld_2 <- tt_players_3 %>%
  right_join(onlinewld) %>%
  select(c("account_id", 'gamerules', 'timeclass', 'result', "freq"))

# Drop unnecessary gamerules column
onlinewld_3 <- onlinewld_2[,-2]

# Write to csv
write.csv(onlinewld_3, 'onlinewld.csv', row.names = FALSE)

# Select, group by, and summarise columns relevant to repertoire data
repertoire <- database %>%
  group_by(username, eco) %>%
  summarise(freq = n()) %>%
  left_join(tt_players, by = "username") %>%
  select(c("player_id", "eco", "freq"))

# Drop username column
repertoire_2 <- repertoire[,2:4]

# Changer player_id to account_id
colnames(repertoire_2)[1] <- "account_id"

# Filter out rows with NA values for ECO
repertoire_3 <- repertoire_2 %>%
  filter(!is.na(eco))

# Write to csv
write.csv(repertoire_3, 'repertoire.csv', row.names = FALSE)
