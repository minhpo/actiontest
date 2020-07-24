import Foundation

enum ChallengeProgramRequest {
    
    enum CardSize {
        case large
        case small
    }
    
    case initialize
    case onTap(cardSize: CardSize)
}
