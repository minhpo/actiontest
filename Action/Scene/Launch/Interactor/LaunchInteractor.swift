protocol LaunchInteractorDelegate: AnyObject {
    func setup(with presenter: LaunchPresenterDelegate, router: LaunchRouterDelegate?)
    func handle(request: LaunchRequest)
}

final class LaunchInteractor: LaunchInteractorDelegate {
    
    // MARK: Private properties
    private var presenter: LaunchPresenterDelegate?
    private var router: LaunchRouterDelegate?
    
    private let checkOnboardingShownWorker: CheckOnboardingShownWorker
    private let loginWorker: LoginWorker
    private let firstRunWorker: FirstRunWorker
    
    // MARK: Lifecycle
    init(checkOnboardingShownWorker: CheckOnboardingShownWorker = CheckOnboardingShownService(),
         loginWorker: LoginWorker = LoginService(),
         firstRunWorker: FirstRunWorker = FirstRunService()) {
        self.checkOnboardingShownWorker = checkOnboardingShownWorker
        self.loginWorker = loginWorker
        self.firstRunWorker = firstRunWorker
    }
    
    // MARK: Internal methods
    func setup(with presenter: LaunchPresenterDelegate, router: LaunchRouterDelegate?) {
        self.presenter = presenter
        self.router = router
    }

    func handle(request: LaunchRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        }
    }
}

// MARK: - Requests
extension LaunchInteractor {
    private func handleInitialize() {
        handleFirstRun()
        
        if loginWorker.isLoggedIn {
            router?.routeToChallengePrograms()
        } else if checkOnboardingShownWorker.didShow {
            router?.routeToLogin()
        } else {
            router?.routeToOnboarding()
        }
    }
    
    private func handleFirstRun() {
        if firstRunWorker.isFirstRun() {
            loginWorker.removeSecret()
        }
        
        firstRunWorker.markAsFirstRun()
    }
}
