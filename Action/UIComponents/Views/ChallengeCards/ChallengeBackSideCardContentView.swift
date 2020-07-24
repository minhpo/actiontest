import UIKit
import EasyPeasy

final class ChallengeBackSideCardContentView: UIView, CardContentView {
    
    private let bannerLayoutGuide = UILayoutGuide()
    private let challengeInfoView = ChallengeInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: ChallengeBackSideCardContentViewPresentable) {
        challengeInfoView.update(for: viewModel.challengeInfo)
        
        if let videoViewModel = viewModel.banner as? ChallengeVideoBannerViewPresentable {
            let banner = ChallengeVideoBannerView(viewModel: videoViewModel)
            configureBanner(banner)
        } else if let imageViewModel = viewModel.banner as? ChallengeImageBannerViewPresentable {
            let banner = ChallengeImageBannerView(viewModel: imageViewModel)
            configureBanner(banner)
        } else if let quoteViewModel = viewModel.banner as? ChallengeQuoteBannerViewPresentable {
            let banner = ChallengeQuoteBannerView(viewModel: quoteViewModel)
            configureBanner(banner)
        }
    }
}

// MARK: - ConfigurableView -

extension ChallengeBackSideCardContentView: ConfigurableView {
    
    func configureViewProperties() {
        backgroundColor = StyleGuide.Colors.GreyTones.white
        isUserInteractionEnabled = false
    }
    
    func configureSubviews() {
        addLayoutGuide(bannerLayoutGuide)
        
        challengeInfoView.shouldFadeContent = true
        addSubview(challengeInfoView)
    }
    
    func configureLayout() {
        bannerLayoutGuide.easy.layout(
            Leading(),
            Trailing(),
            Top(),
            Height(*0.75).like(self, .width)
        )
        
        let margin: CGFloat = 16
        challengeInfoView.easy.layout(
            Top(24).to(bannerLayoutGuide),
            Leading(margin),
            Trailing(margin),
            Bottom()
        )
    }
}

// MARK: - Private methods -

private extension ChallengeBackSideCardContentView {
    
    func configureBanner(_ banner: UIView) {
        banner.layer.cornerRadius = 8
        banner.clipsToBounds = true
        addSubview(banner)
        
        banner.easy.layout(
            Leading().to(bannerLayoutGuide, .leading),
            Trailing().to(bannerLayoutGuide, .trailing),
            Top().to(bannerLayoutGuide, .top),
            Bottom().to(bannerLayoutGuide, .bottom)
        )
    }
}
