import Foundation

protocol GetChallengeProgramsWorker {
    func invoke(completion: @escaping (Result<[ChallengeProgram], Error>) -> Void)
}

final class GetChallengeProgramsService: GetChallengeProgramsWorker {
    
    private let appSessionWorker: AppSessionWorker
    private let challengeProgramsMapper: ChallengeProgramsMapper
    
    init(appSessionWorker: AppSessionWorker = AppSessionService(),
         challengeProgramsMapper: ChallengeProgramsMapper = ChallengeProgramsMappingService()) {
        self.appSessionWorker = appSessionWorker
        self.challengeProgramsMapper = challengeProgramsMapper
    }
    
    func invoke(completion: @escaping (Result<[ChallengeProgram], Error>) -> Void) {
        appSessionWorker.getAppSession { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let deckList = response.cardDeckList, deckList.isEmpty == false else {
                    completion(.success([])) // TODO: Discuss error handling
                    return
                }
                
                let challengePrograms = deckList.map { self.challengeProgramsMapper.map(from: $0) }
                completion(.success(challengePrograms))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
