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
    let raw_url: String
    let size: Int
        
    init(json: Any) throws {
        let dict = try JSON(json)
        
        self.filename = try dict.get(with: "filename")
        self.type = try dict.get(with: "type")
        self.language = try dict.get(with: "language")
        self.raw_url = try dict.get(with: "raw_url")
        self.size = try dict.get(with: "size")
    }
}
