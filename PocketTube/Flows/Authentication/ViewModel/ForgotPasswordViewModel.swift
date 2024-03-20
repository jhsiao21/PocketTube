import Foundation

struct ForgotPasswordViewModel {
    
    func sendPasswordResetEmail(toEmail: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        AuthService.shared.sendPasswordResetEmail(toEmail: toEmail) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
