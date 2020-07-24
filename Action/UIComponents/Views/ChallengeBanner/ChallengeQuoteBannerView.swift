import UIKit
import EasyPeasy

final class ChallengeQuoteBannerView: UIView {
    
    private let viewModel: ChallengeQuoteBannerViewPresentable
    private let quoteStartImageView = UIImageView(image: UIImage(named: "icon.quote.start"))
    private let quoteEndImageView = UIImageView(image: UIImage(named: "icon.quote.end"))
    private let textLabel = UILabel()
    
    init(viewModel: ChallengeQuoteBannerViewPresentable) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurableView -

extension ChallengeQuoteBannerView: ConfigurableView {
    
    func configureViewProperties() {
        backgroundColor = viewModel.backgroundColor
    }
    
    func configureSubviews() {
        addSubview(quoteStartImageView)
        addSubview(quoteEndImageView)
        
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.contentMode = .center
        textLabel.clipsToBounds = false
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textColor = StyleGuide.Colors.GreyTones.white
        textLabel.font = StyleGuide.Fonts.ChallengeQuoteBanner.text
        textLabel.text = viewModel.text
        addSubview(textLabel)
    }
    
    func configureLayout() {
        let horizontalMargin: CGFloat = 24
        let quoteHeight: CGFloat = 24
        let interItemSpacing: CGFloat = 8
    
        quoteStartImageView.easy.layout(
            Leading(horizontalMargin),
            Top(horizontalMargin),
            Height(quoteHeight)
        )
        
        quoteEndImageView.easy.layout(
            Trailing(horizontalMargin),
            Bottom(horizontalMargin),
            Height(quoteHeight)
        )
        
        textLabel.easy.layout(
            CenterX(),
            CenterY(),
            Leading(>=horizontalMargin),
            Trailing(<=horizontalMargin),
            Top(>=interItemSpacing).to(quoteStartImageView),
            Bottom(<=interItemSpacing).to(quoteEndImageView)
        )
    }
}
