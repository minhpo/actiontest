import UIKit
import EasyPeasy

final class ChallengeProgramLargeCardContentView: UIView, CardContentView {
    
    private let contentLayoutGuide = UILayoutGuide()
    private let iconImageView = UIImageView()
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: ChallengeProgramContentViewPresentable) {
        backgroundColor = viewModel.backgroundColor
        iconImageView.image = viewModel.icon
        textLabel.attributedText = viewModel.text
    }
}

extension ChallengeProgramLargeCardContentView: ConfigurableView {
    
    func configureViewProperties() {
        isUserInteractionEnabled = false
    }
    
    func configureSubviews() {
        addLayoutGuide(contentLayoutGuide)
        addSubview(iconImageView)
        
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.contentMode = .center
        addSubview(textLabel)
    }
    
    func configureLayout() {
        let horizontalMargin = StyleGuide.Margins.default
        contentLayoutGuide.easy.layout(
            Leading(horizontalMargin),
            Trailing(horizontalMargin),
            CenterY()
        )
        
        iconImageView.easy.layout(
            Top().to(contentLayoutGuide, .top),
            CenterX().to(contentLayoutGuide)
        )
        
        textLabel.easy.layout(
            Top(16).to(iconImageView),
            Leading().to(contentLayoutGuide, .leading),
            Trailing().to(contentLayoutGuide, .trailing),
            Bottom().to(contentLayoutGuide, .bottom)
        )
    }
}
