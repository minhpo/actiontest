import UIKit

protocol ChallengeReflectionPresenterDelegate: AnyObject {
    func setup(with displayLogic: ChallengeReflectionDisplayLogic?)
    func present(response: ChallengeReflectionResponse)
}

final class ChallengeReflectionPresenter: ChallengeReflectionPresenterDelegate {
    
    // MARK: private properties
    private weak var displayLogic: ChallengeReflectionDisplayLogic?
}

// MARK: - ChallengeReflectionPresenterDelegate -

extension ChallengeReflectionPresenter {
    
    func setup(with displayLogic: ChallengeReflectionDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func present(response: ChallengeReflectionResponse) {
        switch response {
        case .content(let challenge):
            present(challenge: challenge)
        }
    }
}

// MARK: - Private methods -

private extension ChallengeReflectionPresenter {
    
    // TODO: populate with questions from backend
    func present(challenge: Challenge) {
        let items: [ChallengeReflectionViewModel.ContentItem] = [
            .metadata(viewModel: ChallengeReflectionViewModel.MetaData(tintColor: UIColor(hex: challenge.color))),
            .questions(viewModel: ChallengeReflectionViewModel.Question(question: "Het was moeilijk", minValueText: "mee oneens", maxValueText: "mee eens")),
            .questions(viewModel: ChallengeReflectionViewModel.Question(question: "Het was leuk!", minValueText: "mee oneens", maxValueText: "mee eens")),
            .buttons(viewModel: ChallengeReflectionViewModel.Buttons(tintColor: UIColor(hex: challenge.color)))
        ]
        let viewModel = ChallengeReflectionViewModel(items: items)
        displayLogic?.display(viewModel: viewModel)
    }
}
