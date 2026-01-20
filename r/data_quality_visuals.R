# Clinical Data Quality Visualisation (R)
# Purpose: Simple quality review plots for sample patient data

library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)

df <- read_csv("data/sample_patients.csv", show_col_types = FALSE)

df <- df %>%
  mutate(
    date_of_birth = ymd(date_of_birth),
    dob_valid = !is.na(date_of_birth),
    dob_in_future = dob_valid & date_of_birth > Sys.Date(),
    age_years = ifelse(dob_valid, as.numeric(difftime(Sys.Date(), date_of_birth, units = "days"))/365.25, NA_real_)
  )

# Summary counts (prints in console)
summary_table <- df %>%
  summarise(
    total_rows = n(),
    missing_patient_id = sum(is.na(patient_id)),
    missing_dob = sum(is.na(date_of_birth)),
    dob_in_future = sum(dob_in_future)
  )

print(summary_table)

# Plot: Age distribution (excludes invalid DOB)
ggplot(df %>% filter(!is.na(age_years) & !dob_in_future), aes(x = age_years)) +
  geom_histogram(bins = 10) +
  labs(
    title = "Age Distribution (Valid DOB Only)",
    x = "Age (years)",
    y = "Count"
  )

# Plot: DOB validity flags
df_flags <- df %>%
  mutate(flag = case_when(
    is.na(date_of_birth) ~ "Invalid/Missing DOB",
    dob_in_future ~ "DOB in Future",
    TRUE ~ "DOB Valid"
  ))

ggplot(df_flags, aes(x = flag)) +
  geom_bar() +
  labs(
    title = "DOB Data Quality Flags",
    x = "Flag",
    y = "Count"
  )
