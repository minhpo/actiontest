import Foundation

protocol ChallengeStatusMapper {
    func map(from statusString: String) -> Challenge.Status?
}

struct ChallengeStatusMappingService: ChallengeStatusMapper {
    
    func map(from statusString: String) -> Challenge.Status? {
        Challenge.Status(rawValue: statusString)
    }
}
