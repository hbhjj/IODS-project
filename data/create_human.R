#Week 4 data wrangling

#load the datasets

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#rename variables with dplyr and explore them and check summaries
library(dplyr)

humdev <- rename(hd, HDIRank = HDI.Rank, Country = Country, HDI = Human.Development.Index..HDI.
                 , LifeExpectancy = Life.Expectancy.at.Birth, ExpectedEducation= Expected.Years.of.Education, 
                 Education = Mean.Years.of.Education, GNI = Gross.National.Income..GNI..per.Capita, 
                 GNI_HDI =GNI.per.Capita.Rank.Minus.HDI.Rank )
dim(humdev)
str(humdev)
summary(humdev)

gend <- rename(gii, GIIRank = GII.Rank, GII= Gender.Inequality.Index..GII., 
                 Mort = Maternal.Mortality.Ratio, 
                 BR = Adolescent.Birth.Rate,
                 Rep = Percent.Representation.in.Parliament,
                 EduF = Population.with.Secondary.Education..Female.,
                 EduM = Population.with.Secondary.Education..Male.,
                 LabF = Labour.Force.Participation.Rate..Female.,
                 LabM = Labour.Force.Participation.Rate..Male.)

dim(gend)
str(gend)
summary(gend)

#Create the new variables

gender <- mutate(gend, LabRatio = LabF / LabM, EduRatio = EduF / EduM)

#Combine the data and check if everything is okay
human <- inner_join(humdev,gend,by= "Country")
dim(human)
str(human)

#write the data to data folder
write.table(alc, file='data/human.txt')