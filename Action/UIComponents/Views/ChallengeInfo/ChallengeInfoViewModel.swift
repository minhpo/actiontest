import Foundation

struct ChallengeInfoViewModel: ChallengeInfoPresentable {
    let titleFront: String
    let subtitleFront: String
    let titleBack: String
    let subtitleBack: String 
    let durationAdditionalInfo: InfoViewPresentable
    let participantsAdditionalInfo: InfoViewPresentable
    let pointsAdditionalInfo: InfoViewPresentable
}
