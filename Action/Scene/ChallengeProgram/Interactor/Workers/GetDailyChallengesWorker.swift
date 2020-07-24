import Foundation

protocol GetDailyChallengesWorker {
    func invoke(programId: Int, completion: @escaping (Result<DailyChallengeEntity, Error>) -> Void)
}

final class GetDailyChallengesService: GetDailyChallengesWorker {
    
    private let provider: Provider
    
    init(provider: Provider = JsonProvider()) {
        self.provider = provider
    }
    
    func invoke(programId: Int, completion: @escaping (Result<DailyChallengeEntity, Error>) -> Void) {
        provider.request(endPoint: .getChallenges(programId: programId), as: DailyChallengeEntity.self, completion: completion)
    }
}
