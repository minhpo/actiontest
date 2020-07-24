import UIKit
import EasyPeasy

final class QuizQuestionTableViewCell: UITableViewCell {
    
    // MARK: Private properties
    private let questionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: QuizQuestionViewPresentable) {
        questionLabel.text = viewModel.question
    }
}

// MARK: - ConfigurableView -

extension QuizQuestionTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
    }
    
    func configureSubviews() {
        questionLabel.numberOfLines = 0
        questionLabel.font = StyleGuide.Fonts.QuizCard.question
        questionLabel.textColor = StyleGuide.Colors.GreyTones.black
        contentView.addSubview(questionLabel)
    }
    
    func configureLayout() {
        questionLabel.easy.layout(
            Edges()
        )
    }
}
