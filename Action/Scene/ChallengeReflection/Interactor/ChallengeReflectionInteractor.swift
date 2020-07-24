import Foundation

protocol ChallengeReflectionInteractorDelegate: AnyObject {
    func setup(with presenter: ChallengeReflectionPresenterDelegate, router: ChallengeReflectionRouterDelegate?, challenge: Challenge, challengeStatusTransitioningDelegate: ChallengeStatusTransitioningDelegate, challengeReflectionDelegate: ChallengeReflectionDelegate)
    func handle(request: ChallengeReflectionRequest)
}

final class ChallengeReflectionInteractor: ChallengeReflectionInteractorDelegate {
    
    // MARK: Private properties
    private let submitAnswersWorker: SubmitReflectionAnswersWorker
    private var presenter: ChallengeReflectionPresenterDelegate?
    private var router: ChallengeReflectionRouterDelegate?
    private var challenge: Challenge?
    
    private weak var challengeStatusTransitioningDelegate: ChallengeStatusTransitioningDelegate?
    private weak var challengeReflectionDelegate: ChallengeReflectionDelegate?
    
    // MARK: Lifecycle
    init(submitAnswersWorker: SubmitReflectionAnswersWorker = SubmitReflectionAnswersService()) {
        self.submitAnswersWorker = submitAnswersWorker
    }
    
    // MARK: Internal methods
    func setup(with presenter: ChallengeReflectionPresenterDelegate, router: ChallengeReflectionRouterDelegate?, challenge: Challenge, challengeStatusTransitioningDelegate: ChallengeStatusTransitioningDelegate, challengeReflectionDelegate: ChallengeReflectionDelegate) {
        self.presenter = presenter
        self.router = router
        self.challenge = challenge
        self.challengeStatusTransitioningDelegate = challengeStatusTransitioningDelegate
        self.challengeReflectionDelegate = challengeReflectionDelegate
    }

    func handle(request: ChallengeReflectionRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        case .buttonTap(let type):
            handleButtonType(for: type)
        }
    }
}

// MARK: - Requests -

private extension ChallengeReflectionInteractor {
    
    func handleInitialize() {
        guard let challenge = challenge else { return }
        presenter?.present(response: .content(challenge: challenge))
    }
    
    func handleButtonType(for type: ChallengeReflectionRequest.ButtonType) {
        guard let challenge = challenge else { return }
        
        var answers: [ReflectionAnswer] = []
        if case .submit = type {
            // TODO: fill array with answers
            answers = []
        }
        
        // TODO: connect to app daily challenge model
        submitAnswersWorker.invoke(dailyChallengeId: 0, selectedChallengeId: challenge.id, answers: answers, completion: { [weak self] result in
            switch result {
            case .success:
                // TODO: use updated model from backend
                let newChallenge = Challenge(id: challenge.id, color: challenge.color, status: .closed, banner: challenge.banner, titleFront: challenge.titleFront, descriptionFront: challenge.descriptionFront, titleBack: challenge.titleBack, descriptionBack: challenge.descriptionBack, additionalInfo: challenge.additionalInfo, assignments: challenge.assignments)
                self?.challengeReflectionDelegate?.challengeDidReceiveReflection(newChallenge)
                self?.challengeStatusTransitioningDelegate?.challengeDidTransitStatus(newChallenge)
            case .failure(let error):
                // TODO: should handle error
                break
            }
        })
    }
}
