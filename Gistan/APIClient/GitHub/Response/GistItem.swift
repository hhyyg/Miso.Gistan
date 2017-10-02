//
//  GistItem.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//
import Foundation

struct GistItem: Codable {
    let files: [String: GistFile]
    let htmlUrl: String
    let description: String
    let createdAt: Date
    let owner: User

    private enum CodingKeys: String, CodingKey {
        case
        files,
        htmlUrl = "html_url",
        description,
        createdAt = "created_at",
        owner
    }

    /// 最初のファイルの名前を取得します
    func getFirstFileName() -> String {
        return Array(files)[0].key
    }

    /// createdAtのテキストを取得します
    func getCreatedAtText() -> String {
        return DateFormatter.createdAt.string(from: createdAt)
    }
}
