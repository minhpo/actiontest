import UIKit
import EasyPeasy

private enum Constants {
    
    enum Margin {
        static let horizontal: CGFloat = StyleGuide.Margins.default
    }
}

final class ChallengeInfoTableViewCell: UITableViewCell {
    
    private let challengeInfoView = ChallengeInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let totalHorizontalMargin = Constants.Margin.horizontal * 2
        return CGSize(width: totalHorizontalMargin + challengeInfoView.bounds.width, height: challengeInfoView.bounds.height)
    }
    
    func update(for viewModel: ChallengeInfoPresentable) {
        challengeInfoView.update(for: viewModel)
    }
}

// MARK: - ConfigurableView -

extension ChallengeInfoTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
    }
    
    func configureSubviews() {
        addSubview(challengeInfoView)
    }
    
    func configureLayout() {
        challengeInfoView.easy.layout(
            Leading(Constants.Margin.horizontal),
            Trailing(Constants.Margin.horizontal),
            Top(),
            Bottom()
        )
    }
}
