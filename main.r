############################################################
# CS591 – Assignment 3: Git & R
# Author: Shahr Bano Bokhari - Msds25027
# Sakila + R + data.table + CSV + JSON output
############################################################

# ------------------------------
# 1. Load libraries
# ------------------------------
library(data.table)
library(ggplot2)
library(jsonlite)  # For writing JSON files

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
write_json(result1, "task1_films_pg.json", pretty = TRUE)

# 2. Average rental rate grouped by rating
cat("\n--- Task 2: Average rental rate grouped by rating ---\n")
result2 <- film[, .(avg_rental_rate = mean(rental_rate)), by = rating]
print(result2)
write_json(result2, "task2_avg_rental_rate.json", pretty = TRUE)

# 3. Total number of films in each language
cat("\n--- Task 3: Total number of films in each language ---\n")
result3 <- film[
  language,
  on = .(language_id),
  nomatch = 0
][, .(film_count = .N), by = name]
print(result3)
write_json(result3, "task3_film_count_language.json", pretty = TRUE)

# 4. Customer names and the store they belong to
cat("\n--- Task 4: Customer names and the store they belong to ---\n")
result4 <- customer[
  store,
  on = .(store_id),
  nomatch = 0
][, .(first_name, last_name, store_id)]
print(result4)
write_json(result4, "task4_customer_store.json", pretty = TRUE)

# 5. Payment: amount, date, and staff who processed it
cat("\n--- Task 5: Payment amount, date, and staff who processed it ---\n")
result5 <- payment[
  staff,
  on = .(staff_id),
  nomatch = 0
][, .(amount, payment_date, staff_first = first_name, staff_last = last_name)]
print(result5)
write_json(result5, "task5_payment_staff.json", pretty = TRUE)

# 6. Films that are NOT rented
cat("\n--- Task 6: Films that are NOT rented ---\n")
rented_film_ids <- unique(
  inventory[rental, on = .(inventory_id), nomatch = 0]$film_id
)
result6 <- film[!film_id %in% rented_film_ids]
print(result6)
write_json(result6, "task6_not_rented_films.json", pretty = TRUE)

# 7. Plot any graph (example: film count per rating)
cat("\n--- Task 7: Plot - Film count per rating ---\n")
plot_data <- film[, .N, by = rating]

p <- ggplot(plot_data, aes(x = rating, y = N)) +
     geom_bar(stat = "identity") +
     labs(title = "Film Count per Rating",
          x = "Rating",
          y = "Number of Films")

# Save plot as PNG
ggsave("task7_film_count_per_rating.png", plot = p, width = 6, height = 4)
print("Plot saved as task7_film_count_per_rating.png")
