# This script will compile each file of baby names by state from the Social Security Administration into a 
# single table
# https://www.ssa.gov/oact/babynames/limits.html
# https://github.com/cphalpert/census-regions

library(tidyverse)
library(here)

data_dir <- here('data-raw', 'names-by-state')
reg_dir <- here('data-raw', 'census-regions-master')

# List all files in the directory with their absolute path
files <- list.files(data_dir, pattern = '.TXT', full.names = TRUE)

# purrr::partial() creates a new verb that fixes certain arguments of the original verb to our liking.
# This is convenient for when we use purrr::map() later. 
# New function: read_state_file()
read_state_file <- partial(read_delim, 
                            delim = ',', 
                            col_types = cols(
                              X1 = col_character(),
                              X2 = col_character(),
                              X3 = col_integer(),
                              X4 = col_character(),
                              X5 = col_double()
                            ),
                            col_names = FALSE)

# Instead of writing read_delim() 50 times or writing a for loop to read each state file, use purrr::map(). 
# The end result of map() is that each tibble is stored in a list. 
# The verb inside purrr::reduce() will be applied to each tibble recursively. 
# In the end we have one main tibble.
babynames <- map(files, read_state_file) %>% 
  reduce(bind_rows) %>% 
  mutate(X2 = if_else(X2 == 'F', 'Female', 'Male'))

# Let's add column names! It's just easier using base R.
colnames(babynames) <- c('state_code', 'sex', 'year', 'name', 'count')

# Read in file with census regions and divisions 
reg_lookup <- read_csv(here(reg_dir, 'us_census_bureau_regions_and_divisions.csv')) %>% 
  rename_with(str_to_lower)

# Join lookup file to main file
babynames_join <- babynames %>% 
  left_join(reg_lookup, by = c('state_code' = 'state code'))

# Write out data
write_csv(babynames_join, here('data', 'babynames.csv'))

