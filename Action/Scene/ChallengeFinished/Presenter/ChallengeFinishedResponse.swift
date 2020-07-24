import Foundation

enum ChallengeFinishedResponse {
    case initialise(challenge: Challenge)
    case update(challenge: Challenge)
}
