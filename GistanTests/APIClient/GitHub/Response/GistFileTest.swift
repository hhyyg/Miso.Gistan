//
//  GistFileTest.swift
//  GistanTests
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//

import XCTest
@testable import Gistan

class GistFileTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    /// GistItemのJSONパーステスト
    func testParseTest() throws {
        let rawJson = """
{
    "html_url": "https://gist.github.com/9e18f2f16650d89aa37da10b06670d1e",
    "files": {
        "C# 6 exception filter.cs": {
            "filename": "C# 6 exception filter.cs",
            "type": "text/plain",
            "language": "C#",
            "raw_url": "https://gist.githubusercontent.com/hhyyg/9e18f2f16650d89aa37da10b06670d1e/raw/b57deff85fa2f56975a5eb4bf06a9ca2571e97b6/C%23%206%20exception%20filter.cs",
            "size": 917
        }
    }
}
"""
        
        //do
        let result = try! GistItem(json: convertToDictionary(text: rawJson))
        
        //assert
        XCTAssertEqual(result.htmlUrl, "https://gist.github.com/9e18f2f16650d89aa37da10b06670d1e")
        XCTAssertEqual(result.files.count, 1)
        XCTAssertNotNil(result.files["C# 6 exception filter.cs"])
    }
    
    func convertToDictionary(text: String) -> [String: Any] {
        return try! JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: []) as! [String: Any]
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

