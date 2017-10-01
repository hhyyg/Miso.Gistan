struct User: Codable {
    let id: Int
    let login: String
    let avatarUrl: String

    private enum CodingKeys: String, CodingKey {
        case
        id,
        login,
        avatarUrl = "avatar_url"
    }
}
