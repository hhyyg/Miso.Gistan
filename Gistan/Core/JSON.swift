//
//  JSON.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//
struct JSON {
    let dict: [String: Any]

    init(_ json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }
        self.dict = dictionary
    }
    func get<T>(with key: String) throws -> T {
        if let val = dict[key] as? T {
            return val
        }
        throw JSONDecodeError.missingValue(key: key, actualValue: nil)
    }
}
