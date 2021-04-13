library(shiny)
library(data.table)
library(here)
library(plotly)
library(DT)
library(stringr)
library(bslib)

df <- fread(here('data', 'babynames.csv'))
names <- df[, .(label = unique(df$name), value = unique(df$name))]
