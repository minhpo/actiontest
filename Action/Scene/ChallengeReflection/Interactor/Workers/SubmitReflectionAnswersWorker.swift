import Foundation

protocol SubmitReflectionAnswersWorker {
    func invoke(dailyChallengeId: Int, selectedChallengeId: String, answers: [ReflectionAnswer], completion: @escaping (Result<Void, Error>) -> Void)
}

final class SubmitReflectionAnswersService: SubmitReflectionAnswersWorker {
    
    func invoke(dailyChallengeId: Int, selectedChallengeId: String, answers: [ReflectionAnswer], completion: @escaping (Result<Void, Error>) -> Void) {
        // TODO: replace with connetion to BE
        completion(.success(()))
    }
}
