struct SearchResponse<Item : JSONDecodable> : JSONDecodable {
    let totalCount: Int
    let items: [Item]
    
    init(json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }
        
        guard let totalCount = dictionary["total_count"] as? Int else {
            throw JSONDecodeError.missingValue(
                key: "total_count",
                actualValue: dictionary["total_count"])
        }
        
        guard let itemObjects = dictionary["items"] as? [Any] else {
            throw JSONDecodeError.missingValue(
                key: "items",
                actualValue: dictionary["items"])
        }
        
        let items = try itemObjects.map {
            return try Item(json: $0)
        }
        
        self.totalCount = totalCount
        self.items = items
    }
}
