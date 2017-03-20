import XCTest
@testable import Jasmine

class EnglishAPIResponseTests: XCTestCase {

    func testInit() {
        let english = "hello"
        let englishMeaning = "greeting"

        let json = [
            "tuc": [
                [
                    "phrase": [
                        "text": english,
                        "language": "en"
                    ],
                    "meanings": [
                        [
                            "language": "en",
                            "text": englishMeaning
                        ]
                    ]
                ]
            ]
        ]

        let result = try? EnglishAPIResponse(json: json)
        XCTAssertEqual(result?.english, english, "english definition is incorrect")
        XCTAssertEqual(result?.englishMeaning, englishMeaning, "english meaning is incorrect")
    }

}
