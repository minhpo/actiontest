import Foundation

protocol OnboardingInteractorDelegate: AnyObject {
    func setup(with presenter: OnboardingPresenterDelegate, router: OnboardingRouterDelegate?)
    func handle(request: OnboardingRequest)
}

final class OnboardingInteractor: OnboardingInteractorDelegate {
    
    // MARK: Private properties
    private var presenter: OnboardingPresenterDelegate?
    private var router: OnboardingRouterDelegate?
    
    private let setOnboardingShownWorker: SetOnboardingShownWorker
    
    // MARK: Lifecycle
    init(setOnboardingShownWorker: SetOnboardingShownWorker = SetOnboardingShownService()) {
        self.setOnboardingShownWorker = setOnboardingShownWorker
    }
    
    // MARK: Internal methods
    func setup(with presenter: OnboardingPresenterDelegate, router: OnboardingRouterDelegate?) {
        self.presenter = presenter
        self.router = router
    }

    func handle(request: OnboardingRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        case .close:
            handleClose()
        }
    }
}

// MARK: - Private methods -

private extension OnboardingInteractor {
    
    func handleInitialize() {
        presenter?.presentContent()
    }
    
    func handleClose() {
        setOnboardingShownWorker.setShown()
        router?.routeToLogin()
    }
}
