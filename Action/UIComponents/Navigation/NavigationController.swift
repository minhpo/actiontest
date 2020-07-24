import UIKit

final class NavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // Do not add back button for root viewcontroller
        if !viewControllers.isEmpty {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation.back"), style: .plain, target: self, action: #selector(popViewController(animated:)))
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - UINavigationControllerDelegate -

extension NavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push, toVC is CardExpandAnimatableContext {
            return CardExpandNavigationAnimator()
        } else if operation == .pop, toVC is CardCollapseAnimatableContext {
            return CardCollapseNavigationAnimator()
        }
        return nil
    }
}
