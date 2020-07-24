import UIKit
import EasyPeasy

final class SimpleCardContentView: UIView, CardContentView {
    
    private let imageLayoutGuide = UILayoutGuide()
    private let iconImageView = UIImageView(image: UIImage(named: "icon.logo"))
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: SimpleCardContentViewPresentable) {
        backgroundColor = viewModel.color
        textLabel.text = viewModel.text
    }
}

// MARK: - ConfigurableView -

extension SimpleCardContentView: ConfigurableView {
    
    func configureViewProperties() {
        isUserInteractionEnabled = false
    }
    
    func configureSubviews() {
        addLayoutGuide(imageLayoutGuide)
        
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)
        
        textLabel.numberOfLines = 0
        textLabel.font = StyleGuide.Fonts.SimpleCard.text
        textLabel.textColor = StyleGuide.Colors.GreyTones.darkGrey.withAlphaComponent(0.7)
        addSubview(textLabel)
    }
    
    func configureLayout() {
        let margin: CGFloat = 10
        let interItem: CGFloat = 6
        
        imageLayoutGuide.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Height().like(imageLayoutGuide, .width)
        )
        
        iconImageView.easy.layout(
            CenterX().to(imageLayoutGuide),
            CenterY().to(imageLayoutGuide),
            Width(*0.28).like(self)
        )
        
        textLabel.easy.layout(
            Top(>=interItem).to(imageLayoutGuide),
            Leading(margin),
            Trailing(margin),
            Bottom(margin)
        )
    }
}
