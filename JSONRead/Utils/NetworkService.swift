import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func fetchData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Неверный URL: \(urlString)"])
            print(error.localizedDescription)
            completion(.failure(error))
            return
        }
        print("Fetching: \(url)")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            if let http = response as? HTTPURLResponse {
                print("HTTP status: \(http.statusCode)")
                guard (200...299).contains(http.statusCode) else {
                    let error = NSError(domain: "HTTPError", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP статус \(http.statusCode)"])
                    completion(.failure(error))
                    return
                }
            }
            guard let data = data else {
                let error = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            print("Received data: \(data.count) bytes")
            completion(.success(data))
        }
        task.resume()
    }
}
    func fetchData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "InvalidURL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                completion(.success(data))
            } else {
                let error = NSError(domain: "NoData", code: 0, userInfo: nil)
                completion(.failure(error))
            }
        }
        task.resume()
    }
