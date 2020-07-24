import Foundation

protocol CardDealerDelegate: AnyObject {
    func cardDealder(_ dealer: CardDealer, didDraw card: CardDealable)
    func cardDealder(_ dealer: CardDealer, willReturn card: CardDealable)
    func cardDealder(_ dealer: CardDealer, didReturn card: CardDealable)
    func cardDealder(_ dealer: CardDealer, willOpen card: CardDealable)
    func cardDealder(_ dealer: CardDealer, didOpen card: CardDealable)
    func cardDealder(_ dealer: CardDealer, willClose card: CardDealable)
    func cardDealder(_ dealer: CardDealer, didClose card: CardDealable)
}

extension CardDealerDelegate {
    func cardDealder(_ dealer: CardDealer, didDraw card: CardDealable) { }
    func cardDealder(_ dealer: CardDealer, willReturn card: CardDealable) { }
    func cardDealder(_ dealer: CardDealer, didReturn card: CardDealable) { }
    func cardDealder(_ dealer: CardDealer, willOpen card: CardDealable) { }
    func cardDealder(_ dealer: CardDealer, didOpen card: CardDealable) { }
    func cardDealder(_ dealer: CardDealer, willClose card: CardDealable) { }
    func cardDealder(_ dealer: CardDealer, didClose card: CardDealable) { }
}
