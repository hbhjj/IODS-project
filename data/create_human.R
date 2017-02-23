#Week 4 data wrangling

#load the datasets

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#rename variables with dplyr and explore them and check summaries
library(dplyr)

humdev <- rename(hd, HDIRank = HDI.Rank, Country = Country, HDI = Human.Development.Index..HDI.
                 , Life.Exp = Life.Expectancy.at.Birth, Edu.Exp= Expected.Years.of.Education, 
                 Education = Mean.Years.of.Education, GNI = Gross.National.Income..GNI..per.Capita, 
                 GNI_HDI =GNI.per.Capita.Rank.Minus.HDI.Rank )
dim(humdev)
str(humdev)
summary(humdev)

gend <- rename(gii, GIIRank = GII.Rank, GII= Gender.Inequality.Index..GII., 
                 Mat.Mor = Maternal.Mortality.Ratio, 
               Ado.Birth = Adolescent.Birth.Rate,
               Parli.F = Percent.Representation.in.Parliament,
               Edu2.FM = Population.with.Secondary.Education..Female.,
                 EduM = Population.with.Secondary.Education..Male.,
               Labo.FM = Labour.Force.Participation.Rate..Female.,
                 LabM = Labour.Force.Participation.Rate..Male.)

dim(gend)
str(gend)
summary(gend)

#Create the new variables

gend <- mutate(gend, LabRatio = Labo.FM / LabM, EduRatio = Edu2.FM / EduM)

#Combine the data and check if everything is okay
human <- inner_join(humdev,gend,by= "Country")
dim(human)
str(human)

#write the data to data folder
write.table(alc, file='data/human.txt') 

#replace "," with "." in GNI and transform it to numeric
human$GNI <- gsub(",", ".", human$GNI)
human$GNI <- as.numeric(human$GNI)

#select only certain variables
selected_variables <- c( "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(selected_variables))
str(human)