struct Repository : JSONDecodable {
    let id: Int
    let name: String
    let fullName: String
    let owner: User
    
    init(json: JSON) throws {
        self.id = try! json.get(with: "id")
        self.name = try! json.get(with: "name")
        self.fullName = try! json.get(with: "fullName")
        self.owner = try User(json: try! json.get(with: "owner"))
    }
}
