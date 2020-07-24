import Foundation

enum ChallengeRequest {
    case initialize
    case banner
    case buttonTap(type: ButtonType)
    
    enum ButtonType {
        case snooze
        case finish
    }
}
