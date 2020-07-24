import UIKit
import EasyPeasy

private enum Constants {
    static let interItemSpacing: CGFloat = 12
}

final class ChallengeReflectionButtonsTableViewCell: UITableViewCell {
    
    // MARK: Internal properties
    weak var delegate: ChallengeReflectionButtonsTableViewDelegate?
    
    // MARK: Private properties
    private let submitButton = GHButton()
    private let cancelButton = GHButton()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let totalButtonsHeight: CGFloat = CGFloat(buttons.count) * StyleGuide.DefaultSizes.buttonHeight
        let totalSpacing: CGFloat = CGFloat(buttons.count - 1) * Constants.interItemSpacing
        
        return CGSize(width: UIView.noIntrinsicMetric, height: totalSpacing + totalButtonsHeight)
    }
    
    func update(for viewModel: ChallengeReflectionButtonsPresentable) {
        submitButton.backgroundColor = viewModel.tintColor
    }
}

// MARK: - ConfigurableView -

extension ChallengeReflectionButtonsTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
    }
    
    func configureSubviews() {
        configure(button: submitButton, title: "challenge_reflection_submit_button".localized())
        
        cancelButton.backgroundColor = StyleGuide.Colors.GreyTones.lightGrey
        configure(button: cancelButton, title: "challenge_reflection_cancel_button".localized())
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = Constants.interItemSpacing
        stackView.addArrangedSubviews(buttons)
        contentView.addSubview(stackView)
    }
    
    func configureLayout() {
        let margin = StyleGuide.Margins.default
        stackView.easy.layout(
            Leading(margin),
            Trailing(margin),
            Top(),
            Bottom()
        )
    }
}

// MARK: - Private extension -

private extension ChallengeReflectionButtonsTableViewCell {
    
    var buttons: [UIButton] {
        return [submitButton, cancelButton]
    }
    
    func configure(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(StyleGuide.Colors.GreyTones.black, for: .normal)
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    @objc
    func onTap(sender: UIButton) {
        switch sender {
        case submitButton:
            delegate?.buttonsCellDidSubmit(self)
        case cancelButton:
            delegate?.buttonsCellDidCancel(self)
        default:
            break
        }
    }
}
