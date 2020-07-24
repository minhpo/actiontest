import UIKit
import EasyPeasy

private enum Constants {
    static let margin: CGFloat = 12
}

final class QuizAnswersTableViewCell: UITableViewCell {
    
    // MARK: Private properties
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let buttons = stackView.arrangedSubviews
        let totalButtonsHeight: CGFloat = CGFloat(buttons.count) * StyleGuide.DefaultSizes.buttonHeight
        let totalSpacing: CGFloat = !buttons.isEmpty ? CGFloat(buttons.count - 1) * Constants.margin : 0
        
        return CGSize(width: UIView.noIntrinsicMetric, height: totalSpacing + totalButtonsHeight)
    }
    
    func update(for viewModel: QuizAnswersViewPresentable) {
        stackView.removeArrangedSubviews()
        
        let buttons = viewModel.content.map(button(for:))
        stackView.addArrangedSubviews(buttons)
    }
}

//MARK: - ConfigurableView -

extension QuizAnswersTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
        backgroundColor = StyleGuide.Colors.GreyTones.white
    }
    
    func configureSubviews() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = Constants.margin
        addSubview(stackView)
    }
    
    func configureLayout() {
        stackView.easy.layout(
            Edges()
        )
    }
}

// MARK: - Private methods -

private extension QuizAnswersTableViewCell {
    
    func button(for viewModel: QuizAnswersViewPresentableItem) -> GHButton {
        let button = GHButton()
        button.layer.borderWidth = 4
        button.contentHorizontalAlignment = .leading
        
        switch viewModel {
        case .solid(let text, let color):
            button.layer.borderColor = color.cgColor
            button.backgroundColor = color
            button.setTitle(text, for: .normal)
        case .border(let text, let color):
            button.layer.borderColor = color.cgColor
            button.backgroundColor = StyleGuide.Colors.GreyTones.white
            button.setTitle(text, for: .normal)
            button.setTitleColor(color, for: .normal)
        }
        
        return button
    }
}
