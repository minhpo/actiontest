import UIKit
import EasyPeasy

final class QuizTitleTableViewCell: UITableViewCell {
    
    // MARK: Private properties
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: QuizTitleViewPresentable) {
        titleLabel.text = viewModel.title
    }
}

// MARK: - ConfigurableView -

extension QuizTitleTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
    }
    
    func configureSubviews() {
        titleLabel.numberOfLines = 0
        titleLabel.font = StyleGuide.Fonts.QuizCard.title
        titleLabel.textColor = StyleGuide.Colors.GreyTones.midGrey
        contentView.addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.easy.layout(
            Edges()
        )
    }
}
