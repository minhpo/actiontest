import Foundation

protocol ChallengeProgramInfoPresenterDelegate: AnyObject {
    func setup(with displayLogic: ChallengeProgramInfoDisplayLogic?)
    func present(response: ChallengeProgramInfoResponse)
}

final class ChallengeProgramInfoPresenter: ChallengeProgramInfoPresenterDelegate {
    
    // MARK: private properties
    private let mapper: ChallengeProgramInfoViewModelMapper
    private weak var displayLogic: ChallengeProgramInfoDisplayLogic?
    
    init(mapper: ChallengeProgramInfoViewModelMapper = ChallengeProgramInfoViewModelMappingService()) {
        self.mapper = mapper
    }
}

// MARK: - ChallengeProgramInfoPresenterDelegate -

extension ChallengeProgramInfoPresenter {
    
    func setup(with displayLogic: ChallengeProgramInfoDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func present(response: ChallengeProgramInfoResponse) {
        guard case .initialize(let challengeProgram) = response else { return }
        let viewModel = mapper.map(from: challengeProgram)
        displayLogic?.display(viewModel: viewModel)
    }
}
