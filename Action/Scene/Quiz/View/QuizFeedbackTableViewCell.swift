import UIKit
import EasyPeasy

final class QuizFeedbackTableViewCell: UITableViewCell {
    
    // MARK: Private properties
    private let feedbackLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: QuizFeedbackViewPresentable) {
        feedbackLabel.text = viewModel.feedback
    }
}

// MARK: - ConfigurableView -

extension QuizFeedbackTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
    }
    
    func configureSubviews() {
        feedbackLabel.textColor = StyleGuide.Colors.GreyTones.black
        feedbackLabel.font = StyleGuide.Fonts.QuizCard.feedback
        feedbackLabel.numberOfLines = 0
        contentView.addSubview(feedbackLabel)
    }
    
    func configureLayout() {
        feedbackLabel.easy.layout(
            Edges()
        )
    }
}
