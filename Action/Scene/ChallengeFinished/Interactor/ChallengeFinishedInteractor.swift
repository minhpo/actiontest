import Foundation

protocol ChallengeFinishedInteractorDelegate: AnyObject {
    func setup(with presenter: ChallengeFinishedPresenterDelegate, router: ChallengeFinishedRouterDelegate?, challenge: Challenge)
    func handle(request: ChallengeFinishedRequest)
}

final class ChallengeFinishedInteractor: ChallengeFinishedInteractorDelegate {
    
    // MARK: Private properties
    private var presenter: ChallengeFinishedPresenterDelegate?
    private var router: ChallengeFinishedRouterDelegate?
    private var challenge: Challenge?
    
    // MARK: Internal methods
    func setup(with presenter: ChallengeFinishedPresenterDelegate, router: ChallengeFinishedRouterDelegate?, challenge: Challenge) {
        self.presenter = presenter
        self.router = router
        self.challenge = challenge
    }

    func handle(request: ChallengeFinishedRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        case .reflection:
            handleReflection()
        }
    }
}

// MARK: - // MARK: - Requests - -

extension ChallengeFinishedInteractor: ChallengeReflectionDelegate {
    
    func challengeDidReceiveReflection(_ challenge: Challenge) {
        presenter?.present(response: .update(challenge: challenge))
    }
}

// MARK: - Private methods -

private extension ChallengeFinishedInteractor {
    
    func handleInitialize() {
        guard let challenge = challenge else { return }
        presenter?.present(response: .initialise(challenge: challenge))
    }
    
    func handleReflection() {
        guard let challenge = challenge else { return }
        router?.routeToRelection(for: challenge, withDelegate: self)
    }
}
