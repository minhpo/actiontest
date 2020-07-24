import UIKit

protocol ChallengeBannerViewPresentableMapper {
    func map(from domain: Challenge) -> ChallengeBannerViewPresentable?
}

struct ChallengeBannerViewPresentableMappingService: ChallengeBannerViewPresentableMapper {
    
    func map(from domain: Challenge) -> ChallengeBannerViewPresentable? {
        var banner: ChallengeBannerViewPresentable?
        switch domain.banner.type {
        case .video:
            if let url = URL(string: domain.banner.value) {
                banner = ChallengeVideoBannerViewModel(url: url, backgroundColor: UIColor(hex: domain.color))
            }
        case .image:
            if let url = URL(string: domain.banner.value) {
                banner = ChallengeImageBannerViewModel(url: url, backgroundColor: UIColor(hex: domain.color))
            }
        case .text:
            banner = ChallengeQuoteBannerViewModel(text: domain.banner.value, backgroundColor: UIColor(hex: domain.color))
        }
        return banner
    }
}
