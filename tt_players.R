# Hayden C. Epinette
# Creates account table data

# Import relevant packages
library(rvest)
library(XML)
#install.packages("xml2")
library(xml2)
library(dplyr)
install.packages("RCurl")
#install.packages("RTidyHTML")
library(RCurl)

# Get list of usernames in titledtuesday dataset and assign id
tt_players <- as.data.frame(unique(tt_total$username)) %>%
  mutate(player_id = row_number())

# Change column names
colnames(tt_players) <- c('username', 'player_id')

# Rearrange columns
tt_players <- tt_players %>%
  select(c('player_id', 'username'))

# Create url column
tt_players_2 <- tt_players %>%
  mutate(url = paste0("https://www.chess.com/member/", username))

# Initialize names vector
names <- character(3875)

# Loop through each url to collect displayed name on profile page
for (i in 1:3875) {
  
  # Not every url works properly, so tryCatch is necesssary
  tryCatch({
    url <- tt_players_2$url[i]
    source <- readLines(url, encoding = "UTF-8")
    parsed_doc <- htmlParse(source, encoding = "UTF-8")
    x <- unlist(xpathSApply(parsed_doc, path = '//div[@class="profile-card-name"]', xmlValue))
    names[i] <- paste0(names[i], x)
  },
  warning = function(w){},
  error = function(e){})
}

# Add name column
tt_players$name <- names

# Relic of failed experiment
# Keeping this here saves trouble of changing object names elsehwere
tt_players_3 <- tt_players

# Change column name to account_id
colnames(tt_players_3)[1] <- "account_id"

# Write to csv
write.csv(tt_players_3, 'account.csv', row.names = FALSE)
