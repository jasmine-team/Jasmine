"""
This script reads levels.csv and outputs a leaderboards format suitable for upload
"""
import csv
from pathlib import Path

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
                            <achievement_id>combined.playcount.bronze</achievement_id>
                            <reference_name>Total Playcount (10)</reference_name>
                            <points>10</points>
                            <hidden>false</hidden>
                            <locales>
                                <locale name="en-US">
                                    <title>Total Playcount</title>
                                    <before_earned_description>Play 10 games</before_earned_description>
                                    <after_earned_description>10 games, addicted yet?</after_earned_description>
                                    <achievement_after_earned_image>
                                        <size>100071</size>
                                        <file_name>flower-blue.png</file_name>
                                        <checksum type="md5">58740aed62f57b7721da2089f7030d68</checksum>
                                    </achievement_after_earned_image>
                                </locale>
                            </locales>
                        </achievement>
                        <achievement position="2">
                            <achievement_id>combined.playcount.silver</achievement_id>
                            <reference_name>Total Playcount (100)</reference_name>
                            <points>20</points>
                            <hidden>true</hidden>
                            <locales>
                                <locale name="en-US">
                                    <title>Total Playcount</title>
                                    <before_earned_description>Play 100 games</before_earned_description>
                                    <after_earned_description>100 games, nice!</after_earned_description>
                                    <achievement_after_earned_image>
                                        <size>91814</size>
                                        <file_name>flower-purple.png</file_name>
                                        <checksum type="md5">aa5984b97fb472dc11fdc7a6f75c07e7</checksum>
                                    </achievement_after_earned_image>
                                </locale>
                            </locales>
                        </achievement>
                        <achievement position="3">
                            <achievement_id>combined.playcount.gold</achievement_id>
                            <reference_name>Total Playcount (1000)</reference_name>
                            <points>40</points>
                            <hidden>true</hidden>
                            <locales>
                                <locale name="en-US">
                                    <title>Total Playcount</title>
                                    <before_earned_description>Play 1000 games</before_earned_description>
                                    <after_earned_description>1000 games, a true master!</after_earned_description>
                                    <achievement_after_earned_image>
                                        <size>99257</size>
                                        <file_name>flower-gold.png</file_name>
                                        <checksum type="md5">f70b6fb950514333e2a4968b4cde1358</checksum>
                                    </achievement_after_earned_image>
                                </locale>
                            </locales>
                        </achievement>
                    </achievements>
                    <leaderboards>
                        <leaderboard default="true" position="1">
                            <leaderboard_id>combined.all</leaderboard_id>
                            <reference_name>Total Scores</reference_name>
                            <sort_ascending>false</sort_ascending>
                            <locales>
                                <locale name="en-US">
                                    <title>Total Scores</title>
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
                        <leaderboard position="{index}">
                            <leaderboard_id>single.leaderboard.{pos}</leaderboard_id>
                            <reference_name>Leaderboard {pos}</reference_name>
                            <aggregate_parent_leaderboard>combined.all</aggregate_parent_leaderboard>
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
    '''.format(index=pos + 2, pos=pos + 1, level=level).rstrip()

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
