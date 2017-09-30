//
//  GistItem.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//
struct GistItem : JSONDecodable {
    let files: [String: GistFile]
    let html_url: String
    
    init(json: Any) throws {
        let dic = try JSON(json)
        
        files = try (dic.get(with: "files") as [String: Any])
            .mapValues { try GistFile(json: $0) }
        
        html_url = try dic.get(with: "html_url")
    }
}

