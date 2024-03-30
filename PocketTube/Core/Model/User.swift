import Firebase
import Foundation

struct User: Identifiable, Codable {
    let userName: String
    let email: String
//    let phone: String
    var profileImageUrl: String?
    let id: String
    
    var isCurrentUser: Bool {
        return id == Auth.auth().currentUser?.uid
    }
}

struct UserStats: Codable {
    var mediasCount: Int
}

extension User: Hashable {
    var identifier: String { return id }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
