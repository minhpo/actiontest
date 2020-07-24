import Foundation

protocol ChallengeActiveInteractorDelegate: AnyObject {
    func setup(with presenter: ChallengeActivePresenterDelegate, router: ChallengeActiveRouterDelegate?, challenge: Challenge)
    func handle(request: ChallengeActiveRequest)
}

final class ChallengeActiveInteractor: ChallengeActiveInteractorDelegate {
    
    // MARK: Private properties
    private var presenter: ChallengeActivePresenterDelegate?
    private var router: ChallengeActiveRouterDelegate?
    private var challenge: Challenge?
    
    // MARK: Internal methods
    func setup(with presenter: ChallengeActivePresenterDelegate, router: ChallengeActiveRouterDelegate?, challenge: Challenge) {
        self.presenter = presenter
        self.router = router
        self.challenge = challenge
    }

    func handle(request: ChallengeActiveRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        case .viewDetails:
            handleViewDetails()
        case .close:
            handleClose()
        }
    }
}

// MARK: - Private methods -

private extension ChallengeActiveInteractor {
    
    func handleInitialize() {
        guard let challenge = self.challenge else { return }
        presenter?.present(response: .initialise(challenge: challenge))
    }
    
    func handleViewDetails() {
        guard let challenge = self.challenge else { return }
        router?.route(to: challenge)
    }
    
    func handleClose() {
        router?.routeToChallengeProgram()
    }
}
