This repository contains projects that I have pursued on my own volition and self interest.

# Project 1: Exploratory Analysis, Web Scraping and Visualization of Formula 1 Qualifying Data  

NOTE: This project is valid up until the 2022 Canadian Grand Prix.  
This project has five aims:

1.) Determine whether current drivers tend to perform better in qualifying at specific tracks.  
2.) Determine the win rate of current drivers in qualifying battles vs their teammates for drivers who have more than 100 qualifying rounds entered.  
3.) Assess the skill level of current newer drivers compared to their more experienced teammates by determining their head to head in qualifying and I also use findings from the two previous two points to assess the skill level of drivers.  
4.) Determine the average changes in qualifying session times for each team in 2022.  
5.) Determine the number of Q2 and Q3 appearances for each constructor in 2022 so far. 
  
## Methodology  
1.) The dataset is sourced from this [kaggle](https://www.kaggle.com/code/anandaramg/f1-champ-eda-classification-100-accuracy/data?select=circuits.csv) page.    
2.) Using VBA, I preprocessed data in the CSV files.    
3.) Using MySQL Workbench, I created tables and imported the data from the CSV files into the tables created.  
4.) Using BeautifulSoup in [Python](https://github.com/ashrafazlan/PortfolioProjects/blob/main/Project_1_python_code.py), I scrapped Formula 1 2022 qualifying data.  
5.) Using PopSQL and MySQL Workbench, I built [queries](https://github.com/ashrafazlan/PortfolioProjects/blob/main/Project_1_SQL_code.sql) to realize the aims of the   project. Amongst the SQL functions and features used were stored functions, view creations, nesting CTEs, window functions and multiple JOIN statements.  
6.) Using Tableau Public, I created visuals for my findings.

## Data Visualizations
The first visualization covers the first three aims described earlier while the second visualization covers the aims 4 and 5.  

Visual 1: [F1 2022 Qualifying Head to Head and Qualifying Track Dominations](https://public.tableau.com/app/profile/ashraf.azlan/viz/F12022QualifyingHeadtoHeadandQualifyingTrackDominations/F12022QualifyingHeadtoHeadandQualifyingTrackDominations)  
Visual 2: [F1 2022 Qualifying Session Times Average Differences](https://public.tableau.com/app/profile/ashraf.azlan/viz/F12022QualifyingSessionsTimeDifference/F12022QualifyingSessionsTimeDifferences)
