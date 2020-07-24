import Foundation

protocol BannerMapper {
    func map(from challengeCardEntity: ChallengeCardEntity) -> Banner?
}

struct BannerMappingService: BannerMapper {
    
    private let bannerTypeMapper: BannerTypeMapper
    
    init(bannerTypeMapper: BannerTypeMapper = BannerTypeMappingService()) {
        self.bannerTypeMapper = bannerTypeMapper
    }
    
    func map(from challengeCardEntity: ChallengeCardEntity) -> Banner? {
        guard let mediaType = challengeCardEntity.challengeBackMediaType, let type = bannerTypeMapper.map(from: mediaType) else {
            return nil
        }
        
        guard let value = challengeCardEntity.challengeBackMediaValue else {
            return nil
        }
        
        return Banner(type: type, value: value)
    }
}
