import UIKit

protocol OnboardingRouterDelegate: AnyObject {
    func setup(with viewController: (OnboardingDisplayLogic & UIViewController)?)
    func routeToLogin()
}

final class OnboardingRouter: OnboardingRouterDelegate {
    
    private weak var viewController: (OnboardingDisplayLogic & UIViewController)?
    private let makeLoginViewController: () -> LoginViewController
    
    init(makeLoginViewController: @escaping () -> LoginViewController = LoginViewControllerFactory.make) {
        self.makeLoginViewController = makeLoginViewController
    }
    
    func setup(with viewController: (OnboardingDisplayLogic & UIViewController)?) {
        self.viewController = viewController
    }
    
    func routeToLogin() {
        guard let window = viewController?.view.window else { return }
        let targetViewController = makeLoginViewController()
        targetViewController.isFollowUpFromOnboarding = true
        
        defer {
            let oldViewController = window.rootViewController
            let newViewController = targetViewController
            window.rootViewController = newViewController
        }
        
        guard let snapshot = window.rootViewController?.view.snapshotView(afterScreenUpdates: true) else { return }
        targetViewController.view.addSubview(snapshot)
        
        UIView.animate(withDuration: 0.3, animations: {
            snapshot.alpha = 0
        }, completion: { _ in
            snapshot.removeFromSuperview()
        })
    }
}
