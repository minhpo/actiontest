import Foundation

final class JsonProvider: Provider {
    
    func request<T: Decodable>(endPoint: EndPoint, as type: T.Type, completion: (Result<T, Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: endPoint.fileName, ofType: "json") else { fatalError("File not included") }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { fatalError("File could not be loaded") }
        guard let response = try? JSONDecoder().decode(type, from: data) else { fatalError("Content could not be decoded") }
        
        completion(.success(response))
    }
}

private extension EndPoint {
    
    var fileName: String {
        switch self {
        case .appSession: return "AppSession"
        case .getChallenges(let programId): return "AppDailyChallenge_\(programId)"
        }
    }
}
