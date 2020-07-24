import UIKit

final class InteractiveDiscardCardAnimator {
    
    // MARK: Internal properties
    weak var delegate: InteractiveDiscardCardAnimatorDelegate?
    
    // MARK: Private properties
    private weak var card: CardStackable?
    private weak var table: DealingTable?
    
    private var startingPosition: CGFloat?
    
    private lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGestureRecognized(gestureRecognizer:)))
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGestureRecognized(gestureRecognized:)))
    
    private var animator: UIViewPropertyAnimator = UIViewPropertyAnimator()
    
    func attach(to card: CardStackable) {
        self.card = card
        card.addGestureRecognizer(panGestureRecognizer)
        card.addGestureRecognizer(tapGestureRecognizer)
        
        table = card.superview
        
        startingPosition = card.frame.maxY
    }
    
    func detach() {
        card?.removeGestureRecognizer(panGestureRecognizer)
        card?.removeGestureRecognizer(tapGestureRecognizer)
        card = nil
        table = nil
        
        startingPosition = nil
    }
}

// MARK: - Private methods -

private extension InteractiveDiscardCardAnimator {
    
    @objc
    func onTapGestureRecognized(gestureRecognized: UITapGestureRecognizer) {
        guard let card = card else { return }
        
        animator = self.animator(for: card)
        animator.startAnimation()
    }
    
    @objc
    func onPanGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        guard let card = card else { return }
        
        switch gestureRecognizer.state {
        case .began:
            animator = self.animator(for: card)
        case .changed:
            let displacement = self.displacement(for: gestureRecognizer)
            let progress = self.progress(for: displacement)
            animator.fractionComplete = abs(progress)
        case .ended:
            let velocity = gestureRecognizer.velocity(in: table).y
            
            let displacement = self.displacement(for: gestureRecognizer)
            let progress = self.progress(for: displacement)
            
            animator.isReversed = !(progress > 0.5 || velocity < -300)
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            break
        }
    }
    
    func progress(for displacement: CGFloat) -> CGFloat {
        let totalDistance = startingPosition ?? 0
        let progress = max(0, min(1, displacement / totalDistance))
        
        return progress
    }
    
    func displacement(for gestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        guard let table = table else { return 0 }
        return -1 * gestureRecognizer.translation(in: table).y
    }
    
    func animator(for card: CardStackable) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [unowned self] in
            card.transform = CGAffineTransform(translationX: 0, y: -(self.startingPosition ?? 0))
        }
        
        animator.addCompletion { [weak self] position in
            guard let self = self, position == .end else { return }
            self.delegate?.discardCardAnimator(self, didDiscard: card)
        }
        
        return animator
    }
}
