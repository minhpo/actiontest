import Foundation

protocol LaunchPresenterDelegate: AnyObject {
    func setup(with displayLogic: LaunchDisplayLogic?)
}

final class LaunchPresenter: LaunchPresenterDelegate {
    
    // MARK: private properties
    private weak var displayLogic: LaunchDisplayLogic?
}

// MARK: Setup
extension LaunchPresenter {
    
    func setup(with displayLogic: LaunchDisplayLogic?) {
        self.displayLogic = displayLogic
    }
}
