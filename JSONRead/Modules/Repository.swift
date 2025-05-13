import Foundation

class Repository {
    private let network = NetworkService.shared
    private let cache = CacheManager.shared
    private let decoder = JSONDecoder()
    
    func fetchItems(completion: @escaping (Result<[Item], DataError>) -> Void) {
        let cacheKey = "itemData"
        let urlString = "https://run.mocky.io/v3/7999cc1f-3c60-4bed-89ac-1ec82aa24bc5"
        
        if let data = cache.loadData(forKey: cacheKey, validFor: 3600) {
            decode(data: data, completion: completion)
            return
        }
        
        network.fetchData(from: urlString) { result in
            switch result {
            case .success(let data):
                self.cache.save(data: data, forKey: cacheKey)
                self.decode(data: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func decode(data: Data, completion: @escaping (Result<[Item], DataError>) -> Void) {
        do {
            let response = try decoder.decode(ResponseData.self, from: data)
            let sorted = response.identities.sorted { $0.login < $1.login }
            completion(.success(sorted))
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
}

