import UIKit

protocol ChallengeCardContentViewModelMapper {
    func map(from domain: [Challenge]) -> [ChallengeCardContentViewModel]
    func map(from domain: Challenge) -> ChallengeCardContentViewModel?
}

struct ChallengeCardContentViewModelMappingService: ChallengeCardContentViewModelMapper {
    
    private let challengeBannerViewPresentableMapper: ChallengeBannerViewPresentableMapper
    private let challengeInfoPresentableMapper: ChallengeInfoPresentableMapper
    
    init(challengeBannerViewPresentableMapper: ChallengeBannerViewPresentableMapper = ChallengeBannerViewPresentableMappingService(),
         challengeInfoPresentableMapper: ChallengeInfoPresentableMapper = ChallengeInfoPresentableMappingService()) {
        self.challengeBannerViewPresentableMapper = challengeBannerViewPresentableMapper
        self.challengeInfoPresentableMapper = challengeInfoPresentableMapper
    }
    
    func map(from domain: [Challenge]) -> [ChallengeCardContentViewModel] {
        return domain.compactMap(map(from:))
    }
    
    func map(from domain: Challenge) -> ChallengeCardContentViewModel? {
        guard let banner = challengeBannerViewPresentableMapper.map(from: domain) else { return nil }
        let tintColor = UIColor(hex: domain.color)
        let challengeInfo = challengeInfoPresentableMapper.map(from: domain)
        return ChallengeCardContentViewModel(tintColor: tintColor, challengeInfo: challengeInfo, banner: banner)
    }
}
