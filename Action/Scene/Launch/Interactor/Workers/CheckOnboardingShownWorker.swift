import Foundation

protocol CheckOnboardingShownWorker {
    var didShow: Bool { get }
}

final class CheckOnboardingShownService: CheckOnboardingShownWorker {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    var didShow: Bool {
        return userDefaults.bool(forKey: Keys.onboardingDidShow.rawValue)
    }
}

// MARK: - Keys -

private extension CheckOnboardingShownService {
    
    enum Keys: String {
        case onboardingDidShow
    }
}
