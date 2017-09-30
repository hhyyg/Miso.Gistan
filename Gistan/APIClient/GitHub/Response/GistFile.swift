//
//  GistFile.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//
struct GistFile : Codable {
    let filename: String
    let type: String
    let language: String
    let rawUrl: String
    let size: Int
    
    private enum CodingKeys: String, CodingKey {
        case
        filename,
        type,
        language,
        rawUrl = "raw_url",
        size
    }
}
