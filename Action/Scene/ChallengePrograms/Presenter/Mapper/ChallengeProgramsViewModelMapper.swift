import UIKit

protocol ChallengeProgramsViewModelMapper {
    func map(from domain: [ChallengeProgram]) -> [ChallengeProgramsViewModel]
    func map(from domain: ChallengeProgram) -> ChallengeProgramsViewModel
}

struct ChallengeProgramsViewModelMappingService: ChallengeProgramsViewModelMapper {
    
    func map(from domain: [ChallengeProgram]) -> [ChallengeProgramsViewModel] {
        return domain.map(map(from:))
    }
    
    func map(from domain: ChallengeProgram) -> ChallengeProgramsViewModel {
        return ChallengeProgramsViewModel(title: domain.title, text: domain.description, color: UIColor(hex: domain.color), imageUrl: URL(string: domain.imageUrl), hasReadMoreUrl: domain.infoUrl != nil)
    }
}
