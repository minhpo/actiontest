import UIKit

final class CardDealer: CardSpreader {
    
    // MARK: Internal properties
    weak var delegate: CardDealerDelegate?
    
    // MARK: Private properties
    private let presentCardsAnimator: PresentCardsAnimator = PresentCardsAnimator()
    private let retractCardsAnimator: RetractCardsAnimator = RetractCardsAnimator()
    private let returnCardAnimator: InteractiveReturnCardAnimator = InteractiveReturnCardAnimator()
    private let openCardAnimator: InteractiveOpenCardAnimator = InteractiveOpenCardAnimator()
    private let closeCardAnimator: InteractiveCloseCardAnimator = InteractiveCloseCardAnimator()
    
    private var dealingContexts: [DealingContext] = []
    private var drawCardAnimators: [InteractiveDrawCardAnimator] = []
    private var tapToReturnGestureRecognizers: [UITapGestureRecognizer] = []
    
    init(backSideCard: CardDealable) {
        returnCardAnimator.delegate = self
        closeCardAnimator.delegate = self
        openCardAnimator.delegate = self
        openCardAnimator.setupBackSide(backSideCard)
    }
    
    func present(cards: [CardDealable], on table: DealingTable) {
        dealingContexts = spreadCards(for: cards, on: table)
        drawCardAnimators = allowDrawCard(for: cards, delegate: self)
    }
    
    func representCards() {
        guard !dealingContexts.isEmpty else { return }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            self.dealingContexts.forEach { context in
                context.card.transform = context.transform
            }
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            
            let cards = self.dealingContexts.map { $0.card }
            self.drawCardAnimators = self.allowDrawCard(for: cards, delegate: self)
        })
    }
    
    func closeCard(frontSide: CardDealable, backSide: CardDealable) {
        closeCardAnimator.setupFrontSide(frontSide)
        closeCardAnimator.attach(to: backSide)
        closeCardAnimator.closeCard()
    }
}

// MARK: - Private methods -

private extension CardDealer {
    
    @objc
    func onTapGestureRecognized(gestureRecognizer: UITapGestureRecognizer) {
        returnCardAnimator.returnCard()
    }
}

// MARK: - InteractiveDrawCardAnimatorDelegate -

extension CardDealer: InteractiveDrawCardAnimatorDelegate {
    
    func drawCardAnimator(_ animator: InteractiveDrawCardAnimator, willDraw card: CardDealable) {
        drawCardAnimators.forEach { drawCardAnimator in
            guard drawCardAnimator !== animator else { return }
            drawCardAnimator.detach()
        }
    }
    
    func drawCardAnimator(_ animator: InteractiveDrawCardAnimator, didDraw card: CardDealable) {
        drawCardAnimators.forEach { $0.detach() }
        
        let retractableCards: [CardDealable] = dealingContexts.compactMap { return $0.card !== card ? $0.card : nil }
        retractCardsAnimator.retract(cards: retractableCards, partial: true)
        retractableCards.forEach { card in
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGestureRecognized))
            card.addGestureRecognizer(tapGestureRecognizer)
            tapToReturnGestureRecognizers.append(tapGestureRecognizer)
        }
        
        if let context = dealingContexts.first(where: { $0.card === card }) {
            returnCardAnimator.attach(with: context)
        }
        
        openCardAnimator.attach(to: card)
        
        delegate?.cardDealder(self, didDraw: card)
    }
    
    func drawCardAnimator(_ animator: InteractiveDrawCardAnimator, didCancelDraw card: CardDealable) {
        animator.detach()
        
        let cards = dealingContexts.map { $0.card }
        drawCardAnimators = allowDrawCard(for: cards, delegate: self)
    }
}

// MARK: - InteractiveReturnCardAnimatorDelegate -

extension CardDealer: InteractiveReturnCardAnimatorDelegate {
    
    func returnCardAnimator(_ animator: InteractiveReturnCardAnimator, willReturn card: CardDealable) {
        let contexts = dealingContexts.filter({ $0.card !== card })
        presentCardsAnimator.present(contexts: contexts)
        
        delegate?.cardDealder(self, willReturn: card)
    }
    
    func returnCardAnimator(_ animator: InteractiveReturnCardAnimator, didReturn card: CardDealable) {
        returnCardAnimator.detach()
        
        tapToReturnGestureRecognizers.forEach { $0.view?.removeGestureRecognizer($0) }
        tapToReturnGestureRecognizers.removeAll()
        
        let cards = dealingContexts.map { $0.card }
        drawCardAnimators = allowDrawCard(for: cards, delegate: self)
        
        delegate?.cardDealder(self, didReturn: card)
    }
}

// MARK: - InteractiveOpenCardAnimatorDelegate -

extension CardDealer: InteractiveOpenCardAnimatorDelegate {
    
    func openCardAnimator(_ animator: InteractiveOpenCardAnimator, willOpen card: CardDealable) {
        let retractableCards: [CardDealable] = dealingContexts.compactMap { return $0.card !== card ? $0.card : nil }
        retractCardsAnimator.retract(cards: retractableCards)
        
        delegate?.cardDealder(self, willOpen: card)
    }
    
    func openCardAnimator(_ animator: InteractiveOpenCardAnimator, didOpen card: CardDealable) {
        delegate?.cardDealder(self, didOpen: card)
    }
}

// MARK: - InteractiveCloseCardAnimatorDelegate -
extension CardDealer: InteractiveCloseCardAnimatorDelegate {
    
    func closeCardAnimator(_ animator: InteractiveCloseCardAnimator, willClose card: CardDealable) {
        delegate?.cardDealder(self, willClose: card)
    }
    
    func closeCardAnimator(_ animator: InteractiveCloseCardAnimator, didClose card: CardDealable) {
        delegate?.cardDealder(self, didClose: card)
    }
}
