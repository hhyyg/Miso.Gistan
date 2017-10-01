//
//  GitHubClientTest.swift
//  GistanTests
//
//  Created by Hiroka Yago on 2017/10/01.
//  Copyright © 2017 miso. All rights reserved.
//

import XCTest
@testable import Gistan

class GitHubClientTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// API get Gists を実行し、何かしらのレスポンスが返っているか
    func testGetUsersGist() {

        var finished = false
        let userName = "hhyyg"
        let client = GitHubClient()
        let request = GitHubAPI.GetUsersGists(userName: userName)

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNotNil(response[0])
                print(response[0].htmlUrl)
            case let .failure(error):
                print(error)
                XCTAssert(false)
            }
            finished = true
        }
        while !finished {
            RunLoop.current.run(mode: .defaultRunLoopMode, before: .distantFuture)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
