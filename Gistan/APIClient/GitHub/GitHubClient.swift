import Foundation
import RxSwift

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
        completion: @escaping (Data) -> Void ) -> Observable<Data> {

        return Observable.create { observer in
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            let token = KeychainService.get(forKey: .oauthToken)!
            urlRequest.addValue("token \(token)", forHTTPHeaderField: "Authorization")

            let task = self.session.dataTask(with: urlRequest) { data, response, error in
                switch (data, response, error) {
                case (let data?, _, _):
                    observer.onNext(data)
                    observer.onCompleted()
                default:
                    logger.error("error")
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }

    func send<Request: GitHubRequest>(request: Request) -> Observable<Request.Response> {

        return Observable.create { observer in

            let urlRequest = request.buildURLRequest()
            let task = self.session.dataTask(with: urlRequest) { data, response, error in

                switch (data, response, error) {
                case (_, _, let error?):
                    observer.onError(error)
                case (let data?, let response?, _):
                    do {
                        let response = try request.response(from: data, urlResponse: response)
                        observer.onNext(response)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                default:
                    fatalError("invalid response combination \(String(describing: data)), \(String(describing: response)), \(String(describing: error)).")
                }

            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
