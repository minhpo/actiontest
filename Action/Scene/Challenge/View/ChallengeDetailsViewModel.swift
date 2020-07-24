import Foundation

struct ChallengeDetailsViewModel {
    
    enum ContentItem {
        case banner(viewModel: ChallengeBannerViewPresentable)
        case info(viewModel: ChallengeInfoPresentable)
        case buttons(types: [ButtonType])
    }
    
    enum ButtonType {
        case snooze
        case finish
    }
    
    let content: [ContentItem]
}
