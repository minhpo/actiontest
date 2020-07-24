import UIKit

protocol LoginRouterDelegate: AnyObject {
    func setup(with viewController: (LoginDisplayLogic & UIViewController)?)
    
    func routeToScanner()
    func closeScanner()
    func routeToChallengePrograms()
    func routeToSettings()
}

final class LoginRouter: NSObject, LoginRouterDelegate {
    
    private let application: UIApplication
    private let makeScannerViewController: () -> ScannerViewController
    private let makeChallengeProgramsViewController: () -> ChallengeProgramsViewController
    
    private weak var viewController: (LoginDisplayLogic & UIViewController)?
    private var modalPresentationController: ModalPresentationController?
    
    init(makeChallengeProgramsViewController: @escaping () -> ChallengeProgramsViewController = ChallengeProgramsViewControllerFactory.make,
         makeScannerViewController: @escaping () -> ScannerViewController = ScannerViewControllerFactory.make,
         application: UIApplication = UIApplication.shared) {
        self.makeChallengeProgramsViewController = makeChallengeProgramsViewController
        self.makeScannerViewController = makeScannerViewController
        self.application = application
    }
    
    func setup(with viewController: (LoginDisplayLogic & UIViewController)?) {
        self.viewController = viewController
    }
    
    func routeToScanner() {
        guard let viewController = viewController else { return }
        
        let targetViewController = makeScannerViewController()
        targetViewController.delegate = viewController
        
        modalPresentationController = ModalPresentationController(presentedViewController: targetViewController, presenting: viewController, tintColor: StyleGuide.Colors.GreyTones.white)
        modalPresentationController?.present(with: MaskExpandNavigationAnimator(), andDismissWith: MaskCollapseNavigationAnimator())
    }
    
    func closeScanner() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func routeToChallengePrograms() {
        guard let window = viewController?.view.window else { return }
        let rootViewController = makeChallengeProgramsViewController()
        let targetViewController = NavigationController(rootViewController: rootViewController)
        
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
    
    func routeToSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        application.open(url, options: [:], completionHandler: nil)
    }
}
