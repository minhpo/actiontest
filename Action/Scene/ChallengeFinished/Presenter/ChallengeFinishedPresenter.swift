import Foundation

protocol ChallengeFinishedPresenterDelegate: AnyObject {
    func setup(with displayLogic: ChallengeFinishedDisplayLogic?)
    func present(response: ChallengeFinishedResponse)
}

final class ChallengeFinishedPresenter: ChallengeFinishedPresenterDelegate {
    
    // MARK: private properties
    private let mapper: ChallengeFinishedViewModelMapper
    private weak var displayLogic: ChallengeFinishedDisplayLogic?
    
    init(mapper: ChallengeFinishedViewModelMapper = ChallengeFinishedViewModelMappingService()) {
        self.mapper = mapper
    }
}

// MARK: - ChallengeFinishedPresenterDelegate -
extension ChallengeFinishedPresenter {
    
    func setup(with displayLogic: ChallengeFinishedDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func present(response: ChallengeFinishedResponse) {
        switch response {
        case .initialise(let challenge), .update(let challenge):
            present(challenge: challenge)
        }
    }
}

// MARK: - Private methods -
private extension ChallengeFinishedPresenter {
    
    func present(challenge: Challenge) {
        guard let viewModel = mapper.map(from: challenge) else { return }
        displayLogic?.display(viewModel: viewModel)
    }
}
