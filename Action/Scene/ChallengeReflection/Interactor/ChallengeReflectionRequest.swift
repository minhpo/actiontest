import Foundation

enum ChallengeReflectionRequest {
    case initialize
    case buttonTap(type: ButtonType)
    
    enum ButtonType {
        case submit
        case cancel
    }
}
