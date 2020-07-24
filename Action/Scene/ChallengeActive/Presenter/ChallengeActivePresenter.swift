import Foundation

protocol ChallengeActivePresenterDelegate: AnyObject {
    func setup(with displayLogic: ChallengeActiveDisplayLogic?)
    func present(response: ChallengeActiveResponse)
}

final class ChallengeActivePresenter: ChallengeActivePresenterDelegate {
    
    // MARK: private properties
    private let mapper: ChallengeCardContentViewModelMapper
    private weak var displayLogic: ChallengeActiveDisplayLogic?
    
    init(mapper: ChallengeCardContentViewModelMapper = ChallengeCardContentViewModelMappingService()) {
        self.mapper = mapper
    }
}

// MARK: - Setup -

extension ChallengeActivePresenter {
    
    func setup(with displayLogic: ChallengeActiveDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func present(response: ChallengeActiveResponse) {
        switch response {
        case .initialise(let challenge):
            present(challenge: challenge)
        }
    }
}

// MARK: - Private methods -

private extension ChallengeActivePresenter {
    
    func present(challenge: Challenge) {
        guard let viewModel = mapper.map(from: challenge) else { return }
        displayLogic?.display(viewModel: viewModel)
    }
}
