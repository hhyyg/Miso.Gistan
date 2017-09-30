struct SearchResponse<Item : JSONDecodable> : JSONDecodable {
    let totalCount: Int
    let items: [Item]
    
    init(json: JSON) throws {
        self.totalCount = try json.get(with: "total_count")
        self.items = try json.get(with: "items")
    }
}
