import Foundation

protocol SubmitChallengeAnswersWorker {
    func invoke(id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class SubmitChallengeAnswersService: SubmitChallengeAnswersWorker {
    func invoke(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
}
