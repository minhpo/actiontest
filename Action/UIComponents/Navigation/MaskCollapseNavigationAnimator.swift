import UIKit

final class MaskCollapseNavigationAnimator: NSObject {
    let animationDuration: TimeInterval = 0.5
}

// MARK: - UIViewControllerAnimatedTransitioning -

extension MaskCollapseNavigationAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let disappearingViewController = transitionContext.viewController(forKey: .from)
        guard let disappearingView = disappearingViewController?.view else { return }
        
        let appearingViewController = transitionContext.viewController(forKey: .to)
        guard let appearingView = appearingViewController?.view else { return }
        
        let container = transitionContext.containerView
        // Do nothing if presented modally of appearing vc is a container viewcontroller
        if (appearingViewController?.presentedViewController != disappearingViewController), !(appearingViewController is UINavigationController) {
            container.insertSubview(appearingView, belowSubview: disappearingView)
        }
        
        var collapsableAnimatableContext: MaskCollapseAnimatableContext?
        if let navigationController = appearingViewController as? UINavigationController {
            collapsableAnimatableContext = navigationController.topViewController as? MaskCollapseAnimatableContext
        } else {
            collapsableAnimatableContext = appearingViewController as? MaskCollapseAnimatableContext
        }
        guard let reference = collapsableAnimatableContext?.endingMask else { return }
        let mask = UIView()
        mask.frame = container.bounds
        mask.backgroundColor = .black
        disappearingView.mask = mask
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: self.animationDuration, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            UIView.animateKeyframes(withDuration: self.animationDuration, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    mask.layer.cornerRadius = reference.layer.cornerRadius
                    mask.frame = reference.frame
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    disappearingView.alpha = 0
                }
            })
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
