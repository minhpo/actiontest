import UIKit
import EasyPeasy

final class QuizExplanationTableViewCell: UITableViewCell {
    
    // MARK: Private properties
    private let explanationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: QuizExplanationViewPresentable) {
        explanationLabel.text = viewModel.explanation
    }
}

// MARK: - ConfigurableView -

extension QuizExplanationTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
    }
    
    func configureSubviews() {
        explanationLabel.textColor = StyleGuide.Colors.GreyTones.midGrey
        explanationLabel.font = StyleGuide.Fonts.QuizCard.explanation
        explanationLabel.numberOfLines = 0
        contentView.addSubview(explanationLabel)
    }
    
    func configureLayout() {
        explanationLabel.easy.layout(
            Edges()
        )
    }
}
