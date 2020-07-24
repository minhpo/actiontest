import Foundation

protocol ActivateDailyChallengeWorker {
    func invoke(programId: Int, challengeId: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

final class ActivateDailyChallengeService: ActivateDailyChallengeWorker {
    
    func invoke(programId: Int, challengeId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // TODO: return result
    }
}
