import UIKit

private enum Constants {
    
    static let duration: TimeInterval = 0.3
    
    enum Transformation {
        private static let flipAngle: CGFloat = CGFloat.pi
        private static let perspective: CGFloat = 1 / -1500
        
        static let intermediate: CATransform3D = {
            let angle = -(Constants.Transformation.flipAngle / 2)
            var transform = CATransform3DIdentity
            transform.m34 = Constants.Transformation.perspective
            return CATransform3DRotate(transform, angle, 0, 1, 0)
        }()
        
        static let end: CATransform3D = {
            let angle = -Constants.Transformation.flipAngle
            var transform = CATransform3DIdentity
            transform.m34 = Constants.Transformation.perspective
            return CATransform3DRotate(transform, angle, 0, 1, 0)
        }()
    }
}

// MARK: - InteractiveOpenCardAnimator -

final class InteractiveOpenCardAnimator: NSObject {
    
    static let duration: TimeInterval = Constants.duration
    
    // MARK: Internal properties
    weak var delegate: InteractiveOpenCardAnimatorDelegate?
    
    // MARK: Private properties
    private weak var frontSide: CardDealable?
    private weak var backSide: CardDealable?
    private weak var table: DealingTable?
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGestureRecognized))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGestureRecognized(gestureRecognized:)))
    
    private var animator: UIViewPropertyAnimator = UIViewPropertyAnimator()
    
    func setupBackSide(_ backSide: CardDealable) {
        self.backSide = backSide
        backSide.layer.transform = Constants.Transformation.intermediate.flippedHorizontally()
    }
    
    func attach(to frontSide: CardDealable) {
        self.frontSide = frontSide
        frontSide.addGestureRecognizer(panGestureRecognizer)
        frontSide.addGestureRecognizer(tapGestureRecognizer)
        
        table = frontSide.superview
    }
    
    func detach() {
        frontSide?.removeGestureRecognizer(panGestureRecognizer)
        frontSide?.removeGestureRecognizer(tapGestureRecognizer)
        frontSide = nil
        table = nil
    }
    
    func openCard() {
        guard backSide != nil else { fatalError("Backside not set up") }
        startOpenCardAnimation()
    }
}

// MARK: - UIGestureRecognizerDelegate -

extension InteractiveOpenCardAnimator: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == panGestureRecognizer, let card = frontSide else { return true }
        
        let velocity = panGestureRecognizer.velocity(in: card)
        return velocity.x < velocity.y
    }
}

// MARK: - Private methods -

private extension InteractiveOpenCardAnimator {
    
    func startOpenCardAnimation() {
        guard let card = frontSide else { return }
        
        self.delegate?.openCardAnimator(self, willOpen: card)
        
        animator = self.animator(for: card)
        animator.startAnimation()
    }
    
    @objc
    func onTapGestureRecognized(gestureRecognized: UITapGestureRecognizer) {
        startOpenCardAnimation()
    }
    
    @objc
    func onPanGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        guard let card = frontSide, let table = table else { return }
        
        switch gestureRecognizer.state {
        case .began:
            animator = self.animator(for: card)
        case .changed:
            let displacement = -1 * gestureRecognizer.translation(in: table).x
            let progress = self.progress(for: displacement)
            animator.fractionComplete = abs(progress)
            
            if progress >= 0.75 {
                // Force gestureRecognizer to stop responding, state will change to cancelled
                gestureRecognizer.isEnabled = false
                gestureRecognizer.isEnabled = true
            }
        case .ended, .cancelled:
            let velocity = gestureRecognizer.velocity(in: table).x
            
            let displacement = -1 * gestureRecognizer.translation(in: table).x
            let progress = self.progress(for: displacement)
            
            animator.isReversed = !(progress > 0.5 || velocity < -300)
            if !animator.isReversed {
                self.delegate?.openCardAnimator(self, willOpen: card)
            }
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            break
        }
    }
    
    func animator(for card: CardDealable) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: Constants.duration, curve: .easeInOut)
        
        animator.addAnimations { [unowned self] in
            UIView.animateKeyframes(withDuration: Constants.duration, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.frontSide?.layer.transform = Constants.Transformation.intermediate
                }

                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.backSide?.layer.transform = Constants.Transformation.end.flippedHorizontally()
                }
            })
        }
        
        animator.addCompletion { [weak self] position in
            guard let self = self, position == .end else { return }
            self.frontSide?.layer.transform = CATransform3DIdentity
            self.backSide?.layer.transform = Constants.Transformation.intermediate.flippedHorizontally()
            self.delegate?.openCardAnimator(self, didOpen: card)
        }
        
        return animator
    }
    
    func progress(for displacement: CGFloat) -> CGFloat {
        let totalDistance = (table?.frame.width ?? 0) * 0.75
        let progress = min(1, abs(displacement / totalDistance))
        return progress
    }
}

// MARK: - CATransform3D -

private extension CATransform3D {
    
    func flippedHorizontally() -> CATransform3D {
        return CATransform3DScale(self, -1, 1, 1)
    }
}
