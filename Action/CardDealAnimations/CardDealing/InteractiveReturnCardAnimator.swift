import UIKit

final class InteractiveReturnCardAnimator: NSObject {
    
    weak var delegate: InteractiveReturnCardAnimatorDelegate?
    
    // MARK: Private properties
    private weak var card: CardDealable?
    private weak var table: DealingTable?
    
    private var endingTransform: CGAffineTransform = .identity
    private var startingCenterPosition: CGPoint?
    private var endingCenterPosition: CGPoint?
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGestureRecognized(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    
    private var animator: UIViewPropertyAnimator = UIViewPropertyAnimator()
    
    func attach(with context: DealingContext) {
        let card = context.card
        let endingTransform = context.transform
        
        self.endingTransform = endingTransform
        self.card = card
        card.addGestureRecognizer(panGestureRecognizer)
        
        table = card.superview
        startingCenterPosition = CGPoint(x: card.frame.midX, y: card.frame.midY)
        
        let currentTransform = card.transform
        card.transform = endingTransform
        endingCenterPosition = CGPoint(x: card.frame.midX, y: card.frame.midY)
        card.transform = currentTransform
    }
    
    func returnCard() {
        guard let card = self.card else { return }
        
        self.delegate?.returnCardAnimator(self, willReturn: card)
        
        animator = self.animator(for: card)
        animator.startAnimation()
    }
    
    func detach() {
        card?.removeGestureRecognizer(panGestureRecognizer)
        card = nil
        table = nil
        
        endingTransform = .identity
        startingCenterPosition = nil
        endingCenterPosition = nil
    }
}

// MARK: - UIGestureRecognizerDelegate -

extension InteractiveReturnCardAnimator: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == panGestureRecognizer, let card = card else { return true }
        
        let velocity = panGestureRecognizer.velocity(in: card)
        return velocity.y < velocity.x
    }
}

// MARK: - Private methods -

private extension InteractiveReturnCardAnimator {
    
    @objc
    func onPanGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        guard let card = self.card, let table = table else { return }
        
        switch gestureRecognizer.state {
        case .began:
            animator = self.animator(for: card)
        case .changed:
            let displacement = -1 * gestureRecognizer.translation(in: table).y
            let progress = self.progress(for: displacement)
            animator.fractionComplete = abs(progress)
            
            if progress >= 0.75 {
                // Force gestureRecognizer to stop responding, state will change to cancelled
                gestureRecognizer.isEnabled = false
                gestureRecognizer.isEnabled = true
            }
        case .ended, .cancelled:
            let velocity = gestureRecognizer.velocity(in: table).y
            
            let displacement = -1 * gestureRecognizer.translation(in: table).y
            let progress = self.progress(for: displacement)

            animator.isReversed = !(progress > 0.5 || velocity < -300)
            if !animator.isReversed {
                self.delegate?.returnCardAnimator(self, willReturn: card)
            }

            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            break
        }
    }
    
    func progress(for displacement: CGFloat) -> CGFloat {
        let totalDistance = (startingCenterPosition?.y ?? 0) - (endingCenterPosition?.y ?? 0)
        let progress = min(1, abs(displacement / totalDistance))
        return progress
    }
    
    func animator(for card: CardDealable) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [unowned self] in
            self.card?.transform = self.endingTransform
        }

        animator.addCompletion { [unowned self] position in
            guard position == .end else { return }
            self.delegate?.returnCardAnimator(self, didReturn: card)
        }
        
        return animator
    }
}
