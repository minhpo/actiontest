import Foundation

protocol FirstRunWorker {
    func isFirstRun() -> Bool
    func markAsFirstRun()
}

final class FirstRunService: FirstRunWorker {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func isFirstRun() -> Bool {
        userDefaults.bool(forKey: Keys.firstRun.rawValue) == false
    }
    
    func markAsFirstRun() {
        userDefaults.set(true, forKey: Keys.firstRun.rawValue)
    }
}

// MARK: - Keys -

private extension FirstRunService {
    
    enum Keys: String {
        case firstRun
    }
}
