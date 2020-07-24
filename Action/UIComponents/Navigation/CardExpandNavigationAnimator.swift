import UIKit
import EasyPeasy

final class CardExpandNavigationAnimator: NSObject {
    
    private let animationDuration: TimeInterval = 0.5
    
    func transit(using transitionContext: UIViewControllerContextTransitioning, completion: @escaping () -> Void) {
        let container = transitionContext.containerView
        
        let disappearingViewController = transitionContext.viewController(forKey: .from)
        var expandAnimatableContext: CardExpandAnimatableContext?
        if let navigationController = disappearingViewController as? UINavigationController {
            expandAnimatableContext = navigationController.topViewController as? CardExpandAnimatableContext
        } else {
            expandAnimatableContext = disappearingViewController as? CardExpandAnimatableContext
        }
        guard let animatable = expandAnimatableContext?.expandable, let startingFrame = expandAnimatableContext?.origin else { return }
        container.addSubview(animatable)
        animatable.easy.layout(
            Leading(startingFrame.minX),
            Top(startingFrame.minY),
            Width(startingFrame.width),
            Height(startingFrame.height)
        )
        container.layoutIfNeeded()
        
        guard let appearingView = transitionContext.view(forKey: .to) else { return }
        container.addSubview(appearingView)

        appearingView.alpha = 0
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: self.animationDuration, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            UIView.animateKeyframes(withDuration: self.animationDuration, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    let margin: CGFloat = -CardViewConstants.borderWidth
                    let destination = container.bounds.inset(by: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
                    animatable.easy.layout(
                        Leading(margin),
                        Top(margin),
                        Width(destination.width),
                        Height(destination.height)
                    )
                    container.layoutIfNeeded()
                }

                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    appearingView.alpha = 1
                }
            })
        }, completion: { _ in
            animatable.removeFromSuperview()
            completion()
        })
    }
}

// MARK: - UIViewControllerAnimatedTransitioning -

extension CardExpandNavigationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.viewController(forKey: .from)?.beginAppearanceTransition(false, animated: true)
        transitionContext.viewController(forKey: .to)?.beginAppearanceTransition(true, animated: true)
        
        transit(using: transitionContext) {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            transitionContext.viewController(forKey: .from)?.endAppearanceTransition()
            transitionContext.viewController(forKey: .to)?.endAppearanceTransition()
        }
    }
}
