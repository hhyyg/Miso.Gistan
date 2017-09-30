//
//  GistFile.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//
struct GistFile : JSONDecodable {
    let filename: String
    let type: String
    let language: String
    let rawUrl: String
    let size: Int
        
    init(json: JSON) throws {
        self.filename = try json.get(with: "filename")
        self.type = try json.get(with: "type")
        self.language = try json.get(with: "language")
        self.rawUrl = try json.get(with: "raw_url")
        self.size = try json.get(with: "size")
    }
}
