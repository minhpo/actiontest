import UIKit

protocol ChallengeFinishedViewModelMapper {
    func map(from domain: Challenge) -> ChallengeFinishedViewModel?
}

struct ChallengeFinishedViewModelMappingService: ChallengeFinishedViewModelMapper {
    
    private let challengeCardContentViewModelMapper: ChallengeCardContentViewModelMapper
    
    init(challengeCardContentViewModelMapper: ChallengeCardContentViewModelMapper = ChallengeCardContentViewModelMappingService()) {
        self.challengeCardContentViewModelMapper = challengeCardContentViewModelMapper
    }
    
    func map(from domain: Challenge) -> ChallengeFinishedViewModel? {
        guard let card = challengeCardContentViewModelMapper.map(from: domain) else { return nil }
        let tintColor = UIColor(hex: domain.color)
        
        return ChallengeFinishedViewModel(tintColor: tintColor, card: card, shouldHideReflection: domain.status == .closed)
    }
}
