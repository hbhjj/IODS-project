#Jesse Haapoja
#01.02.2017
#IODS. Second week data wrangling exercise (dataset= learning2014)

#get the data from the internet
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# This checks the dimensions
dim(lrn14)

#Dimensions are: 183 observations, 60 variables

# str is for structure
str(lrn14)

#There is a lot of variables that are named in a way that makes no sense without extra documentation
#Variable explanations can be found from http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS2-meta.txt
#data is in dataframe format
#Gender is the only factor variable

#install package dplyr (this line is not needed if you already have dplyr)

install.packages("dplyr")

# Access the dplyr library
library(dplyr)

#rescale 'Attitude' by creating scaled variable

lrn14$attitude <- lrn14$Attitude/10

# combine questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D07","D14","D22","D30")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")


# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

#lets take the columns we need to analysis data set
# choose a handful of columns to keep
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# lets see the structure of the new dataset and see if everything went as planned at this point
str(learning2014)

#everything seems to be in order, so lets drop the students who have zero points
learning2014 <- subset(learning2014, Points > 0)

#Lets see if theres now less observations

str(learning2014)

#Okay, everything seems to be in order. Time to write the data to the disk
#lets write the learning2014 data set to data-folder and test if it works 
#Path added so that the file goes to data-folder

write.table(learning2014, file='data/learning2014.txt')

test_data <- read.table(file= 'data/learning2014.txt', header=T)

head(test_data)
str(test_data)

