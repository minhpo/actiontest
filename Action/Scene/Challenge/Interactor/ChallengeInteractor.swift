import Foundation

protocol ChallengeInteractorDelegate: AnyObject {
    func setup(with presenter: ChallengePresenterDelegate, router: ChallengeRouterDelegate?, challenge: Challenge, challengeStatusTransitioningDelegate: ChallengeStatusTransitioningDelegate)
    func handle(request: ChallengeRequest)
}

final class ChallengeInteractor: ChallengeInteractorDelegate {
    
    // MARK: Private properties
    private let submitChallengeAnswersWorker: SubmitChallengeAnswersWorker
    
    private var presenter: ChallengePresenterDelegate?
    private var router: ChallengeRouterDelegate?
    private var challenge: Challenge?
    
    private weak var challengeStatusTransitioningDelegate: ChallengeStatusTransitioningDelegate?
    
    // MARK: Lifecycle
    init(submitChallengeAnswersWorker: SubmitChallengeAnswersWorker = SubmitChallengeAnswersService()) {
        self.submitChallengeAnswersWorker = submitChallengeAnswersWorker
    }
    
    // MARK: Internal methods
    func setup(with presenter: ChallengePresenterDelegate, router: ChallengeRouterDelegate?, challenge: Challenge, challengeStatusTransitioningDelegate: ChallengeStatusTransitioningDelegate) {
        self.presenter = presenter
        self.router = router
        self.challenge = challenge
        self.challengeStatusTransitioningDelegate = challengeStatusTransitioningDelegate
    }

    func handle(request: ChallengeRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        case .banner:
            handleBanner()
        case .buttonTap(let type):
            handleButtonType(for: type)
        }
    }
}

// MARK: - Private methods -

private extension ChallengeInteractor {
    
    func handleInitialize() {
        guard let challenge = challenge else {
            assertionFailure("Data not set")
            return
        }
        
        presenter?.present(response: .content(challenge: challenge))
    }
    
    func handleBanner() {
        guard let banner = challenge?.banner,
            banner.type == .video,
            let url = URL(string: banner.value) else { return }
        router?.routeToVideo(at: url)
    }
    
    func handleButtonType(for type: ChallengeRequest.ButtonType) {
        guard let challenge = challenge else { return }
        submitChallengeAnswersWorker.invoke(id: challenge.id) { [weak self] result in
            switch result {
            case .success:
                // TODO: use updated model from backend
                let newChallenge = Challenge(id: challenge.id, color: challenge.color, status: .pendingReview, banner: challenge.banner, titleFront: challenge.titleFront, descriptionFront: challenge.descriptionFront, titleBack: challenge.titleBack, descriptionBack: challenge.descriptionBack, additionalInfo: challenge.additionalInfo, assignments: challenge.assignments)
                self?.challengeStatusTransitioningDelegate?.challengeDidTransitStatus(newChallenge)
            case .failure(let error):
                // TODO: should handle error
                break
            }
        }
    }
}
