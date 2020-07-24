import Foundation

protocol SetOnboardingShownWorker {
    func setShown()
}

final class SetOnboardingShownService: SetOnboardingShownWorker {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func setShown() {
        userDefaults.set(true, forKey: Keys.onboardingDidShow.rawValue)
    }
}

// MARK: - Keys -

private extension SetOnboardingShownService {
    
    enum Keys: String {
        case onboardingDidShow
    }
}
