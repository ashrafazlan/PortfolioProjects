This repository contains projects that I have pursued on my own volition and self interest.

# Project 1: Exploratory Analysis, Web Scraping and Visualization of Formula 1 2022 Qualifying Data  

NOTE: As the current season is still ongoing, this project is valid up until the 2022 Canadian Grand Prix.  
This project has three points of interest: 

1.) I determine whether drivers tend to perform better in qualifying at specific tracks.  
2.) I assess the skill level of drivers compared to their teammates by determining their head to head in qualifying and I also use findings from the first point of interest (if applicable i.e. track bias exists in qualifying) to assess the skill level of drivers.  
3.) I determine the average changes in qualifying session times for each team.  
  
## Methodology  
1.) The dataset is sourced from this [kaggle](https://www.kaggle.com/code/anandaramg/f1-champ-eda-classification-100-accuracy/data?select=circuits.csv) page.    
2.) I preprocessed data in the CSV files using VBA.    
3.) Using MySQL Workbench, I created tables and imported the data from the CSV files into the tables created.  
4.) Using PopSQL and MySQL Workbench, I built queries to analyze the points of interests. Amongst the SQL functions and features used were stored functions, view   creations, nesting CTEs, window functions and multiple JOINs.  
5.) Using Tableau Public, I created visuals for my findings.
