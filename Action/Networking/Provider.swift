import Foundation

protocol Provider {
    func request<T: Decodable>(endPoint: EndPoint, as type: T.Type, completion: (Result<T, Error>) -> Void)
}
