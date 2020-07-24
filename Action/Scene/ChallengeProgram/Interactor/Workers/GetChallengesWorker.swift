import Foundation

protocol GetChallengesWorker {
    func invoke(programId: Int, completion: @escaping (Result<[Challenge], Error>) -> Void)
}

final class GetChallengesService: GetChallengesWorker {
    
    private let getDailyChallengesWorker: GetDailyChallengesWorker
    private let challengeMapper: ChallengeMapper
    private let challengeStatusMapper: ChallengeStatusMapper
    
    init(getDailyChallengesWorker: GetDailyChallengesWorker = GetDailyChallengesService(),
         challengeMapper: ChallengeMapper = ChallengeMappingService(),
         challengeStatusMapper: ChallengeStatusMapper = ChallengeStatusMappingService()) {
        self.getDailyChallengesWorker = getDailyChallengesWorker
        self.challengeMapper = challengeMapper
        self.challengeStatusMapper = challengeStatusMapper
    }
    
    func invoke(programId: Int, completion: @escaping (Result<[Challenge], Error>) -> Void) {
        getDailyChallengesWorker.invoke(programId: programId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let list = response.challengeCardList else {
                    completion(.success([]))
                    return
                }
                
                let challenges: [Challenge] = list.compactMap { entity in
                    let status: Challenge.Status
                    if let selectedId = response.selectedCardId, selectedId == entity.id {
                        status = self.challengeStatusMapper.map(from: response.status) ?? .active
                    } else {
                        status = .open
                    }
                    return self.challengeMapper.map(from: entity, with: status)
                }
                
                completion(.success(challenges))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
