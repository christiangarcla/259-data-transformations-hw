#PSYC 259 Homework 2 - Data Transformation
#For full credit, provide answers for at least 7/10 (7/10)

#List names of students collaborating with:
#Christian Garcia

### SETUP: RUN THIS BEFORE STARTING ----------

#Load packages
library(tidyverse)
ds <- read_csv("data_raw/rolling_stone_500.csv")
  
### Question 1 ---------- 

#Use glimpse to check the type of "Year". 
#Then, convert it to a numeric, saving it back to 'ds'
#Use typeof to check that your conversion succeeded

#ANSWER

#attempt 1
glimpse(ds)

ds$Year <- as.numeric(ds$Year)

typeof(ds$Year)

#the numeric and tyepof function work but I've introduced some NAs because it seems some value contain quotation marks

#Mcomment: your above function works, you can also do - 
ds <- ds %>% mutate(Year = as.numeric(Year))

### Question 2 ---------- 

# Using a dplyr function,
# change ds so that all of the variables are lowercase

#ANSWER

#attempt 1
ds <- ds %>% rename(rank = Rank, song = Song,
                    artist = Artist, year = Year)

view(ds)

#Mcomment:This looks good, and see an alternative below - 
ds <- ds %>% rename_all(tolower)

### Question 3 ----------

# Use mutate to create a new variable in ds that has the decade of the year as a number
# For example, 1971 would become 1970, 2001 would become 2000
# Hint: read the documentation for ?floor

#ANSWER

# Mutate and summarize

#first way
ds <- ds %>% 
  mutate(decade = floor(year))

#second way
ds$decade <- floor(ds$year)

#both of my attmepts failed I got an error that floor() can't be used with numeric or character variables not sure what's going wrong

#Key
ds <- ds %>% mutate(decade = floor(year/10)*10)


### Question 4 ----------

# Sort the dataset by rank so that 1 is at the top

#ANSWER

#attempt 1
ds$rank <- as.character(ds$rank)

str(ds)

ds <- arrange(desc(rank))


#attempt 2 based on error
ds <- arrange(desc(ds$rank))

#Mcomment: Arrange automatically goes low to high, so you shouldn't need any other functions
ds <- ds %>% arrange(rank) #key answer


### Question 5 ----------

# Use filter and select to create a new tibble called 'top10'
# That just has the artists and songs for the top 10 songs

#ANSWER

#attempt 1
top10 < - select(ds, rank) 
filter(ds, rank >11)

#attempt 2
top10 <- select(ds, rank, artist, song)
top10
top10 <- filter(top10, rank < 11)
top10

#hmmm feels like I could optimize this

#Mcomment: Yeah attempt 2 works, but if you use the pipes you can run both in 1 fuction
top10 <- ds %>% filter(rank <= 10) %>% select(artist, song) #in this scenario can be <= 10 or < 11


### Question 6 ----------

# Use summarize to find the earliest, most recent, and average release year
# of all songs on the full list. Save it to a new tibble called "ds_sum"

#ANSWER

#attempt 1
ds_sum <- ds %>% summarize(earliest = min(year, na.rm = T),
                 most_recent = max(year, na.rm = T),
                 average = mean(year, na.rm = T))

#I think I'm on the right track I assume earliest means the min and most recent refers to max
#Mcomment: yupp!

### Question 7 ----------

# Use filter to find out the artists/song titles for the earliest, most 
# recent, and average-ist years in the data set (the values obtained in Q6). 
# Use one filter command only, and sort the responses by year

#ANSWER

#attempt 1

ds_sum <- ds_sum %>%
  filter(year) %>% 
  arrange(year) %>% 

#hmmmm something is missing   

#Mcomment: For this question, you'd wanna use the total dataframe (ds) and then filter using the years from ds_sum

#Option 1-
ds %>% filter(year == round(ds_sum$min_yr) | 
                year == round(ds_sum$mean_yr) | 
                year == round(ds_sum$max_yr) ) %>% arrange(year)

#Option 2 - 
ds %>% 
  filter(year %in% ds_sum) %>% 
  arrange(year)
  
### Question 8 ---------- 

# There's and error here. The oldest song "Brass in Pocket"
# is from 1979! Use mutate and ifelse to fix the error, 
# recalculate decade, and then
# recalculate the responses from Questions 6-7 to
# find the correct oldest, averag-ist, and most recent songs

#ANSWER

#Key
ds  <- ds %>% mutate(year = ifelse(song == "Brass in Pocket", 1979, year),
                     decade = floor(year/10)*10) 
ds %>% summarize(min_yr = min(year, na.rm = T),
                 max_yr = max(year, na.rm = T),
                 mean_yr = mean(year, na.rm = T))
ds %>% filter(year == 1937 | year == 1980 | year == 2020) %>% arrange(year)

### Question 9 ---------

# Use group_by and summarize to find the average rank and 
# number of songs on the list by decade. To make things easier
# filter out the NA values from decade before summarizing
# You don't need to save the results anywhere
# Use the pipe %>% to string the commands together

#ANSWER

#Key
ds %>% filter(!is.na(decade)) %>% 
  group_by(decade) %>% 
  summarize(mean_rank = mean(rank), n_songs = n())

### Question 10 --------

# Look up the dplyr "count" function
# Use it to count up the number of songs by decade
# Then use slice_max() to pull the row with the most songs
# Use the pipe %>% to string the commands together

#Key
ds %>% count(decade) %>% slice_max(n)

#ANSWER

  
