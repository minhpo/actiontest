import UIKit
import EasyPeasy

final class ModalPresentationController: UIPresentationController {
    
    private let tintColor: UIColor
    private var presentingAnimatedTransitioning: UIViewControllerAnimatedTransitioning?
    private var dismissingAnimatedTransitioning: UIViewControllerAnimatedTransitioning?
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, tintColor: UIColor = StyleGuide.Colors.GreyTones.black, includeNavigation: Bool = true) {
        self.tintColor = tintColor
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        guard includeNavigation else { return }
        presentedViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation.close"), style: .plain, target: self, action: #selector(onDismiss))
    }
    
    func present(with presentingAnimatedTransitioning: UIViewControllerAnimatedTransitioning? = nil, andDismissWith dismissingAnimatedTransitioning: UIViewControllerAnimatedTransitioning? = nil) {
        self.presentingAnimatedTransitioning = presentingAnimatedTransitioning
        self.dismissingAnimatedTransitioning = dismissingAnimatedTransitioning
        
        setupNavigationBar()
        presentViewController()
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        presentingViewController.dismiss(animated: true, completion: completion)
    }
}

// MARK: - UIViewControllerAnimatedTransitioning -

extension ModalPresentationController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingAnimatedTransitioning
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissingAnimatedTransitioning
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
}

// MARK: - Private methods -

private extension ModalPresentationController {
    
    @objc
    func onDismiss() {
        dismiss()
    }
    
    func setupNavigationBar() {
        let navigationBar = UINavigationBar()
        navigationBar.tintColor = tintColor
        navigationBar.barTintColor = tintColor
        navigationBar.pushItem(presentedViewController.navigationItem, animated: false)
        presentedViewController.view.addSubview(navigationBar)
        
        navigationBar.easy.layout(
            Leading(),
            Trailing(),
            Top().to(presentedViewController.view, .topMargin)
        )
        
        navigationBar.setNeedsLayout()
        navigationBar.layoutIfNeeded()
    }
    
    func presentViewController() {
        presentedViewController.transitioningDelegate = self
        presentedViewController.modalPresentationStyle = .custom
        presentingViewController.present(presentedViewController, animated: true, completion: nil)
    }
}
