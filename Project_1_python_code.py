from bs4 import BeautifulSoup
import requests
import pandas as pd

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'DNT': '1',  # Do Not Track Request Header
    'Connection': 'close'
}
url_search = 'https://www.formula1.com/en/results.html/2022/races.html'
response = requests.get(url_search, headers=headers, timeout=5)
soup = BeautifulSoup(response.text, 'html.parser')
tag = soup.findAll('a', class_='dark bold ArchiveLink')
url_list = []

for i in tag:
    track_list = []
    string = str(i).split("2022")[1]
    location = string.split("/")[3]
    race_number = string.split("/")[2]
    url_qualifying = 'https://www.formula1.com/en/results.html/2022/races/{}/{}/qualifying.html'.format(race_number,location)
    track_list.append(url_qualifying)
    track_list.append(location)
    url_list.append(track_list)

csv_list = []

raceId = 1074
qualifyId = 9176


def create_quali_data(url, race):
    global raceId, qualifyId
    url_quali = url
    response = requests.get(url_quali, headers=headers, timeout=5)
    soup = BeautifulSoup(response.text, 'html.parser')
    tag = soup.findAll('td', class_='dark')
    quali_data_list = []
    driver_list = []
    for x in tag:
        if tag.index(x) % 6 == 0:
            if tag.index(x) == 0:
                driver_list.append(qualifyId)
                qualifyId += 1
                driver_list.append(raceId)
                driver_list.append(x.text)
            else:
                quali_data_list.append(driver_list)
                driver_list = []
                driver_list.append(qualifyId)
                qualifyId += 1
                driver_list.append(raceId)
                driver_list.append(x.text)
        elif tag.index(x) == 2 or (tag.index(x) - 2) % 6 == 0:
            surname = x.text.split("\n")[2].lower()
            driver_list.append(surname)
        else:
            driver_list.append(x.text)
    raceId += 1
    for row in quali_data_list:
        csv_list.append(row)


header_list = ["qualifyId", "raceId", "position", "number", "driverRef", "q1", "q2", "q3"]
csv_list.append(header_list)

for quali in url_list:
    create_quali_data(quali[0], quali[1])

df = pd.DataFrame(csv_list)
df.to_csv('2022-qualifying.csv', index=False, header=False)
