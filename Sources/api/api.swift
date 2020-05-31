import Foundation
import RxSwift

protocol APIRequest {
    associatedtype Result: Decodable
    
    var endpoint  : String { get }
    var parameters: Dictionary<String, String> { get }
}

public class API {
    private static let baseURL: URL = URL(string: "http://api.openweathermap.org/data/2.5")!
    
    private let decoder: JSONDecoder = JSONDecoder()
    private let session: URLSession  = URLSession(configuration: .default)
    
    private let apiKey : String
    
    /// Initializer
    /// - Parameter key: The API Key to be used
    public required init(_ key: String) {
        apiKey = key
    }
    
    enum APIError: Error {
        case unknownNetworkError
    }
    
    internal func _request<T: APIRequest>(_ request: T) -> Single<T.Result> {
        return Single<T.Result>.create { observer -> Disposable in
            let built = self._build(request)
            
            let task = self.session.dataTask(with: built) { data, response, error in
                if let data = data {
                    do {
                        let json = try self.decoder.decode(T.Result.self, from: data)
                        observer(.success(json))
                    } catch {
                        observer(.error(error))
                    }
                } else if let error = error {
                    observer(.error(error))
                } else {
                    observer(.error(APIError.unknownNetworkError))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func _build<T: APIRequest>(_ request: T) -> URLRequest {
        var params = request.parameters
        params["appid"] = apiKey
        
        let url = API.baseURL.appendingPathComponent(request.endpoint)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = params.map { (k, v) -> URLQueryItem in
            return URLQueryItem(name: k, value: v)
        }
        
        return URLRequest(url: components.url!)
    }
}
