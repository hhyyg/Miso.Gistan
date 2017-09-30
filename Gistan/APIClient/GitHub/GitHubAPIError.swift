struct GitHubAPIError: Codable, Error {

    struct FieldError: Codable {
        let resource: String
        let field: String
        let code: String
    }

    let message: String
    let fieldErrors: [FieldError]
}
