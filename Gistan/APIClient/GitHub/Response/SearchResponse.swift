struct SearchResponse<Item : Codable> : Codable {
    // TODO:
    let totalCount: Int
    let items: [Item]
}
