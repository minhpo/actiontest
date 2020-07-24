import Foundation
import SwiftKeychainWrapper

protocol LoginWorker {
    func setSecret(_ secret: String)
    func getSecret() -> String?
    func removeSecret()
    
    var isLoggedIn: Bool { get }
}

final class LoginService: LoginWorker {
    
    private let keychainWrapper: KeychainWrapper
    
    init(keychainWrapper: KeychainWrapper = KeychainWrapper.standard) {
        self.keychainWrapper = keychainWrapper
    }
    
    func setSecret(_ secret: String) {
        keychainWrapper.set(secret, forKey: Keys.secret.rawValue)
    }
    
    func getSecret() -> String? {
        keychainWrapper.string(forKey: Keys.secret.rawValue)
    }
    
    func removeSecret() {
        keychainWrapper.removeObject(forKey: Keys.secret.rawValue)
    }
    
    var isLoggedIn: Bool {
        keychainWrapper.hasValue(forKey: Keys.secret.rawValue)
    }
}

// MARK: - Keys -

private extension LoginService {
    
    enum Keys: String {
        case secret = "loginSecret"
    }
}
