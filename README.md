<img src="https://i.imgur.com/QwTvlh3.png" alt="Jasmine logo">

[![Build Status](https://travis-ci.org/jasmine-team/Jasmine.svg?branch=master)](https://travis-ci.org/jasmine-team/Jasmine) [![codecov](https://codecov.io/gh/jasmine-team/jasmine/branch/master/graph/badge.svg)](https://codecov.io/gh/jasmine-team/jasmine) [![codebeat badge](https://codebeat.co/badges/66c01007-b4d6-4f79-a736-300a1ef0410a)](https://codebeat.co/projects/github-com-jasmine-team-jasmine-master)


This iOS app is made as a final project in CS3217.

Team members:
- donjar (Herbert Ilhan Tanujaya)
- li-kai (Li Kai)
- riwu (Ri Wu)
- xdrawks (Wang Xien Dong)

## Generating phrases

1. First copy the secrets file: `cd scripts && cp secrets.example.py secrets.py `
2. Set up environment variables or change within `secrets.py` file
1. Run `python3 api.py` to populate csv file
1. Download [Realm browser](https://itunes.apple.com/sg/app/realm-browser/id1007457278?mt=12) and import csv to turn it into realm file.
1. Replace realm file in `Jasmine/Common/prebundled.realm` with new realm file
