import Foundation

class Repository {
    private let network = NetworkService.shared
    private let cache = CacheManager.shared

    func fetchItems(completion: @escaping (Result<[Item], Error>) -> Void) {
        let cacheKey = "itemData"
        DispatchQueue.global(qos: .background).async {
            if let data = self.cache.loadData(forKey: cacheKey, validFor: 3600) {
                print("✅ Используем кэшированные данные")
                self.decode(data: data, completion: completion)
            } else {
                let urlString = "https://run.mocky.io/v3/7999cc1f-3c60-4bed-89ac-1ec82aa24bc5"
                print("🌐 Загружаем данные из сети")
                self.network.fetchData(from: urlString) { result in
                    switch result {
                    case .success(let data):
                        print("📦 Данные получены: \(data.count) байт")
                        self.cache.save(data: data, forKey: cacheKey)
                        self.decode(data: data, completion: completion)
                    case .failure(let error):
                        print("❌ Ошибка загрузки: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    private func decode(data: Data, completion: @escaping (Result<[Item], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let decoder = JSONDecoder()
            if let string = String(data: data, encoding: .utf8) {
                print("📥 Полученный JSON:\n\(string)")
            }
            
            do {
                let response = try decoder.decode(ResponseData.self, from: data)
                let sorted = response.identities.sorted { $0.login < $1.login }
                print("🔠 Успешный парсинг, всего элементов: \(sorted.count)")
                completion(.success(sorted))
            } catch {
                print("⚠️ Ошибка декодирования: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
