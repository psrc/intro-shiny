# This script will compile each file of baby names by state from the Social Security Administration into a 
# single table
# https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-data-by-state-and-district-of-
# https://www.ssa.gov/oact/babynames/limits.html

library(tidyverse)
library(here)

data.dir <- here('data-raw', 'names-by-state') 

# List all files in the directory with their absolute path
files <- list.files(data.dir, pattern = '.TXT', full.names = TRUE)

# purrr::partial() is an adverb. We create a new verb that modifies the default arguments of the original verb.
# This is convenient for when we use purrr::map() in the next step. 
# map() calls another function to do all the stuff. 

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
colnames(babynames) <- c('state', 'sex', 'year', 'name', 'count')

# Write out data
write_csv(babynames, here('data', 'babynames.csv'))

