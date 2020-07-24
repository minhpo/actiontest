import Foundation

protocol ChallengeInfoPresentable {
    var titleFront: String { get }
    var subtitleFront: String { get }
    var titleBack: String { get }
    var subtitleBack: String { get }
    var durationAdditionalInfo: InfoViewPresentable { get }
    var participantsAdditionalInfo: InfoViewPresentable { get }
    var pointsAdditionalInfo: InfoViewPresentable { get }
}
