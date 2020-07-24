import UIKit

protocol LaunchRouterDelegate: AnyObject {
    
    func setup(with viewController: (LaunchDisplayLogic & UIViewController)?)
    
    func routeToOnboarding()
    func routeToLogin()
    func routeToChallengePrograms()
}

final class LaunchRouter: LaunchRouterDelegate {
    
    private weak var viewController: (LaunchDisplayLogic & UIViewController)?
    private let makeOnboardingViewController: () -> OnboardingViewController
    private let makeLoginViewController: () -> LoginViewController
    private let makeChallengeProgramsViewController: () -> ChallengeProgramsViewController
    
    init(makeOnboardingViewController: @escaping () -> OnboardingViewController = OnboardingViewControllerFactory.make,
        makeLoginViewController: @escaping () -> LoginViewController = LoginViewControllerFactory.make,
        makeChallengeProgramsViewController: @escaping () -> ChallengeProgramsViewController = ChallengeProgramsViewControllerFactory.make) {
        self.makeOnboardingViewController = makeOnboardingViewController
        self.makeLoginViewController = makeLoginViewController
        self.makeChallengeProgramsViewController = makeChallengeProgramsViewController
    }
    
    func setup(with viewController: (LaunchDisplayLogic & UIViewController)?) {
        self.viewController = viewController
    }
    
    func routeToOnboarding() {
        let targetViewController = makeOnboardingViewController()
        route(to: targetViewController)
    }
    
    func routeToLogin() {
        let targetViewController = makeLoginViewController()
        route(to: targetViewController)
    }
    
    func routeToChallengePrograms() {
        let targetViewController = NavigationController(rootViewController: makeChallengeProgramsViewController())
        route(to: targetViewController)
    }
}

private extension LaunchRouter {
    
    func route(to viewController: UIViewController) {
        guard let window = self.viewController?.view.window else { return }
        window.rootViewController = viewController
    }
}
