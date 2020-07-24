import UIKit

protocol ChallengeProgramsPresenterDelegate: AnyObject {
    func setup(with displayLogic: ChallengeProgramsDisplayLogic?)
    func present(response: ChallengeProgramsResponse)
}

final class ChallengeProgramsPresenter: ChallengeProgramsPresenterDelegate {
    
    // MARK: private properties
    private let mapper: ChallengeProgramsViewModelMapper
    private weak var displayLogic: ChallengeProgramsDisplayLogic?
    
    init(mapper: ChallengeProgramsViewModelMapper = ChallengeProgramsViewModelMappingService()) {
        self.mapper = mapper
    }
}

// MARK: - TrainingOverviewPresenterDelegate -

extension ChallengeProgramsPresenter {
    
    func setup(with displayLogic: ChallengeProgramsDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func present(response: ChallengeProgramsResponse) {
        switch response {
        case .getChallengePrograms(let challengePrograms):
            presentPrograms(challengePrograms)
        }
    }
}

// MARK: - Private methods -

private extension ChallengeProgramsPresenter {
    
    func presentPrograms(_ programs: [ChallengeProgram]) {
        let viewModels = mapper.map(from: programs)
        displayLogic?.display(viewModels: viewModels)
    }
}
