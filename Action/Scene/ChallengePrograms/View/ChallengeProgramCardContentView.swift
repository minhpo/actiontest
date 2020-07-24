import UIKit
import EasyPeasy
import Kingfisher

final class ChallengeProgramCardContentView: UIView, CardContentView {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: ChallengeProgramCardContentViewPresentable) {
        backgroundColor = viewModel.color
        titleLabel.text = viewModel.title
        imageView.kf.setImage(with: viewModel.imageUrl)
    }
}

// MARK: - ConfigurableView -

extension ChallengeProgramCardContentView: ConfigurableView {
    
    func configureViewProperties() {
        isUserInteractionEnabled = false
    }
    
    func configureSubviews() {
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        titleLabel.textColor = StyleGuide.Colors.GreyTones.white
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.contentMode = .center
        titleLabel.font = StyleGuide.Fonts.ChallengeProgramCard.title
        addSubview(titleLabel)
    }
    
    func configureLayout() {
        let horizontalMargin: CGFloat = StyleGuide.Margins.default
        let verticalMargin: CGFloat = 20
        
        imageView.easy.layout(
            Top(verticalMargin).to(self, .top),
            Leading(),
            Trailing(),
            Height().like(imageView, .width)
        )
        
        titleLabel.easy.layout(
            Top(>=0).to(imageView),
            Leading(horizontalMargin),
            Trailing(horizontalMargin),
            Bottom(verticalMargin)
        )
    }
}
