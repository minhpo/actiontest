import Foundation

protocol QuizPresenterDelegate: AnyObject {
    func setup(with displayLogic: QuizDisplayLogic?)
}

final class QuizPresenter: QuizPresenterDelegate {
    
    // MARK: private properties
    private weak var displayLogic: QuizDisplayLogic?
}

// MARK: Setup
extension QuizPresenter {
    
    func setup(with displayLogic: QuizDisplayLogic?) {
        self.displayLogic = displayLogic
    }
}
