import UIKit
import EasyPeasy

enum CardViewConstants {
    static let borderWidth: CGFloat = 12
}

final class CardView<ContentView: CardContentView>: UIControl, Card {
    
    let contentView = ContentView()
    private let contentContainerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurableView -

extension CardView: ConfigurableView {
    
    func configureViewProperties() {
        backgroundColor = StyleGuide.Colors.GreyTones.white
        layer.cornerRadius = 16
        
        addShadow()
    }
    
    func configureSubviews() {
        contentContainerView.isUserInteractionEnabled = contentView.isUserInteractionEnabled
        contentContainerView.layer.cornerRadius = 8
        contentContainerView.clipsToBounds = true
        addSubview(contentContainerView)
        
        contentContainerView.addSubview(contentView)
    }
    
    func configureLayout() {
        contentContainerView.easy.layout(
            Edges(CardViewConstants.borderWidth)
        )
        
        contentView.easy.layout(
            Edges()
        )
    }
}

// MARK: - CardStackable -

extension CardView: CardDealable, CardStackable { }
