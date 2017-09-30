struct User : JSONDecodable {
    let id: Int
    let login: String
    
    init(json: JSON) throws {
        self.id = try json.get(with: "id")
        self.login = try json.get(with: "login")
    }
}
