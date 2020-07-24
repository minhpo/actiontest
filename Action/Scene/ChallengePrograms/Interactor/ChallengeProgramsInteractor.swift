import Foundation

protocol ChallengeProgramsInteractorDelegate: AnyObject {
    func setup(with presenter: ChallengeProgramsPresenterDelegate, router: ChallengeProgramsRouterDelegate?)
    func handle(request: ChallengeProgramsRequest)
}

final class ChallengeProgramsInteractor: ChallengeProgramsInteractorDelegate {
    
    // MARK: Private properties
    private let getChallengeProgramsWorker: GetChallengeProgramsWorker
    
    private var presenter: ChallengeProgramsPresenterDelegate?
    private var router: ChallengeProgramsRouterDelegate?
    private var challengePrograms: [ChallengeProgram] = []
    
    // MARK: Lifecycle
    init(getChallengeProgramsWorker: GetChallengeProgramsWorker = GetChallengeProgramsService()) {
        self.getChallengeProgramsWorker = getChallengeProgramsWorker
    }
    
    // MARK: Internal methods
    func setup(with presenter: ChallengeProgramsPresenterDelegate, router: ChallengeProgramsRouterDelegate?) {
        self.presenter = presenter
        self.router = router
    }
    
    func handle(request: ChallengeProgramsRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        case .openChallengeProgram(let index):
            handleOpenChallengeProgram(with: index)
        case .openChallengeProgramInfo(let index):
            handleOpenChallengeProgramInfo(with: index)
        }
    }
}

// MARK: - Private methods -

private extension ChallengeProgramsInteractor {
    
    func handleInitialize() {
        getChallengeProgramsWorker.invoke { [weak self] result in
            switch result {
            case .success(let programs):
                self?.challengePrograms = programs
                self?.presenter?.present(response: .getChallengePrograms(challengePrograms: programs))
            case .failure(let error):
                //TODO: show error
                break
            }
        }
    }
    
    func handleOpenChallengeProgram(with index: Int) {
        guard let program = challengePrograms[safe: index] else { return }
        router?.route(to: program)
    }
    
    func handleOpenChallengeProgramInfo(with index: Int) {
        guard let program = challengePrograms[safe: index] else { return }
        router?.routeToInfo(for: program)
    }
}
