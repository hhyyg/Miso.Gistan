//
//  GistItem.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//
struct GistItem : JSONDecodable {
    let files: [String: GistFile]
    let htmlUrl: String
    
    init(json: JSON) throws {
        files = try (json.get(with: "files") as [String: Any])
            .mapValues { try GistFile(json: JSON($0)) }
        
        htmlUrl = try json.get(with: "html_url")
    }
}

