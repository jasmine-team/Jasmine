"""
This script scrapes data from many APIs to write to a csv file for conversion to realm file
"""
import urllib.request
import urllib.parse
import json
import csv
from pathlib import Path
from secrets import CHINESE_DICT_API_KEY, CHENG_YU_API_KEY

# URL to translate words between English and Chinese
TRANSLATE_API_URL = 'https://glosbe.com/gapi/translate'
# URL to get Chinese definitions
CHINESE_DICT_API_URL = 'https://api.jisuapi.com/cidian/word'
# URL to get Chinese idiom (cheng yu) definitions
CHENG_YU_API_URL = 'https://api.jisuapi.com/chengyu/detail'
# CSV file to read and write to
CSV_FILE_NAME = 'Phrase.csv'
# CSV file path
CSV_FILE_PATH = Path().parent.joinpath(CSV_FILE_NAME)

def get_json(url, query):
    """Returns json content from a request"""
    url = '{}?{}'.format(url, query)
    request = urllib.request.Request(url)
    response = urllib.request.urlopen(request).read()
    content = json.loads(response.decode('utf-8'))
    return content

def translate_api_query(phrase, from_lang='cmn', to_lang='eng'):
    """Forms a query for the translate api, defaults chinese to eng"""
    query = urllib.parse.urlencode({
        'from': from_lang,
        'dest': to_lang,
        'format': 'json',
        'phrase': phrase,
    })
    try:
        response = get_json(TRANSLATE_API_URL, query)
        answer = response['tuc'][0]
        meaning = next(meaning for meaning in answer['meanings'] if meaning['language'] == 'en')
        return {
            'english': answer['phrase']['text'],
            'chinese': phrase,
            'englishMeaning': meaning['text']
        }
    except (IndexError, TypeError):
        return None

def chinese_dict_api_query(phrase):
    """Forms a query for the chinese dictionary api"""
    query = urllib.parse.urlencode({
        'appkey': CHINESE_DICT_API_KEY,
        'word': phrase,
    })
    try:
        response = get_json(CHINESE_DICT_API_URL, query)
        answer = response['result']
        return {
            'chinese': phrase,
            'pinyin': answer['pinyin'],
            'chineseMeaning': answer['content']
        }
    except (IndexError, TypeError):
        return None

def cheng_yu_api_query(phrase):
    """Forms a query for the chinese cheng yu api"""
    query = urllib.parse.urlencode({
        'appkey': CHENG_YU_API_KEY,
        'chengyu': phrase,
    })
    try:
        response = get_json(CHINESE_DICT_API_URL, query)
        print(response)
        answer = response['result']
        return {
            'chinese': phrase,
            'pinyin': answer['pronounce'],
            'chineseMeaning': answer['content']
        }
    except (IndexError, TypeError):
        return None

def fill_row(row):
    """Forms a row of data for the phrase in chinese"""
    if len(row['chinese']) == 4:
        endpoint = cheng_yu_api_query
    else:
        endpoint = chinese_dict_api_query
    data = endpoint(row['chinese'])
    if data:
        new_row = {**row, **data}
        return new_row
    return row

def update_csv():
    """Reads csv and inputs new api data into it"""
    with open(CSV_FILE_PATH, 'r+') as csvfile:
        reader = csv.DictReader(csvfile)
        new_rows = [fill_row(row) for row in reader]
        for row in new_rows:
            print(row)
        writer = csv.DictWriter(csvfile, fieldnames=reader.fieldnames)
        writer.writerows(new_rows)

def main():
    """Main function that processes apis and converts to output csv format"""
    update_csv()

if __name__ == "__main__":
    main()
