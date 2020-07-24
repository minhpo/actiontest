import Foundation

protocol ChallengeSelectionInteractorDelegate: ChallengeStatusTransitioningDelegate {
    func setup(with presenter: ChallengeSelectionPresenterDelegate, router: ChallengeSelectionRouterDelegate?, challengeProgram: ChallengeProgram, challenges: [Challenge])
    func handle(request: ChallengeSelectionRequest)
}

final class ChallengeSelectionInteractor: ChallengeSelectionInteractorDelegate {
    
    // MARK: Private properties
    
    private var presenter: ChallengeSelectionPresenterDelegate?
    private var router: ChallengeSelectionRouterDelegate?
    private var challengeProgram: ChallengeProgram?
    private var challenges: [Challenge] = []
    
    // MARK: Internal methods
    
    func setup(with presenter: ChallengeSelectionPresenterDelegate, router: ChallengeSelectionRouterDelegate?, challengeProgram: ChallengeProgram, challenges: [Challenge]) {
        self.presenter = presenter
        self.router = router
        self.challengeProgram = challengeProgram
        self.challenges = challenges
    }

    func handle(request: ChallengeSelectionRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        }
    }
}

// MARK: - ChallengeStatusTransitioningDelegate -

extension ChallengeSelectionInteractor: ChallengeStatusTransitioningDelegate {
    
    func challengeDidTransitStatus(_ challenge: Challenge) {
        if case .pendingReview = challenge.status {
            presenter?.present(response: .disableBackNavigation)
            router?.routeToFinishedChallenge(challenge)
        } else if case .closed = challenge.status {
            router?.routeToChallengeProgram(onChallengeStatusTransition: true)
        }
    }
}

// MARK: - Private methods -

private extension ChallengeSelectionInteractor {
    
    func handleInitialize() {
        if let challenge = challenges.first(where: { $0.status == .pendingReview || $0.status == .closed }) {
            router?.routeToFinishedChallenge(challenge)
        } else if let challenge = challenges.first(where: { $0.status == .active }) {
            router?.routeToActiveChallenge(challenge)
        } else {
            guard let challengeProgram = challengeProgram else {
                return assertionFailure("We need that challenge program to continue")
            }
            router?.routeToAvailableChallenges(for: challengeProgram, challenges: challenges)
        }
    }
}
