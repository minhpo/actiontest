import UIKit
import EasyPeasy

final class ChallengeBannerTableViewCell: UITableViewCell {
    
    // MARK: Private properties
    private var viewModel: ChallengeBannerViewPresentable?
    private var bannerView: UIView?
    private let bannerLayoutGuide = UILayoutGuide()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: ChallengeBannerViewPresentable) {
        guard isNewViewModel(viewModel) else {
            return
        }
        
        self.viewModel = viewModel
        bannerView?.removeFromSuperview()
        bannerView = bannerView(for: viewModel)
        configureBanner()
    }
}

// MARK: - ConfigurableView -

extension ChallengeBannerTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
    }
    
    func configureSubviews() {
        contentView.addLayoutGuide(bannerLayoutGuide)
    }
    
    func configureLayout() {
        bannerLayoutGuide.easy.layout(
            Edges(),
            Height(*0.75).like(contentView, .width)
        )
    }
}

// MARK: - Private methods -

private extension ChallengeBannerTableViewCell {
    
    func bannerView(for viewModel: ChallengeBannerViewPresentable) -> UIView? {
        if let videoViewModel = viewModel as? ChallengeVideoBannerViewPresentable {
            return ChallengeVideoBannerView(viewModel: videoViewModel)
            
        } else if let imageViewModel = viewModel as? ChallengeImageBannerViewPresentable {
            return ChallengeImageBannerView(viewModel: imageViewModel)
            
        } else if let quoteViewModel = viewModel as? ChallengeQuoteBannerViewPresentable {
            return ChallengeQuoteBannerView(viewModel: quoteViewModel)
        
        } else {
            return nil
        }
    }
    
    func isNewViewModel(_ viewModel: ChallengeBannerViewPresentable) -> Bool {
        if let newViewModel = viewModel as? ChallengeVideoBannerViewPresentable,
            let oldViewModel = self.viewModel as? ChallengeVideoBannerViewPresentable {
            return newViewModel.url != oldViewModel.url
            
        } else if let newViewModel = viewModel as? ChallengeImageBannerViewPresentable,
            let oldViewModel = self.viewModel as? ChallengeImageBannerViewPresentable {
            return newViewModel.url != oldViewModel.url
            
        } else if let newViewModel = viewModel as? ChallengeQuoteBannerViewPresentable,
            let oldViewModel = self.viewModel as? ChallengeQuoteBannerViewPresentable {
            return newViewModel.text != oldViewModel.text
            
        } else {
            return true
        }
    }
    
    func configureBanner() {
        guard let bannerView = bannerView else { return }
        
        bannerView.layer.cornerRadius = 8
        bannerView.clipsToBounds = true
        contentView.addSubview(bannerView)
        
        bannerView.easy.layout(
            Leading().to(bannerLayoutGuide, .leading),
            Trailing().to(bannerLayoutGuide, .trailing),
            Top().to(bannerLayoutGuide, .top),
            Bottom().to(bannerLayoutGuide, .bottom)
        )
    }
}
