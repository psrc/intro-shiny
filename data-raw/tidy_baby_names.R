# this script will compile each file of baby names by state from the Social Security Administration into a 
# single table
# https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-data-by-state-and-district-of-
# https://www.ssa.gov/oact/babynames/limits.html

library(tidyverse)
library(here)

data.dir <- here('data-raw', 'names-by-state') 

# list all files in the directory with their absolute path
files <- list.files(data.dir, pattern = '.TXT', full.names = TRUE)

# purrr::partial() is an adverb. We create a new verb that fixes certain arguments of the original verb.
# This is convenient when we use the purrr::map() in the next step where we use a function to call another function
# to do stuff.
read_state_files <- partial(read_delim, 
                            delim = ',', 
                            col_types = cols(
                              X1 = col_character(),
                              X2 = col_character(),
                              X3 = col_integer(),
                              X4 = col_character(),
                              X5 = col_double()
                            ),
                            col_names = FALSE)

# instead of writing a for loop to read each state file, purrr::map() can do that. Each tibble is stored in a 
# list. Then the verb inside purrr::reduce() will be applied to each tibble recursively so that we end up with one
# main tibble.
babynames <- map(files, read_state_files) %>% 
  reduce(bind_rows) %>% 
  mutate(X2 = if_else(X2 == 'F', 'Female', 'Male'))

# let's add column names! It's just easier using base R.
colnames(babynames) <- c('state', 'sex', 'year', 'name', 'count')

# write out data
write_csv(babynames, here('data', 'babynames.csv'))

