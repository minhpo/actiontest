import UIKit

final class CardOpenExpandNavigationAnimator: NSObject {
    
    private let cardExpandAnimator = CardExpandNavigationAnimator()
    private let openCardAnimator = InteractiveOpenCardAnimator()
    
    private var transitionContext: UIViewControllerContextTransitioning?
    private var frontSide: CardDealable?
    private var backSide: CardDealable?
}

// MARK: - UIViewControllerAnimatedTransitioning -

extension CardOpenExpandNavigationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return cardExpandAnimator.transitionDuration(using: transitionContext) + InteractiveOpenCardAnimator.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.viewController(forKey: .from)?.beginAppearanceTransition(false, animated: true)
        transitionContext.viewController(forKey: .to)?.beginAppearanceTransition(true, animated: true)
        
        self.transitionContext = transitionContext
        openCard(using: transitionContext)
    }
}

// MARK: - Private methods -

private extension CardOpenExpandNavigationAnimator {
    
    func openCard(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        let disappearingViewController = transitionContext.viewController(forKey: .from)
        var expandAnimatableContext: CardOpenExpandAnimatableContext?
        if let navigationController = disappearingViewController as? UINavigationController {
            expandAnimatableContext = navigationController.topViewController as? CardOpenExpandAnimatableContext
        } else {
            expandAnimatableContext = disappearingViewController as? CardOpenExpandAnimatableContext
        }
        
        guard let frontSide = expandAnimatableContext?.frontSide, let backSide = expandAnimatableContext?.backSide, let position = expandAnimatableContext?.position else { return }
        
        self.frontSide = frontSide
        self.backSide = backSide
        
        backSide.frame = position
        container.addSubview(backSide)
        
        frontSide.frame = position
        container.addSubview(frontSide)
        
        openCardAnimator.setupBackSide(backSide)
        openCardAnimator.attach(to: frontSide)
        openCardAnimator.delegate = self
        
        openCardAnimator.openCard()
    }
}

// MARK: - InteractiveOpenCardAnimatorDelegate -

extension CardOpenExpandNavigationAnimator: InteractiveOpenCardAnimatorDelegate {
    
    func openCardAnimator(_ animator: InteractiveOpenCardAnimator, didOpen card: CardDealable) {
        guard let transitionContext = self.transitionContext else { return }
        cardExpandAnimator.transit(using: transitionContext) {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            transitionContext.viewController(forKey: .from)?.endAppearanceTransition()
            transitionContext.viewController(forKey: .to)?.endAppearanceTransition()
        }
        
        frontSide?.removeFromSuperview()
        backSide?.removeFromSuperview()
    }
}
