"""
This script reads levels.csv and outputs a leaderboards format suitable for upload
"""
import csv
from pathlib import Path, PurePath

# scripts folder
PWD = Path(__file__).parent
# CSV file to read from
CSV_FILE_NAME = 'Level.csv'
# CSV file to read from
XML_FILE_NAME = 'metadata.xml'
# CSV file path
CSV_FILE_PATH = PWD.parent.joinpath(CSV_FILE_NAME)
# Write path
XML_FILE_PATH = PWD.joinpath('1223383989.itmsp', XML_FILE_NAME)

def fill_header(leaderboards):
    """Fills in xml config header"""
    return '''
    <?xml version="1.0" encoding="UTF-8"?>
    <package version="software5.5" xmlns="http://apple.com/itunes/importer">
        <!-- This document was generated on Apr 14, 2017 9:52:53 AM for riwu0730@gmail.com <riwu0730@gmail.com>. -->
        <!-- NOTE: metadata_token is generated on lookup.  Modifying the value of this will result in an import error -->
        <metadata_token>1492188773217-767d828689288dc95dd92cd927c4db897e21357143e3bfa9df0617c4af0af025</metadata_token>
        <provider>QX6E2SX99X</provider>
        <team_id>QX6E2SX99X</team_id>
        <software>
            <!--Apple ID: 1223383989-->
            <vendor_id>nus.cs3217.Jasmine.Jasmine</vendor_id>
            <read_only_info>
                <read_only_value key="apple-id">1223383989</read_only_value>
            </read_only_info>
            <software_metadata app_platform="ios">
                <versions>
                    <version string="1.0">
                        <locales>
                            <locale name="en-GB">
                                <title>Jasmine</title>
                            </locale>
                        </locales>
                    </version>
                </versions>
                <game_center>
                    <achievements>
                        <achievement position="1">
                            <achievement_id>test.first</achievement_id>
                            <reference_name>First Game \o/</reference_name>
                            <points>1</points>
                            <hidden>false</hidden>
                            <locales>
                                <locale name="en-US">
                                    <title>First Game Played</title>
                                    <before_earned_description>Try it~</before_earned_description>
                                    <after_earned_description>Welcome to Jasmine!</after_earned_description>
                                    <achievement_after_earned_image>
                                        <size>76443</size>
                                        <file_name>test.png</file_name>
                                        <checksum type="md5">f5246f93bb957b7b004aa42c91133f38</checksum>
                                    </achievement_after_earned_image>
                                </locale>
                            </locales>
                        </achievement>
                    </achievements>
                    <leaderboards>
                        <leaderboard default="true" position="1">
                            <leaderboard_id>single.leaderboard.1</leaderboard_id>
                            <reference_name>Leaderboard 1</reference_name>
                            <sort_ascending>false</sort_ascending>
                            <score_range_min>0</score_range_min>
                            <score_range_max>1000000</score_range_max>
                            <locales>
                                <locale name="en-US">
                                    <title>Me, Family and Friends</title>
                                    <formatter_suffix>points</formatter_suffix>
                                    <formatter_suffix_singular>point</formatter_suffix_singular>
                                    <formatter_type>INTEGER_COMMA_SEPARATOR</formatter_type>
                                </locale>
                            </locales>
                        </leaderboard>
{}
                    </leaderboards>
                </game_center>
            </software_metadata>
        </software>
    </package>
    '''.format(leaderboards).strip()

def fill_leaderboard(pos, level):
    """Takes in a level and creates a xml config"""
    return '''\
                        <leaderboard position="{pos}">
                            <leaderboard_id>single.leaderboard.{pos}</leaderboard_id>
                            <reference_name>Leaderboard {pos}</reference_name>
                            <sort_ascending>false</sort_ascending>
                            <score_range_min>0</score_range_min>
                            <score_range_max>1000000</score_range_max>
                            <locales>
                                <locale name="en-US">
                                    <title>{level[name]}</title>
                                    <formatter_suffix>points</formatter_suffix>
                                    <formatter_suffix_singular>point</formatter_suffix_singular>
                                    <formatter_type>INTEGER_COMMA_SEPARATOR</formatter_type>
                                </locale>
                            </locales>
                        </leaderboard>
    '''.format(pos=pos + 2, level=level).rstrip()

def create_metadata():
    """Reads csv and inputs new game center data into it"""
    metadata_content = []
    with open(CSV_FILE_PATH, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        metadata_content = [fill_leaderboard(idx, level) for idx, level in enumerate(reader)]
    content = fill_header("\n".join(metadata_content))
    with open(XML_FILE_PATH, 'w') as file:
        file.write(content)

def main():
    """Main function that processes apis and converts to output csv format"""
    create_metadata()

if __name__ == "__main__":
    main()
