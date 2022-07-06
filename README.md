This repository contains projects that I have pursued on my own volition and self interest.

# Project 1: Exploratory Analysis, Web Scraping and Visualization of Formula 1 Qualifying Data  

NOTE: As the current season is still ongoing, this project is valid up until the 2022 Canadian Grand Prix.  
This project has four points of interest: 

1.) I determine whether current drivers tend to perform better in qualifying at specific tracks.  
2.) I determine the win rate of current drivers in qualifying battles vs their teammates for drivers who have more than 100 qualifying rounds entered.  
3.) I assess the skill level of newer drivers compared to their more experienced teammates by determining their head to head in qualifying and I also use findings from the two previous point of interests to assess the skill level of drivers.  
4.) I determine the average changes in qualifying session times for each team.  
  
## Methodology  
1.) The dataset is sourced from this [kaggle](https://www.kaggle.com/code/anandaramg/f1-champ-eda-classification-100-accuracy/data?select=circuits.csv) page.    
2.) Using VBA, I preprocessed data in the CSV files.    
3.) Using MySQL Workbench, I created tables and imported the data from the CSV files into the tables created.  
4.) Using BeautifulSoup in Python, I scrapped Formula 1 2022 qualifying data.
5.) Using PopSQL and MySQL Workbench, I built queries to realize the points of interests. Amongst the SQL functions and features used were stored functions, view   creations, nesting CTEs, window functions and multiple JOIN statements.  
6.) Using Tableau Public, I created visuals for my findings.
