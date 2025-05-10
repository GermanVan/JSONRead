import Foundation

struct Item: Codable {
    let id: String
    let login: String
}

enum Role: String, Codable {
    case lead
    case senior
    case middle
    case jun
    case intern
}

struct Permissions: Codable {
    let roles: [Role]
}

struct ResponseData: Codable {
    let identities: [Item]
    let permissions: Permissions
}

