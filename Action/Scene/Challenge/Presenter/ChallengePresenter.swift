import Foundation

protocol ChallengePresenterDelegate: AnyObject {
    func setup(with displayLogic: ChallengeDisplayLogic?)
    func present(response: ChallengeResponse)
}

final class ChallengePresenter: ChallengePresenterDelegate {
    
    // MARK: private properties
    private let mapper: ChallengeDetailsViewModelMapper
    private weak var displayLogic: ChallengeDisplayLogic?
    
    init(mapper: ChallengeDetailsViewModelMapper = ChallengeDetailsViewModelMappingService()) {
        self.mapper = mapper
    }
}

// MARK: - Setup -

extension ChallengePresenter {
    
    func setup(with displayLogic: ChallengeDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func present(response: ChallengeResponse) {
        switch response {
        case .content(let challenge):
            present(challenge: challenge)
        }
    }
}

// MARK: - Private methods -

private extension ChallengePresenter {
    
    func present(challenge: Challenge) {
        guard let viewModel = mapper.map(from: challenge) else { return }
        displayLogic?.display(viewModel: viewModel)
    }
}
