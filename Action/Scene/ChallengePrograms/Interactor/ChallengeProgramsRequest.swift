import Foundation

enum ChallengeProgramsRequest {
    case initialize
    case openChallengeProgram(index: Int)
    case openChallengeProgramInfo(index: Int)
}
