import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func fetchData(from urlString: String, completion: @escaping (Result<Data, DataError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL(urlString)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            if let http = response as? HTTPURLResponse,
               !(200...299).contains(http.statusCode) {
                completion(.failure(.httpError(http.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
