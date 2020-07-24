import UIKit

protocol QuizRouterDelegate: AnyObject {
    
    func setup(with viewController: (QuizDisplayLogic & UIViewController)?)
}

final class QuizRouter: QuizRouterDelegate {
    
    private weak var viewController: (QuizDisplayLogic & UIViewController)?
    
    func setup(with viewController: (QuizDisplayLogic & UIViewController)?) {
        self.viewController = viewController
    }
}
