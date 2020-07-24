import UIKit

protocol ChallengeProgramInfoViewModelMapper {
    func map(from domain: ChallengeProgram) -> ChallengeProgramInfoViewModel
}

struct ChallengeProgramInfoViewModelMappingService: ChallengeProgramInfoViewModelMapper {
    
    func map(from domain: ChallengeProgram) -> ChallengeProgramInfoViewModel {
        return ChallengeProgramInfoViewModel(title: domain.title, text: domain.description, color: UIColor(hex: domain.color), hasReadMoreUrl: domain.infoUrl != nil)
    }
}
