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

    private let decoder = JSONDecoder()

    override func setUp() {
        super.setUp()

        decoder.dateDecodingStrategy = .iso8601
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    /// GistItemのJSONパーステスト
    func testParseTest() throws {
        let rawJson = """
{
    "id": "e6507b4f316a0e59b1588c991b7fdd68",
    "created_at": "2017-10-31T07:31:17Z",
    "html_url": "https://gist.github.com/9e18f2f16650d89aa37da10b06670d1e",
    "description": "aiueo",
    "files": {
        "C# 6 exception filter.cs": {
            "filename": "C# 6 exception filter.cs",
            "type": "text/plain",
            "language": "C#",
            "raw_url": "https://gist.githubusercontent.com/hhyyg/9e18f2f16650d89aa37da10b06670d1e/raw/b57deff85fa2f56975a5eb4bf06a9ca2571e97b6/C%23%206%20exception%20filter.cs",
            "size": 917
        }
    },
    "owner": {
      "login": "hhyyg",
      "id": 8636660,
      "avatar_url": "https://avatars0.githubusercontent.com/u/8636660?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/hhyyg",
      "html_url": "https://github.com/hhyyg",
      "followers_url": "https://api.github.com/users/hhyyg/followers",
      "following_url": "https://api.github.com/users/hhyyg/following{/other_user}",
      "gists_url": "https://api.github.com/users/hhyyg/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/hhyyg/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/hhyyg/subscriptions",
      "organizations_url": "https://api.github.com/users/hhyyg/orgs",
      "repos_url": "https://api.github.com/users/hhyyg/repos",
      "events_url": "https://api.github.com/users/hhyyg/events{/privacy}",
      "received_events_url": "https://api.github.com/users/hhyyg/received_events",
      "type": "User",
      "site_admin": false
    },
    "public" : true
}
""".data(using: .utf8)!
        
        //do
        let result = try! decoder.decode(GistItem.self, from: rawJson)
        
        //asset
        XCTAssertEqual(result.id, "e6507b4f316a0e59b1588c991b7fdd68")
        XCTAssertEqual(result.description, "aiueo")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        XCTAssertEqual(result.createdAt, dateFormatter.date(from: "2017-10-31T07:31:17Z")!)
        XCTAssertEqual(result.htmlUrl, "https://gist.github.com/9e18f2f16650d89aa37da10b06670d1e")
        XCTAssertEqual(result.files.count, 1)
        XCTAssertNotNil(result.files["C# 6 exception filter.cs"])
        XCTAssertEqual(result.isPublic, true)
    }

    /// GistItem[]のJSONパーステスト
    func testParseGistItemsTest() throws {
        let rawJson = """
[
  {
    "url": "https://api.github.com/gists/9e18f2f16650d89aa37da10b06670d1e",
    "forks_url": "https://api.github.com/gists/9e18f2f16650d89aa37da10b06670d1e/forks",
    "commits_url": "https://api.github.com/gists/9e18f2f16650d89aa37da10b06670d1e/commits",
    "id": "9e18f2f16650d89aa37da10b06670d1e",
    "git_pull_url": "https://gist.github.com/9e18f2f16650d89aa37da10b06670d1e.git",
    "git_push_url": "https://gist.github.com/9e18f2f16650d89aa37da10b06670d1e.git",
    "html_url": "https://gist.github.com/9e18f2f16650d89aa37da10b06670d1e",
    "files": {
      "C# 6 exception filter.cs": {
        "filename": "C# 6 exception filter.cs",
        "type": "text/plain",
        "language": "C#",
        "raw_url": "https://gist.githubusercontent.com/hhyyg/9e18f2f16650d89aa37da10b06670d1e/raw/b57deff85fa2f56975a5eb4bf06a9ca2571e97b6/C%23%206%20exception%20filter.cs",
        "size": 917
      },
      "C# 7 out var.cs": {
        "filename": "C# 7 out var.cs",
        "type": "text/plain",
        "language": "C#",
        "raw_url": "https://gist.githubusercontent.com/hhyyg/9e18f2f16650d89aa37da10b06670d1e/raw/f10a0f9a80117bfe8c4085e1042a421219f16e9b/C%23%207%20out%20var.cs",
        "size": 824
      }
    },
    "public": true,
    "created_at": "2017-09-22T05:33:03Z",
    "updated_at": "2017-09-27T06:57:03Z",
    "description": "C# note",
    "comments": 0,
    "user": null,
    "comments_url": "https://api.github.com/gists/9e18f2f16650d89aa37da10b06670d1e/comments",
    "owner": {
      "login": "hhyyg",
      "id": 8636660,
      "avatar_url": "https://avatars0.githubusercontent.com/u/8636660?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/hhyyg",
      "html_url": "https://github.com/hhyyg",
      "followers_url": "https://api.github.com/users/hhyyg/followers",
      "following_url": "https://api.github.com/users/hhyyg/following{/other_user}",
      "gists_url": "https://api.github.com/users/hhyyg/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/hhyyg/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/hhyyg/subscriptions",
      "organizations_url": "https://api.github.com/users/hhyyg/orgs",
      "repos_url": "https://api.github.com/users/hhyyg/repos",
      "events_url": "https://api.github.com/users/hhyyg/events{/privacy}",
      "received_events_url": "https://api.github.com/users/hhyyg/received_events",
      "type": "User",
      "site_admin": false
    },
    "truncated": false
  },
  {
    "url": "https://api.github.com/gists/95ffebd7eef4661a592da85190b10db4",
    "forks_url": "https://api.github.com/gists/95ffebd7eef4661a592da85190b10db4/forks",
    "commits_url": "https://api.github.com/gists/95ffebd7eef4661a592da85190b10db4/commits",
    "id": "95ffebd7eef4661a592da85190b10db4",
    "git_pull_url": "https://gist.github.com/95ffebd7eef4661a592da85190b10db4.git",
    "git_push_url": "https://gist.github.com/95ffebd7eef4661a592da85190b10db4.git",
    "html_url": "https://gist.github.com/95ffebd7eef4661a592da85190b10db4",
    "files": {
      "protocol static method.swift": {
        "filename": "protocol static method.swift",
        "type": "text/plain",
        "language": "Swift",
        "raw_url": "https://gist.githubusercontent.com/hhyyg/95ffebd7eef4661a592da85190b10db4/raw/3c9867a2a5fd3425bcd47a5d3cdfb91350343ce9/protocol%20static%20method.swift",
        "size": 332
      }
    },
    "public": true,
    "created_at": "2017-08-30T04:33:13Z",
    "updated_at": "2017-08-30T04:33:13Z",
    "description": "protocol static 実験",
    "comments": 0,
    "user": null,
    "comments_url": "https://api.github.com/gists/95ffebd7eef4661a592da85190b10db4/comments",
    "owner": {
      "login": "hhyyg",
      "id": 8636660,
      "avatar_url": "https://avatars0.githubusercontent.com/u/8636660?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/hhyyg",
      "html_url": "https://github.com/hhyyg",
      "followers_url": "https://api.github.com/users/hhyyg/followers",
      "following_url": "https://api.github.com/users/hhyyg/following{/other_user}",
      "gists_url": "https://api.github.com/users/hhyyg/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/hhyyg/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/hhyyg/subscriptions",
      "organizations_url": "https://api.github.com/users/hhyyg/orgs",
      "repos_url": "https://api.github.com/users/hhyyg/repos",
      "events_url": "https://api.github.com/users/hhyyg/events{/privacy}",
      "received_events_url": "https://api.github.com/users/hhyyg/received_events",
      "type": "User",
      "site_admin": false
    },
    "truncated": false
  }
]

""".data(using: .utf8)!

        //do
        let result = try! decoder.decode([GistItem].self, from: rawJson)

        //asset
        result.forEach{ print($0) }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

