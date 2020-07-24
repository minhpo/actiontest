import UIKit

protocol CardCloseCollapseAnimatableContext {
    var backSide: CardDealable { get }
    var frontSide: CardDealable { get }
    var position: CGRect { get }
}
