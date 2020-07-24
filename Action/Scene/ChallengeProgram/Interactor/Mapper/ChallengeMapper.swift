import Foundation

protocol ChallengeMapper {
    func map(from entity: ChallengeCardEntity, with status: Challenge.Status) -> Challenge?
}

struct ChallengeMappingService: ChallengeMapper {
    
    private let bannerMapper: BannerMapper
    private let additionalInfoMapper: AdditionalInfoMapper
    private let assignmentMapper: AssignmentMapper
    
    init(bannerMapper: BannerMapper = BannerMappingService(),
         additionalInfoMapper: AdditionalInfoMapper = AdditionalInfoMappingService(),
         assignmentMapper: AssignmentMapper = AssignmentMappingService()) {
        self.bannerMapper = bannerMapper
        self.additionalInfoMapper = additionalInfoMapper
        self.assignmentMapper = assignmentMapper
    }
    
    func map(from entity: ChallengeCardEntity, with status: Challenge.Status) -> Challenge? {
        guard let banner = bannerMapper.map(from: entity) else {
            return nil
        }
        
        let assignments: [Assignment]
        if let elementList = entity.challengeElementList {
            assignments = elementList.compactMap { assignmentMapper.map(from: $0) }
        } else {
            assignments = []
        }
        
        let challenge = Challenge(id: entity.id,
                                  color: entity.challengeCardColor,
                                  status: status,
                                  banner: banner,
                                  titleFront: entity.challengeFrontTitle,
                                  descriptionFront: entity.challengeFrontDescription ?? "",
                                  titleBack: entity.challengeBackTitle,
                                  descriptionBack: entity.challengeBackDescription ?? "",
                                  additionalInfo: additionalInfoMapper.map(from: entity),
                                  assignments: assignments)
        
        return challenge
    }
}
