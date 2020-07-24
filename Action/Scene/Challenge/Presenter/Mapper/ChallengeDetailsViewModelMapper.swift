import UIKit

protocol ChallengeDetailsViewModelMapper {
    func map(from domain: Challenge) -> ChallengeDetailsViewModel?
}

struct ChallengeDetailsViewModelMappingService: ChallengeDetailsViewModelMapper {
    
    private let challengeBannerViewPresentableMapper: ChallengeBannerViewPresentableMapper
    private let challengeInfoPresentableMapper: ChallengeInfoPresentableMapper
    
    init(challengeBannerViewPresentableMapper: ChallengeBannerViewPresentableMapper = ChallengeBannerViewPresentableMappingService(),
         challengeInfoPresentableMapper: ChallengeInfoPresentableMapper = ChallengeInfoPresentableMappingService()) {
        self.challengeBannerViewPresentableMapper = challengeBannerViewPresentableMapper
        self.challengeInfoPresentableMapper = challengeInfoPresentableMapper
    }
    
    func map(from domain: Challenge) -> ChallengeDetailsViewModel? {
        guard let banner = challengeBannerViewPresentableMapper.map(from: domain) else { return nil }
        let challengeInfo = challengeInfoPresentableMapper.map(from: domain)
        
        var contentItems: [ChallengeDetailsViewModel.ContentItem] = [.banner(viewModel: banner), .info(viewModel: challengeInfo)]
        
        let buttonTypes: [ChallengeDetailsViewModel.ButtonType]
        switch domain.status {
        // TODO: snooze is currently OoS, but should be added to array when in scope
        case .active:
            buttonTypes = [.finish]
        default:
            buttonTypes = []
        }
        
        if !buttonTypes.isEmpty {
            contentItems.append(.buttons(types: buttonTypes))
        }
        
        return ChallengeDetailsViewModel(content: contentItems)
    }
}
