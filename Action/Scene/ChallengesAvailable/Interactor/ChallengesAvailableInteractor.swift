import Foundation

protocol ChallengesAvailableInteractorDelegate: AnyObject {
    func setup(with presenter: ChallengesAvailablePresenterDelegate, router: ChallengesAvailableRouterDelegate?, challengeProgram: ChallengeProgram, challenges: [Challenge])
    func handle(request: ChallengesAvailableRequest)
}

final class ChallengesAvailableInteractor: ChallengesAvailableInteractorDelegate {
    
    // MARK: Private properties
    private var presenter: ChallengesAvailablePresenterDelegate?
    private var router: ChallengesAvailableRouterDelegate?
    private var challengeProgram: ChallengeProgram?
    private var challenges: [Challenge] = []
    
    private let activateDailyChallengeWorker: ActivateDailyChallengeWorker
    
    // MARK: Lifecycle
    init(activateDailyChallengeWorker: ActivateDailyChallengeWorker = ActivateDailyChallengeService()) {
        self.activateDailyChallengeWorker = activateDailyChallengeWorker
    }
    
    // MARK: Internal methods
    func setup(with presenter: ChallengesAvailablePresenterDelegate, router: ChallengesAvailableRouterDelegate?, challengeProgram: ChallengeProgram, challenges: [Challenge]) {
        self.presenter = presenter
        self.router = router
        self.challengeProgram = challengeProgram
        self.challenges = challenges
    }
    
    func handle(request: ChallengesAvailableRequest) {
        switch request {
        case .initialize:
            handleInitialize()
            
        case .startChallenge(let index):
            handleStartChallenge(with: index)
        }
    }
}

// MARK: - Requests -

private extension ChallengesAvailableInteractor {
    
    func handleInitialize() {
        presenter?.present(response: .initialise(challenges: challenges))
    }
    
    func handleStartChallenge(with index: Int) {
        guard let program = challengeProgram, let challenge = challenges[safe: index] else { return }
        
        presenter?.showLoadingIndicator()
        
        activateDailyChallengeWorker.invoke(programId: program.id, challengeId: challenge.id) { [weak self] result in
            self?.presenter?.removeLoadingIndicator()

            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self?.presenter?.cancelCardOpening()

            case .success(let activated):
                if activated {
                    self?.router?.route(to: challenge)
                } else {
                    self?.presenter?.cancelCardOpening()
                }
            }
        }
    }
}
