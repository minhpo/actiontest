import UIKit

extension UIViewControllerContextTransitioning {
    
    func appearingViewController<T>() -> T? {
        return getViewController(forKey: .to)
    }
    
    func disappearingViewController<T>() -> T? {
        return getViewController(forKey: .from)
    }
}

extension UIViewControllerContextTransitioning {
    
    func getViewController<T>(forKey key: UITransitionContextViewControllerKey) -> T? {
        let appearingViewController = viewController(forKey: key)
        var target: T?
        if let navigationController = appearingViewController as? UINavigationController {
            target = navigationController.topViewController as? T
        } else {
            target = appearingViewController as? T
        }
        
        return target
    }
}
