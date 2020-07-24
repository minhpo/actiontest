import Foundation

enum LoginRequest {
    case startScanning
    case scanned(secret: String)
    case failedScanning(error: ScannerError)
    case settings
}
