#Jesse Haapoja
#IODS third week data wrangling exercise
#Student alcohol consumption data
#data source: https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

#read the datasets student-mat and student-por in to R
student_math <- read.table(file= 'data/student-mat.csv', sep = ";", header= T)
student_por <- read.table(file= 'data/student-por.csv', sep = ";", header= T)

#Check that data is okay with str and summary commands

str(student_math)
summary(student_math)
str(student_por)
summary(student_por)

#combine the datasets

# access the dplyr library
library(dplyr)

# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(student_math, student_por, by = join_by, suffix= c(".math",".por"))

# print out the column names of 'math_por'
colnames(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(student_math)[!colnames(student_math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- select(two_columns, 1)[[1]]
  }
}

# glimpse at the new combined data at this point to see if there is any problems
glimpse(alc)

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

#I want to see what alc_use looks like

summary(alc$alc_use)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

#lets glimpse at the data again
glimpse(alc)

#write the data to data folder
write.table(alc, file='data/alc.txt')