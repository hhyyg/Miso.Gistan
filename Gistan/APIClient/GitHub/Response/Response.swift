struct Repository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let owner: User
}
