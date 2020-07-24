import UIKit

protocol ChallengeSelectionPresenterDelegate: AnyObject {
    func setup(with displayLogic: ChallengeSelectionDisplayLogic?)
    func present(response: ChallengeSelectionResponse)
}

final class ChallengeSelectionPresenter: ChallengeSelectionPresenterDelegate {
    
    // MARK: private properties
    
    private weak var displayLogic: ChallengeSelectionDisplayLogic?
}

// MARK: - ChallengesOverviewPresenterDelegate -

extension ChallengeSelectionPresenter {
    
    func setup(with displayLogic: ChallengeSelectionDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func present(response: ChallengeSelectionResponse) {
        switch response {
        case .disableBackNavigation:
            displayLogic?.disableBackNavigation()
        }
    }
}
