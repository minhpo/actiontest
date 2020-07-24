import UIKit

protocol QuizCardContentViewPresentable {
    var content: [QuizCardContentViewPresentableItem] { get }
    var delaySubmit: Bool { get }
}
