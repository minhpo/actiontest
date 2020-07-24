import UIKit

final class MaskExpandNavigationAnimator: NSObject {
    let animationDuration: TimeInterval = 0.5
}

// MARK: - UIViewControllerAnimatedTransitioning -

extension MaskExpandNavigationAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        let disappearingViewController = transitionContext.viewController(forKey: .from)
        var expandAnimatableContext: MaskExpandAnimatableContext?
        if let navigationController = disappearingViewController as? UINavigationController {
            expandAnimatableContext = navigationController.topViewController as? MaskExpandAnimatableContext
        } else {
            expandAnimatableContext = disappearingViewController as? MaskExpandAnimatableContext
        }
        guard let reference = expandAnimatableContext?.startingMask else { return }
        let mask = UIView()
        mask.layer.cornerRadius = reference.layer.cornerRadius
        mask.frame = reference.frame
        mask.backgroundColor = .black
        
        guard let appearingView = transitionContext.view(forKey: .to) else { return }
        container.addSubview(appearingView)
        appearingView.mask = mask

        appearingView.alpha = 0
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: self.animationDuration, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            UIView.animateKeyframes(withDuration: self.animationDuration, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    appearingView.alpha = 1
                }

                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    mask.layer.cornerRadius = 0
                    mask.frame = container.bounds
                }
            })
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
