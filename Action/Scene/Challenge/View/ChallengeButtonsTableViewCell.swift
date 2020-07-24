import UIKit
import EasyPeasy

private enum Constants {
    static let interItemSpacing: CGFloat = 12
}

final class ChallengeButtonsTableViewCell: UITableViewCell {
    
    // MARK: Internal properties
    weak var delegate: ChallengeButtonsTableViewCellDelegate?
    
    // MARK: Private properties
    private let snoozeButton = GHButton()
    private let finishButton = GHButton()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let visibleButtons = buttons.filter({ !$0.isHidden })
        let totalButtonsHeight: CGFloat = CGFloat(visibleButtons.count) * StyleGuide.DefaultSizes.buttonHeight
        let totalSpacing: CGFloat = !visibleButtons.isEmpty ? CGFloat(visibleButtons.count - 1) * Constants.interItemSpacing : 0
        
        return CGSize(width: UIView.noIntrinsicMetric, height: totalSpacing + totalButtonsHeight)
    }
    
    func update(for buttonTypes: [ChallengeDetailsViewModel.ButtonType]) {
        snoozeButton.isHidden = !buttonTypes.contains(.snooze)
        finishButton.isHidden = !buttonTypes.contains(.finish)
        
        invalidateIntrinsicContentSize()
    }
}

// MARK: - ConfigurableView -

extension ChallengeButtonsTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
    }
    
    func configureSubviews() {
        configure(button: snoozeButton, title: "challenge_snooze_button".localized(), color: StyleGuide.Colors.Primary.ghPurple)
        configure(button: finishButton, title: "challenge_done_button".localized(), color: StyleGuide.Colors.Secondary.yellow)
        
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

// MARK: - Private methods -

private extension ChallengeButtonsTableViewCell {
    
    var buttons: [UIButton] {
        return [snoozeButton, finishButton]
    }
    
    func configure(button: UIButton, title: String, color: UIColor) {
        button.backgroundColor = color
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    @objc
    func onTap(sender: UIButton) {
        switch sender {
        case snoozeButton:
            delegate?.challengeButtonsTableViewCell(self, didTapButton: .snooze)
        case finishButton:
            delegate?.challengeButtonsTableViewCell(self, didTapButton: .finish)
        default:
            break
        }
    }
}
