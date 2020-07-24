import UIKit

protocol ChallengeInfoPresentableMapper {
    func map(from domain: Challenge) -> ChallengeInfoPresentable
}

struct ChallengeInfoPresentableMappingService: ChallengeInfoPresentableMapper {
    
    func map(from domain: Challenge) -> ChallengeInfoPresentable {
        let durationPostfix = "challenge_duration_postfix".localized()
        let participantsPostfix = "challenge_participants_postfix".localized()
        let pointsPostfix = "challenge_points_postfix".localized()
        
        return ChallengeInfoViewModel(
            titleFront: domain.titleFront,
            subtitleFront: domain.descriptionFront,
            titleBack: domain.titleBack,
            subtitleBack: domain.descriptionBack,
            durationAdditionalInfo: InfoViewModel(text: "\(domain.additionalInfo.duration) \(durationPostfix)", image: UIImage(named: "icon.info.duration") ?? UIImage()),
            participantsAdditionalInfo: InfoViewModel(text: "\(domain.additionalInfo.participants) \(participantsPostfix)", image: UIImage(named: "icon.info.participants") ?? UIImage()),
            pointsAdditionalInfo: InfoViewModel(text: "\(domain.additionalInfo.points) \(pointsPostfix)", image: UIImage(named: "icon.info.points") ?? UIImage()))
    }
}
