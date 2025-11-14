############################################################
# CS591 – Assignment 3: Git & R
# Author: Shahr Bano Bokhari - Msds25027
# Sakila + R + data.table + CSV
############################################################

# ------------------------------
# 1. Load libraries
# ------------------------------
library(data.table) # Fast data operations
library(ggplot2)    # Plotting

# ------------------------------
# 2. Load CSVs
# ------------------------------
film       <- fread("film.csv")
language   <- fread("language.csv")
customer   <- fread("customer.csv")
store      <- fread("store.csv")
payment    <- fread("payment.csv")
rental     <- fread("rental.csv")
inventory  <- fread("inventory.csv")
staff      <- fread("staff.csv")

# ------------------------------
# 3. Assignment Tasks
# ------------------------------

# 1. Films with rating = PG and rental duration > 5
cat("\n--- Task 1: Films with rating = PG and rental duration > 5 ---\n")
result1 <- film[rating == "PG" & rental_duration > 5]
print(result1)

# 2. Average rental rate grouped by rating
cat("\n--- Task 2: Average rental rate grouped by rating ---\n")
result2 <- film[, .(avg_rental_rate = mean(rental_rate)), by = rating]
print(result2)

# 3. Total number of films in each language
cat("\n--- Task 3: Total number of films in each language ---\n")
result3 <- film[
  language,
  on = .(language_id),
  nomatch = 0
][, .(film_count = .N), by = name]  # language name
print(result3)

