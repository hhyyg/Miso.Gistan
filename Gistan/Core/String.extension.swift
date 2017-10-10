//
//  StringHelper.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/09.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation

extension String {

    mutating func remove(_ text: String) {
        self = removing(text)
    }

    func removing(_ text: String) -> String {
        return replacingOccurrences(of: text, with: "")
    }

    func urlEncoding() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }

    func urlDecoding() -> String {
        return self.removingPercentEncoding ?? ""
    }

}
