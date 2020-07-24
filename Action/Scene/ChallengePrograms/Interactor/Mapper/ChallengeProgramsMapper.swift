import Foundation

protocol ChallengeProgramsMapper {
    func map(from entity: CardDeckEntity) -> ChallengeProgram
}

struct ChallengeProgramsMappingService: ChallengeProgramsMapper {
    
    func map(from entity: CardDeckEntity) -> ChallengeProgram {
        let status: ChallengeProgram.Status
        if entity.status.lowercased() == "active" {
            status = .active
        } else if entity.status.lowercased() == "open" {
            status = .open
        } else {
            // TODO: Discuss default value
            status = .open
        }
        
        return ChallengeProgram(id: entity.id,
                                title: entity.name,
                                description: entity.description,
                                imageUrl: entity.imageUrl,
                                color: entity.backgroundColor ?? "#FF0000", // TODO: Discuss default value
                                status: status,
                                infoUrl: entity.trainingUrl)
    }
}
