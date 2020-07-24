import Foundation

protocol BannerTypeMapper {
    func map(from typeString: String) -> BannerType?
}

struct BannerTypeMappingService: BannerTypeMapper {
    
    func map(from typeString: String) -> BannerType? {
        BannerType(rawValue: typeString)
    }
}
