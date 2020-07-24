import UIKit
import EasyPeasy

final class QuizMoreInfoTableViewCell: UITableViewCell {
    
    // MARK: Private properties
    private let button = GHChevronButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurableView -

extension QuizMoreInfoTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
    }
    
    func configureSubviews() {
        button.setTitleColor(StyleGuide.Colors.Secondary.pink, for: .normal)
        button.tintColor = StyleGuide.Colors.Secondary.pink
        button.setTitle("quiz_more_info_button".localized(), for: .normal)
        contentView.addSubview(button)
    }
    
    func configureLayout() {
        button.easy.layout(
            Top(),
            Leading(),
            Trailing(<=0),
            Bottom()
        )
    }
}
