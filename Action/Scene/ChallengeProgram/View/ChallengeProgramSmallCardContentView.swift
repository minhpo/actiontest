import UIKit
import EasyPeasy

final class ChallengeProgramSmallCardContentView: UIView, CardContentView {
    
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

extension ChallengeProgramSmallCardContentView: ConfigurableView {
    
    func configureViewProperties() {
        isUserInteractionEnabled = false
    }
    
    func configureSubviews() {
        addSubview(iconImageView)
        
        textLabel.numberOfLines = 0
        addSubview(textLabel)
    }
    
    func configureLayout() {
        let horizontalMargin = StyleGuide.Margins.default
        iconImageView.easy.layout(
            Leading(horizontalMargin),
            CenterY()
        )
        
        textLabel.easy.layout(
            Leading(16).to(iconImageView),
            Trailing(horizontalMargin),
            Top(),
            Bottom()
        )
    }
}
