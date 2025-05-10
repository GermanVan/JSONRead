import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let userDefaults = UserDefaults.standard
    private init() {}

    func save(data: Data, forKey key: String) {
        userDefaults.set(data, forKey: key)
        userDefaults.set(Date(), forKey: "\(key)_date")
    }

    func loadData(forKey key: String, validFor seconds: TimeInterval) -> Data? {
        guard let savedDate = userDefaults.object(forKey: "\(key)_date") as? Date else { return nil }
        if Date().timeIntervalSince(savedDate) < seconds {
            return userDefaults.data(forKey: key)
        } else {
            return nil
        }
    }
}


