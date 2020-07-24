import Foundation
import AVFoundation

protocol LoginInteractorDelegate: AnyObject {
    func setup(with presenter: LoginPresenterDelegate, router: LoginRouterDelegate?)
    func handle(request: LoginRequest)
}

final class LoginInteractor: LoginInteractorDelegate {
    
    // MARK: Private properties
    private var presenter: LoginPresenterDelegate?
    private var router: LoginRouterDelegate?
    private let loginWorker: LoginWorker
    
    // MARK: Lifecycle
    init(loginWorker: LoginWorker = LoginService()) {
        self.loginWorker = loginWorker
    }
    
    // MARK: Internal methods
    func setup(with presenter: LoginPresenterDelegate, router: LoginRouterDelegate?) {
        self.presenter = presenter
        self.router = router
    }

    func handle(request: LoginRequest) {
        switch request {
        case .startScanning:
            handleStartScanning()
        case .scanned(let secret):
            handleScanned(secret: secret)
        case .failedScanning(let error):
            handleFailedScanning(error: error)
        case .settings:
            handleSettings()
        }
    }
}

// MARK: - Private methods -

private extension LoginInteractor {
    
    func handleStartScanning() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            router?.routeToScanner()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.router?.routeToScanner()
                    } else {
                        self?.handleNoCameraAccess()
                    }
                }
            }
        default:
            handleNoCameraAccess()
        }
    }
    
    func handleScanned(secret: String) {
        router?.closeScanner()
        loginWorker.setSecret(secret)
        router?.routeToChallengePrograms()
    }
    
    func handleFailedScanning(error: ScannerError) {
        router?.closeScanner()
    }
    
    func handleNoCameraAccess() {
        presenter?.present(response: .cameraAccessDenied)
    }
    
    func handleSettings() {
        router?.routeToSettings()
    }
}
