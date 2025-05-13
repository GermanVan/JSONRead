import Foundation

enum DataError: Error {
    case invalidURL(String)
    case networkError(Error)
    case httpError(Int)
    case noData
    case decodingError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL(let url): return "Неверный URL: \(url)"
        case .networkError(let error): return "Сетевая ошибка: \(error.localizedDescription)"
        case .httpError(let code): return "HTTP ошибка: статус \(code)"
        case .noData: return "Нет данных от сервера"
        case .decodingError(let error): return "Ошибка декодирования: \(error.localizedDescription)"
        }
    }
}

struct Item: Codable {
    let id: String
    let login: String
}

enum Role: String, Codable {
    case lead, senior, middle, jun, intern
}

struct Permissions: Codable {
    let roles: [Role]
}

struct ResponseData: Codable {
    let identities: [Item]
    let permissions: Permissions
}

