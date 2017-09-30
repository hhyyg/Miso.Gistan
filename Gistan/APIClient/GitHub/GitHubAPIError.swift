struct GitHubAPIError : JSONDecodable, Error {
    
    struct FieldError : JSONDecodable {
        let resource: String
        let field: String
        let code: String
        
        init(json: JSON) throws {
            self.resource = try json.get(with: "resource")
            self.field = try json.get(with: "field")
            self.code = try json.get(with: "code")
        }
    }
    
    let message: String
    let fieldErrors: [FieldError]
    
    init(json: JSON) throws {        
        let fieldErrorObjects = json.dict["errors"] as? [Any] ?? []
        let fieldErrors = try fieldErrorObjects.map {
            return try FieldError(json: JSON($0))
        }
        
        self.message = try json.get(with: "message")
        self.fieldErrors = fieldErrors
    }
}
