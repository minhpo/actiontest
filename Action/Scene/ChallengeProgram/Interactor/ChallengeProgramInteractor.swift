import Foundation

protocol ChallengeProgramInteractorDelegate: AnyObject {
    func setup(with presenter: ChallengeProgramPresenterDelegate, router: ChallengeProgramRouterDelegate?, challengeProgram: ChallengeProgram)
    func handle(request: ChallengeProgramRequest)
}

final class ChallengeProgramInteractor: ChallengeProgramInteractorDelegate {
    
    private let getChallengesWorker: GetChallengesWorker
    
    // MARK: Private properties
    private var presenter: ChallengeProgramPresenterDelegate?
    private var router: ChallengeProgramRouterDelegate?
    private var challengeProgram: ChallengeProgram?
    private var challenges: [Challenge] = []
    
    // MARK: Lifecycle
    init(getDailyChallengesWorker: GetChallengesWorker = GetChallengesService()) {
        self.getChallengesWorker = getDailyChallengesWorker
    }
    
    // MARK: Internal methods
    func setup(with presenter: ChallengeProgramPresenterDelegate, router: ChallengeProgramRouterDelegate?, challengeProgram: ChallengeProgram) {
        self.presenter = presenter
        self.router = router
        self.challengeProgram = challengeProgram
    }
    
    func handle(request: ChallengeProgramRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        case .onTap(let cardSize):
            handleCardTap(cardSize: cardSize)
        }
    }
}

// MARK: - Private methods -

private extension ChallengeProgramInteractor {
    
    var mostImportantChallengeStatus: Challenge.Status {
        var status: Challenge.Status = .open
        if challenges.contains(where: { $0.status == .closed }) {
            status = .closed
        } else if challenges.contains(where: { $0.status == .pendingReview }) {
            status = .pendingReview
        } else if challenges.contains(where: { $0.status == .active }) {
            status = .active
        }
        
        return status
    }
    
    func handleInitialize() {
        guard let challengeProgram = self.challengeProgram else { return }
        
        // TODO: Show loading indicator
        getChallengesWorker.invoke(programId: challengeProgram.id) { [weak self] result in
            switch result {
            case .success(let challenges):
                self?.challenges = challenges
                self?.handleChallengesLoaded()
                
            case .failure(let error):
                // TODO: Show error
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func handleChallengesLoaded() {
        presenter?.present(response: .content(status: mostImportantChallengeStatus))
    }
    
    func handleCardTap(cardSize: ChallengeProgramRequest.CardSize) {
        guard let challengeProgram = self.challengeProgram else { return }
        
        switch (cardSize, mostImportantChallengeStatus) {
        case (.large, .open), (.large, .active), (.large, .pendingReview), (.small, .closed):
            router?.routeToChallengeSelection(for: challengeProgram, dailyChallenges: challenges)
        default:
            router?.routeToQuiz(for: challengeProgram)
        }
    }
}
