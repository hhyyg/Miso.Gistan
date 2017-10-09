//
//  StringExtension.swift
//  GistanTests
//
//  Created by Hiroka Yago on 2017/10/09.
//  Copyright © 2017 miso. All rights reserved.
//


import XCTest
@testable import Gistan

class StringExtensionTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRemove() {
        var text = "ab.c.d"
        text.remove(".")
        XCTAssertEqual(text, "abcd")
    }

    func testRemoveNoHit() {
        var text = "abcd"
        text.remove(".")
        XCTAssertEqual(text, "abcd")
    }

    func testRemoving() {
        let text = "ab.c.d"
        XCTAssertEqual(text.removing("."), "abcd")
    }
}

