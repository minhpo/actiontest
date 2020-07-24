import UIKit
import EasyPeasy

final class CardDeckView: UIControl {
    
    private var cards: [Card] = []
    private(set) var isSpread: Bool = false
    
    init(cards: [Card]) {
        self.cards = cards
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spread(completionhandler: (() -> Void)? = nil) {
        guard !isSpread else { return }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            let radians: CGFloat = .radians(degrees: 5)
            
            self.cards.enumerated().forEach { offset, card in
                var angle = CGFloat(offset) * radians
                if (offset % 2) == 0 {
                    angle = -1 * angle
                }
                
                card.transform = CGAffineTransform(rotationAngle: angle)
            }
            }, completion: { _ in completionhandler?() })
        
        isSpread = true
    }
    
    func close(completionhandler: (() -> Void)? = nil) {
        guard isSpread else { return }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            self.cards.forEach { $0.transform = .identity }
            }, completion: { _ in completionhandler?() })
        
        isSpread = false
    }
}

// MARK: - ConfigurableView -

extension CardDeckView: ConfigurableView {
    
    func configureViewProperties() {
        backgroundColor = .clear
    }
    
    func configureSubviews() {
        cards.forEach { card in
            insertSubview(card, at: 0)
            card.isUserInteractionEnabled = false
        }
    }
    
    func configureLayout() {
        cards.forEach { card in
            card.easy.layout(
                Edges()
            )
        }
    }
}
