import Foundation

protocol AppSessionWorker {
    func getAppSession(completion: @escaping (Result<AppSessionResponse, Error>) -> Void)
}

final class AppSessionService: AppSessionWorker {
    
    private let provider: Provider
    
    init(provider: Provider = JsonProvider()) {
        self.provider = provider
    }
    
    func getAppSession(completion: @escaping (Result<AppSessionResponse, Error>) -> Void) {
        provider.request(endPoint: .appSession, as: AppSessionResponse.self, completion: completion)
    }
}
