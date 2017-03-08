#Vaalikonedata data wrangling
#Read the data from avoindata.fi
vaalikone <- read.csv2("https://www.avoindata.fi/dataset/2529cd52-35aa-4cd7-8ebf-d5176cf1d913/resource/c0bc8c55-3a2f-4902-b20d-fefab92189b8/download/vastauksetavoimenadatana1.csv")

library(dplyr)

#check structure and dimensions
str(vaalikone)
dim(vaalikone)

#rename the variables that I want to use in the model

vaalikone <- rename(vaalikone, too_easy_welfare = X127.Suomessa.on.liian.helppo.el.....sosiaaliturvan.varassa, party = puolue, basic_income = X129.Suomessa.on.siirrytt..v...perustuloon.joka.korvaisi.nykyisen.sosiaaliturvan.v..himm..istason.
       , shorter_unempl_benefit = X131.Ansiosidonnaisen.ty..tt..myysturvan.kestoa.pit.....lyhent....., gov_spend_cuts = X134.Valtion.ja.kuntien.taloutta.on.tasapainotettava.ensisijaisesti.leikkaamalla.menoja., 
        cant_afford_current_h_spending = X136.Suomella.ei.ole.varaa.nykyisen.laajuisiin.sosiaali..ja.terveyspalveluihin. )
#I will attach the vaalikone dataset so that I can write some code in a bit shorter form
attach(vaalikone)

#lets see how the factors are named in some of the the variables we renamed
unique(shorter_unempl_benefit)
unique(basic_income)
unique(too_easy_welfare)
unique(cant_afford_current_h_spending)
unique(gov_spend_cuts)
unique(party)
detach(vaalikone)
#now, lets create a dataset that only has variables of interest and id

variables_of_interest <- c( "id", "party", "shorter_unempl_benefit", "basic_income", "too_easy_welfare", "cant_afford_current_h_spending", "gov_spend_cuts")
vaalikone <- select(vaalikone, one_of(variables_of_interest))

#lets recode the variables so that not agreeing is small numbers (1-2) and agreeing 3 and 4. Skipping question will be recoded as missing.
#This way we will get a likert scale of 1-4, 1 being not agreeing at all and 4 agreeing very much

vaalikone$shorter_unempl_benefit <- gsub("t\303\244ysin samaa mielt\303\244", "4", vaalikone$shorter_unempl_benefit)
vaalikone$shorter_unempl_benefit <- gsub("jokseenkin samaa mielt\303\244", "3", vaalikone$shorter_unempl_benefit)
vaalikone$shorter_unempl_benefit <- gsub("jokseenkin eri mielt\303\244", "2", vaalikone$shorter_unempl_benefit)
vaalikone$shorter_unempl_benefit <- gsub("t\303\244ysin eri mielt\303\244", "1", vaalikone$shorter_unempl_benefit)
vaalikone$shorter_unempl_benefit <- gsub("ohita kysymys", "", vaalikone$shorter_unempl_benefit)


vaalikone$basic_income <- gsub("t\303\244ysin samaa mielt\303\244", "4", vaalikone$basic_income)
vaalikone$basic_income <- gsub("jokseenkin samaa mielt\303\244", "3", vaalikone$basic_income)
vaalikone$basic_income <- gsub("jokseenkin eri mielt\303\244", "2", vaalikone$basic_income)
vaalikone$basic_income <- gsub("t\303\244ysin eri mielt\303\244", "1", vaalikone$basic_income)
vaalikone$basic_income <- gsub("ohita kysymys", "", vaalikone$basic_income)


vaalikone$too_easy_welfare <- gsub("t\303\244ysin samaa mielt\303\244", "4", vaalikone$too_easy_welfare)
vaalikone$too_easy_welfare <- gsub("jokseenkin samaa mielt\303\244", "3", vaalikone$too_easy_welfare)
vaalikone$too_easy_welfare <- gsub("jokseenkin eri mielt\303\244", "2", vaalikone$too_easy_welfare)
vaalikone$too_easy_welfare <- gsub("t\303\244ysin eri mielt\303\244", "1", vaalikone$too_easy_welfare)
vaalikone$too_easy_welfare <- gsub("ohita kysymys", "", vaalikone$too_easy_welfare)



vaalikone$cant_afford_current_h_spending <- gsub("t\303\244ysin samaa mielt\303\244", "4", vaalikone$cant_afford_current_h_spending)
vaalikone$cant_afford_current_h_spending <- gsub("jokseenkin samaa mielt\303\244", "3", vaalikone$cant_afford_current_h_spending)
vaalikone$cant_afford_current_h_spending <- gsub("jokseenkin eri mielt\303\244", "2", vaalikone$cant_afford_current_h_spending)
vaalikone$cant_afford_current_h_spending <- gsub("t\303\244ysin eri mielt\303\244", "1", vaalikone$cant_afford_current_h_spending)
vaalikone$cant_afford_current_h_spending <- gsub("ohita kysymys", "", vaalikone$cant_afford_current_h_spending)

vaalikone$gov_spend_cuts <- gsub("t\303\244ysin samaa mielt\303\244", "4", vaalikone$gov_spend_cuts)
vaalikone$gov_spend_cuts <- gsub("jokseenkin samaa mielt\303\244", "3", vaalikone$gov_spend_cuts)
vaalikone$gov_spend_cuts <- gsub("jokseenkin eri mielt\303\244", "2", vaalikone$gov_spend_cuts)
vaalikone$gov_spend_cuts <- gsub("t\303\244ysin eri mielt\303\244", "1", vaalikone$gov_spend_cuts)
vaalikone$gov_spend_cuts <- gsub("ohita kysymys", "", vaalikone$gov_spend_cuts)

#Create a variable that indicates government or opposition membership in parliament. Parties not in parliament will be empty
vaalikone$gov_or_op <- factor(rep(NA, length(vaalikone$party) ), 
                              levels=c("government", "opposition") )   
vaalikone$gov_or_op[ vaalikone$party %in% c("Perussuomalaiset", "Kansallinen Kokoomus", "Suomen Keskusta")] <- "government"
vaalikone$gov_or_op[ vaalikone$party %in% c("Suomen ruotsalainen kansanpuolue", "Vihre\303\244 liitto", "Vasemmistoliitto","Suomen Sosialidemokraattinen Puolue","Suomen Kristillisdemokraatit (KD)")] <- "opposition"

#We want to make certain, that only the parties in the parliament are in the data set.
#Also, we will transform the party variable to character and back to factor. R otherwise reported it still having 42 different levels, even though there is only 8 parties in it
vaalikone <- subset(vaalikone, vaalikone$party %in% c("Perussuomalaiset", "Kansallinen Kokoomus", "Suomen Keskusta","Suomen ruotsalainen kansanpuolue", "Vihre\303\244 liitto", "Vasemmistoliitto","Suomen Sosialidemokraattinen Puolue","Suomen Kristillisdemokraatit (KD)"))
vaalikone$party <- as.character(vaalikone$party)
vaalikone$party <- as.factor(vaalikone$party)
#turn some variables into numeric and keep only complete cases

vaalikone$shorter_unempl_benefit <- as.numeric(vaalikone$shorter_unempl_benefit)
vaalikone$basic_income <- as.numeric(vaalikone$basic_income)
vaalikone$too_easy_welfare <- as.numeric(vaalikone$too_easy_welfare)
vaalikone$cant_afford_current_h_spending <- as.numeric(vaalikone$cant_afford_current_h_spending)
vaalikone$gov_spend_cuts <- as.numeric(vaalikone$gov_spend_cuts)


vaalikone<- vaalikone[complete.cases(vaalikone), ]
#check that nothing went wrong
str(vaalikone)
dim(vaalikone)
#ready for the main part





