import Foundation

class GitHubClient {

    var token: String?

    init() {
    }

    init(token: String?) {
        self.token = token
    }

    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()

    func getData(
        url: URL,
        completion: @escaping (Data) -> Void ) {

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        let token = KeychainService.get(forKey: .oauthToken)!
        urlRequest.addValue("token \(token)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: urlRequest) { data, response, error in
            switch (data, response, error) {
            case (let data?, _, _):
                completion(data)
            default:
                //TODO:assertionFailure
                assertionFailure()
            }
        }

        task.resume()
    }

    func send<Request: GitHubRequest>(
        request: Request,
        completion: @escaping (Result<Request.Response, GitHubClientError>) -> Void) {

        let urlRequest = request.buildURLRequest()
        let task = session.dataTask(with: urlRequest) { data, response, error in
            switch (data, response, error) {
            case (_, _, let error?):
                completion(Result(error: .connectionError(error)))
            case (let data?, let response?, _):
                do {
                    let response = try request.response(from: data, urlResponse: response)
                    completion(Result(value: response))
                } catch let error as GitHubAPIError {
                    completion(Result(error: .apiError(error)))
                } catch {
                    completion(Result(error: .responseParseError(error)))
                }
            default:
                fatalError("invalid response combination \(String(describing: data)), \(String(describing: response)), \(String(describing: error)).")
            }
        }

        task.resume()
    }
}
