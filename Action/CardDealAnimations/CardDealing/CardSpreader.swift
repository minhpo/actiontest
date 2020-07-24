import UIKit

private enum Constants {
    
    enum Rotations {
        static let lowerbound: CGFloat = -12
        static let upperbound: CGFloat = 12
    }
    
    enum Translation {
        enum Horizontal {
            static let lowerbound: CGFloat = -0.275
            static let upperbound: CGFloat = 0.275
        }
        enum Vertical {
            static let lowerbound: CGFloat = 0
            static let upperbound: CGFloat = 0.1
        }
    }
    
    enum Scaling {
        static let multiplier: CGFloat = 0.65
    }
}

protocol CardSpreader {
    func spreadCards(for cards: [CardDealable], on table: DealingTable) -> [DealingContext]
    func allowDrawCard(for cards: [CardDealable], delegate: InteractiveDrawCardAnimatorDelegate) -> [InteractiveDrawCardAnimator]
}

extension CardSpreader {
    
    func spreadCards(for cards: [CardDealable], on table: DealingTable) -> [DealingContext] {
        let rotationIncrement = cards.count > 1 ? totalRotationRange / CGFloat(cards.count - 1) : 0
        let horizontalTranslationIncrement = cards.count > 1 ? totalHorizontalTranslationRange(for: table) / CGFloat(cards.count - 1) : 0
        let verticalTranslationIncrement = cards.count > 1 ? totalVerticalTranslationRange(for: table) / CGFloat(cards.count - 1) : 0
        
        var rotation = Constants.Rotations.lowerbound
        var horizontalTranslation = horizontalTranslationLowerBound(for: table)
        var verticalTranslation = verticalTranslationLowerBound(for: table)
        
        var contexts: [DealingContext] = []
        cards.forEach { card in
            card.transform = initialTransform(for: rotation, xTranslation: -horizontalTranslation, yTranslation: verticalTranslation, on: table)
            
            let context = DealingContext(transform: card.transform, card: card)
            contexts.append(context)
            
            rotation += rotationIncrement
            horizontalTranslation += horizontalTranslationIncrement
            verticalTranslation += verticalTranslationIncrement
        }
        
        return contexts
    }
    
    func allowDrawCard(for cards: [CardDealable], delegate: InteractiveDrawCardAnimatorDelegate) -> [InteractiveDrawCardAnimator] {
        var animators: [InteractiveDrawCardAnimator] = []
        cards.forEach { card in
            let animator = InteractiveDrawCardAnimator()
            animator.delegate = delegate
            animator.attach(to: card)
            animators.append(animator)
        }
        return animators
    }
}

// MARK: - Private methods -

private extension CardSpreader {
    
    var totalRotationRange: CGFloat { return Constants.Rotations.upperbound - Constants.Rotations.lowerbound }
    
    func horizontalTranslationLowerBound(for table: DealingTable) -> CGFloat {
        return table.bounds.midX * Constants.Translation.Horizontal.lowerbound
    }
    
    func horizontalTranslationUpperBound(for table: DealingTable) -> CGFloat {
        return table.bounds.midX * Constants.Translation.Horizontal.upperbound
    }
    
    func totalHorizontalTranslationRange(for table: DealingTable) -> CGFloat {
        return horizontalTranslationUpperBound(for: table) - horizontalTranslationLowerBound(for: table)
    }
    
    func verticalTranslationLowerBound(for table: DealingTable) -> CGFloat {
        return table.bounds.height * Constants.Translation.Vertical.lowerbound
    }
    
    func verticalTranslationUpperBound(for table: UIView) -> CGFloat {
        return table.bounds.height * Constants.Translation.Vertical.upperbound
    }
    
    func totalVerticalTranslationRange(for table: DealingTable) -> CGFloat {
        return verticalTranslationUpperBound(for: table) - verticalTranslationLowerBound(for: table)
    }
    
    func initialTransform(for rotation: CGFloat, xTranslation: CGFloat, yTranslation: CGFloat, on table: DealingTable) -> CGAffineTransform {
        let radians: CGFloat = rotation / 180 * CGFloat.pi
        return CGAffineTransform.identity
            .translatedBy(x: xTranslation, y: yTranslation)
            .translatedBy(x: 0, y: -(1 * table.bounds.midY))
            .rotated(by: radians)
            .scaledBy(x: Constants.Scaling.multiplier, y: Constants.Scaling.multiplier)
    }
}
