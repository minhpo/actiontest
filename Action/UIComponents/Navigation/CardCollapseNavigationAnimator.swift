import UIKit
import EasyPeasy

final class CardCollapseNavigationAnimator: NSObject {
    
    let animationDuration: TimeInterval = 0.5
    
    func transit(using transitionContext: UIViewControllerContextTransitioning, completion: @escaping () -> Void) {
        guard let disappearingView = transitionContext.view(forKey: .from) else { return }
        
        let appearingViewController = transitionContext.viewController(forKey: .to)
        guard let appearingView = appearingViewController?.view else { return }
        
        let container = transitionContext.containerView
        if !(appearingViewController is UINavigationController) {
            container.insertSubview(appearingView, belowSubview: disappearingView)
        }
        
        var collapsableAnimatableContext: CardCollapseAnimatableContext?
        if let navigationController = appearingViewController as? UINavigationController {
            collapsableAnimatableContext = navigationController.topViewController as? CardCollapseAnimatableContext
        } else {
            collapsableAnimatableContext = appearingViewController as? CardCollapseAnimatableContext
        }
        guard let animatable = collapsableAnimatableContext?.collapsible, let destination = collapsableAnimatableContext?.destination else { return }
        container.insertSubview(animatable, aboveSubview: appearingView)
        
        let margin: CGFloat = -CardViewConstants.borderWidth
        let startingFrame = container.bounds.inset(by: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
        animatable.easy.layout(
            Leading(margin),
            Top(margin),
            Width(startingFrame.width),
            Height(startingFrame.height)
        )
        container.layoutIfNeeded()
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: self.animationDuration, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            UIView.animateKeyframes(withDuration: self.animationDuration, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    disappearingView.alpha = 0
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    animatable.easy.layout(
                        Leading(destination.minX),
                        Top(destination.minY),
                        Width(destination.width),
                        Height(destination.height)
                    )
                    container.layoutIfNeeded()
                }
            })
        }, completion: { _ in
            animatable.removeFromSuperview()
            completion()
        })
    }
}

// MARK: - UIViewControllerAnimatedTransitioning -

extension CardCollapseNavigationAnimator: UIViewControllerAnimatedTransitioning {
    
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
