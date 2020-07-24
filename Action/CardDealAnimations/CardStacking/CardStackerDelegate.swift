import Foundation

protocol CardStackerDelegate: AnyObject {
    func cardStacker(_ stacker: CardStacker, didPop card: CardStackable)
}
