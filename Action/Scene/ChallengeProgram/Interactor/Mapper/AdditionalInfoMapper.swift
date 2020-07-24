import Foundation

protocol AdditionalInfoMapper {
    func map(from challengeCardEntity: ChallengeCardEntity) -> AdditionalInfo
}

struct AdditionalInfoMappingService: AdditionalInfoMapper {
    
    func map(from challengeCardEntity: ChallengeCardEntity) -> AdditionalInfo {
        AdditionalInfo(duration: challengeCardEntity.estimatedDuration,
                       participants: challengeCardEntity.participantCount,
                       points: challengeCardEntity.xp)
    }
}
