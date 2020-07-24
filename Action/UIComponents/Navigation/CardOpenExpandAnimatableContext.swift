import UIKit

protocol CardOpenExpandAnimatableContext {
    var backSide: CardDealable { get }
    var frontSide: CardDealable { get }
    var position: CGRect { get }
}
