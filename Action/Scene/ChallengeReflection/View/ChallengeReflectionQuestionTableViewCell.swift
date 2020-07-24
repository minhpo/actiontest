import UIKit
import EasyPeasy

final class ChallengeReflectionQuestionTableViewCell: UITableViewCell {
    
    // MARK: Private properties
    private let questionLabel = UILabel()
    private let minValueLabel = UILabel()
    private let maxValueLabel = UILabel()
    private let slider = GHDiscreteSlider()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: ChallengeReflectionQuestionPresentable) {
        questionLabel.text = viewModel.question
        minValueLabel.text = viewModel.minValueText
        maxValueLabel.text = viewModel.maxValueText
    }
}

// MARK: - ConfigurableView -

extension ChallengeReflectionQuestionTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
    }
    
    func configureSubviews() {
        questionLabel.numberOfLines = 0
        questionLabel.font = StyleGuide.Fonts.ChallengeReflection.question
        questionLabel.textColor = StyleGuide.Colors.GreyTones.black
        contentView.addSubview(questionLabel)

        minValueLabel.font = StyleGuide.Fonts.ChallengeReflection.answer
        minValueLabel.textColor = StyleGuide.Colors.GreyTones.midGrey
        contentView.addSubview(minValueLabel)
        
        maxValueLabel.textAlignment = .right
        maxValueLabel.font = StyleGuide.Fonts.ChallengeReflection.answer
        maxValueLabel.textColor = StyleGuide.Colors.GreyTones.midGrey
        contentView.addSubview(maxValueLabel)
        
        slider.minimumValue = 1
        slider.maximumValue = 10
        contentView.addSubview(slider)
    }
    
    func configureLayout() {
        let margin = StyleGuide.Margins.default
        questionLabel.easy.layout(
            Leading(margin),
            Trailing(margin),
            Top()
        )
        
        slider.easy.layout(
            Leading(margin),
            Trailing(margin),
            Top().to(questionLabel)
        )
        
        minValueLabel.easy.layout(
            Leading(margin),
            Trailing(margin/2).to(contentView, .centerX),
            Top().to(slider),
            Bottom()
        )
        
        maxValueLabel.easy.layout(
            Leading(margin/2).to(contentView, .centerX),
            Trailing(margin),
            Top().to(slider),
            Bottom()
        )
    }
}
