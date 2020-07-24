import UIKit
import EasyPeasy

final class OnboardingInstructionCardContentView: UIView, CardContentView {
    
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: OnboardingInstructionCardContentViewPresentable) {
        titleLabel.attributedText = viewModel.title
        textLabel.text = viewModel.text
    }
}

// MARK: - ConfigurableView -

extension OnboardingInstructionCardContentView: ConfigurableView {
    
    func configureViewProperties() {
        backgroundColor = StyleGuide.Colors.GreyTones.white
        isUserInteractionEnabled = false
    }
    
    func configureSubviews() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        textLabel.numberOfLines = 0
        textLabel.font = StyleGuide.Fonts.OnboardingInstructionCard.text
        textLabel.textColor = StyleGuide.Colors.GreyTones.midGrey
        addSubview(textLabel)
    }
    
    func configureLayout() {
        let margin: CGFloat = 16
        let interItemSpacing: CGFloat = 24
        
        titleLabel.easy.layout(
            Leading(margin),
            Trailing(margin),
            Top(margin)
        )
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        textLabel.easy.layout(
            Top(interItemSpacing).to(titleLabel),
            Leading(margin),
            Trailing(margin),
            Bottom(<=margin)
        )
    }
}
