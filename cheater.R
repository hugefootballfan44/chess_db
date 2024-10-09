# Hayden C. Epinette
# Generates cheater data

# Straightforward: create vectors and make them into a dataframe
cheater_id <- c(1, 2, 3, 3, 4, 4, 5, 6, 7)
account_id <- c(468, 747, 1711, 1711, 1810, 1810, 1933, 2895, 3170)
status <- c("Accused", "Accused", "Confirmed", "Accused", "Accused", "Suspected", "Suspected", "Suspected", "Suspected")
platform <- c("OTB", "Online", "Online", "OTB", "OTB", "Online", "Online", "Online", "Online")

cheater <- data.frame(cheater_id = cheater_id, platform = platform, account_id = account_id, status = status)

# Write to csv
write.csv(cheater, 'cheater.csv', row.names = FALSE)
