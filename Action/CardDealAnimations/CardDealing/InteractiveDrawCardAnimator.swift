import UIKit

final class InteractiveDrawCardAnimator {
    
    // MARK: Internal properties
    weak var delegate: InteractiveDrawCardAnimatorDelegate?
    
    // MARK: Private properties
    private weak var card: CardDealable?
    private weak var table: DealingTable?
    
    private var startingCenterPosition: CGPoint?
    private var endingCenterPosition: CGPoint?
    
    private lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGestureRecognized(gestureRecognizer:)))
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGestureRecognized(gestureRecognized:)))
    
    private var animator: UIViewPropertyAnimator = UIViewPropertyAnimator()
    
    func attach(to card: CardDealable) {
        self.card = card
        card.addGestureRecognizer(panGestureRecognizer)
        card.addGestureRecognizer(tapGestureRecognizer)
        
        table = card.superview
        
        startingCenterPosition = CGPoint(x: card.frame.midX, y: card.frame.midY)
        endingCenterPosition = CGPoint(x: table?.bounds.midX ?? 0, y: table?.bounds.midY ?? 0)
    }
    
    func detach() {
        card?.removeGestureRecognizer(panGestureRecognizer)
        card?.removeGestureRecognizer(tapGestureRecognizer)
        card = nil
        table = nil
        
        startingCenterPosition = nil
        endingCenterPosition = nil
    }
}

// MARK: - Private methods -

private extension InteractiveDrawCardAnimator {
    
    @objc
    func onTapGestureRecognized(gestureRecognized: UITapGestureRecognizer) {
        guard let card = card else { return }
        
        animator = self.animator(for: card)
        delegate?.drawCardAnimator(self, willDraw: card)
        animator.startAnimation()
    }
    
    @objc
    func onPanGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        guard let card = card, let table = table else { return }
        
        switch gestureRecognizer.state {
        case .began:
            animator = self.animator(for: card)
            delegate?.drawCardAnimator(self, willDraw: card)
        case .changed:
            let displacement = gestureRecognizer.translation(in: table).y
            let progress = self.progress(for: displacement)
            animator.fractionComplete = abs(progress)
        case .ended:
            let velocity = gestureRecognizer.velocity(in: table).y
            
            let displacement = gestureRecognizer.translation(in: table).y
            let progress = self.progress(for: displacement)

            animator.isReversed = !(progress > 0.5 || velocity > 300)
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            break
        }
    }
    
    func progress(for displacement: CGFloat) -> CGFloat {
        let totalDistance = (endingCenterPosition?.y ?? 0) - (startingCenterPosition?.y ?? 0)
        let progress = min(1, abs(displacement / totalDistance))
        
        return progress
    }
    
    func animator(for card: CardDealable) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            card.transform = .identity
        }
        
        animator.addCompletion { [weak self] position in
            guard let self = self else { return }
            if position == .end {
                self.delegate?.drawCardAnimator(self, didDraw: card)
            } else {
                self.delegate?.drawCardAnimator(self, didCancelDraw: card)
            }
        }
        
        return animator
    }
}
