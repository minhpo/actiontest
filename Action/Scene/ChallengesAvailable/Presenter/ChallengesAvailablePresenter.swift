import Foundation

protocol ChallengesAvailablePresenterDelegate: AnyObject {
    func setup(with displayLogic: ChallengesAvailableDisplayLogic?)
    func present(response: ChallengesAvailableResponse)
    func showLoadingIndicator()
    func removeLoadingIndicator()
    func cancelCardOpening()
}

final class ChallengesAvailablePresenter: ChallengesAvailablePresenterDelegate {
    
    // MARK: private properties
    private let mapper: ChallengeCardContentViewModelMapper
    private weak var displayLogic: ChallengesAvailableDisplayLogic?
    
    init(mapper: ChallengeCardContentViewModelMapper = ChallengeCardContentViewModelMappingService()) {
        self.mapper = mapper
    }
}

// MARK: - ChallengesAvailablePresenterDelegate -

extension ChallengesAvailablePresenter {
    
    func setup(with displayLogic: ChallengesAvailableDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func present(response: ChallengesAvailableResponse) {
        switch response {
        case .initialise(let challenges):
            present(challenges: challenges)
        }
    }
    
    func showLoadingIndicator() {
        displayLogic?.showLoadingIndicator()
    }
    
    func removeLoadingIndicator() {
        displayLogic?.removeLoadingIndicator()
    }
    
    func cancelCardOpening() {
        displayLogic?.cancelCardOpening()
    }
}

// MARK: - Private methods -

private extension ChallengesAvailablePresenter {
    
    func present(challenges: [Challenge]) {
        let viewModels = mapper.map(from: challenges)
        displayLogic?.display(viewModels: viewModels)
    }
}
