# Hayden C. Epinette
# Creates opening table data

# Import necessary package
library(dplyr)

# Initialize eco
eco <- NULL

# Create all 500 eco codes
for (letter in c('A', 'B', 'C', 'D', 'E')) {
  for (digit_1 in as.character(0:9)) {
    for (digit_2 in as.character(0:9)) {
      y <- paste0(letter, digit_1, digit_2)
      eco <- c(eco, y)
    }
  }
}

# Create vector of all opening names to be paired with eco codes in dataframe
name <- rep(c("Unorthodox Openings", "Nimzovich-Larsen Attack",
              "Bird's Opening", "Reti Opening",
              "English Opening", "Queen's Pawn",
              "Modern Defence, Averbakh System",
              "Old Benoni Defence", "Queen's Pawn Game",
              "Queen's Indian Defence",
              "King's Indian, East Indian Defence", "Queen's Pawn Game",
              "Budapest Defence", "Old Indian Defence", "Benoni Defence",
              "Benko Gambit", "Benoni Defence", "Dutch", "King's Pawn Opening",
              "Scandinavian (Centre Counter) Defence", "Alekhine's Defence",
              "Robatsch (Modern) Defence", "Pirc Defence", "Caro-Kann Defence",
              "Sicilan Defence", "French Defence", "King's Pawn Game", "Centre Game",
              "Bishop's Opening", "Vienna Game", "King's Gambit", "King's Knight Opening",
              "Philidor's Defence", "Petrov's Defence", "King's Pawn Game", "Scotch Game",
              "Three Knights Game", "Four Knights, Scotch Variation", "Italian Game",
              "Evans Gambit", "Giuoco Piano", "Two Knights Defence", "Ruy Lopez (Spanish Opening)",
              "Queen's Pawn Game", "Richter-Veresov Attack", "Queen's Pawn Game",
              "Torre Attack (Tartakower Variation)", "Queen's Pawn Game", "Queen's Gambit", "Queen's Gambit Declined, Chigorin Defence",
              "Queen's Gambit Declined Slav Defence", "Queen's Gambit Declined Slav Accepted, Alapin Variation",
              "Queen's Gambit Declined Slav, Czech Defence", "Queen's Gambit Accepted", "Queen's Gambit Declined", "Queen's Gambit Declined Semi-Slav",
              "Queen's Gambit Declined, 4.Bg5", "Neo-Gruenfeld Defence", "Gruenfeld Defence",
              "Queen's Pawn Game" ,"Catalan, Closed", "Queen's Pawn Game", "Bogo-Indian Defence", "Queen's Indian Defence",
              "Nimzo-Indian Defence", "King's Indian Defence"), 
            c(1, 1, 2, 6, 30, 2, 1, 2, 2, 1, 2, 1, 2, 3, 1, 3, 20, 20,
              1, 1, 4, 1, 3, 10, 80,
              20, 1, 2, 2, 5, 10, 1, 1, 2, 1, 1, 1, 3, 1, 2, 2, 5, 40,
              1, 1, 1, 1, 2, 1, 3, 6, 1, 3, 10, 13, 7, 20, 10, 20,
              1, 9, 1, 1, 8, 40, 40))

# Create dataframe
opening <- data.frame(eco = eco, name = name)

# Write to csv
write.csv(opening, 'opening.csv', row.names = FALSE)
