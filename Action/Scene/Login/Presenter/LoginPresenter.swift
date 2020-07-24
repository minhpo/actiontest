import Foundation

protocol LoginPresenterDelegate: AnyObject {
    func setup(with displayLogic: LoginDisplayLogic?)
    func present(response: LoginResponse)
}

final class LoginPresenter: LoginPresenterDelegate {
    
    // MARK: private properties
    private weak var displayLogic: LoginDisplayLogic?
}

// MARK: - LoginPresenterDelegate -

extension LoginPresenter {
    
    func setup(with displayLogic: LoginDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func present(response: LoginResponse) {
        switch response {
        case .cameraAccessDenied:
            presentGrantCameraAccess()
        }
    }
}

// MARK: - Private methods -

private extension LoginPresenter {
    
    func presentGrantCameraAccess() {
        displayLogic?.displayGrantCameraAccess()
    }
}
