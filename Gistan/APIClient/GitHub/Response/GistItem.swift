//
//  GistItem.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//
struct GistItem : Codable {
    let files: [String: GistFile]
    let htmlUrl: String
    private enum CodingKeys: String, CodingKey {
        case
        files,
        htmlUrl = "html_url"
    }
}

