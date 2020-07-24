import UIKit

private enum Constants {
    static let translation: CGFloat = 16
    static let scaling: CGFloat = 0.1
}

final class CardStacker {
    
    // MARK: Internal properties
    weak var delegate: CardStackerDelegate?
    var isUserInteractionEnabled: Bool = true {
        didSet {
            setupUserInteraction()
        }
    }
    
    // MARK: Private properties
    private var cards: [CardStackable] = []
    private let interactiveDiscardCardAnimator: InteractiveDiscardCardAnimator = InteractiveDiscardCardAnimator()
    
    init() {
        interactiveDiscardCardAnimator.delegate = self
    }
    
    func present(cards: [CardStackable]) {
        self.cards = cards
        stack(cards)
        setupUserInteraction()
    }
}

// MARK: - CardStacker -

private extension CardStacker {
    
    func stack(_ cards: [CardStackable]) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            cards.enumerated().forEach { index, card in
                var transform = CGAffineTransform.identity
                card.transform = .identity
                
                let originalHeight = card.frame.height

                let netScaling = 1 - CGFloat(index) * Constants.scaling
                transform = transform.scaledBy(x: netScaling, y: netScaling)
                card.transform = transform

                let scaledHeight = card.frame.height
                
                let offset = (originalHeight - scaledHeight) / 2
                let adjustedTranslation = (CGFloat(index) * Constants.translation) / netScaling
                transform = transform.translatedBy(x: 0, y: adjustedTranslation + offset)

                card.transform = transform
            }
        }, completion: nil)
    }
    
    func setupUserInteraction() {
        interactiveDiscardCardAnimator.detach()
        
        guard isUserInteractionEnabled, let card = cards.first else { return }
        interactiveDiscardCardAnimator.attach(to: card)
    }
}

// MARK: - InteractiveDiscardCardAnimatorDelegate -

extension CardStacker: InteractiveDiscardCardAnimatorDelegate {
    func discardCardAnimator(_ animator: InteractiveDiscardCardAnimator, didDiscard card: CardStackable) {
        animator.detach()
        
        let cards = self.cards.filter { $0 !== card }
        present(cards: cards)
        
        delegate?.cardStacker(self, didPop: card)
    }
}
