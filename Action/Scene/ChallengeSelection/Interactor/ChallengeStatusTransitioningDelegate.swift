import Foundation

protocol ChallengeStatusTransitioningDelegate: AnyObject {
    func challengeDidTransitStatus(_ challenge: Challenge)
}
