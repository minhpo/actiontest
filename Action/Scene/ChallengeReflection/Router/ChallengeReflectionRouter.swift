import UIKit

protocol ChallengeReflectionRouterDelegate: AnyObject {
    func setup(with viewController: (ChallengeReflectionDisplayLogic & UIViewController)?)
}

final class ChallengeReflectionRouter: ChallengeReflectionRouterDelegate {
    
    private weak var viewController: (ChallengeReflectionDisplayLogic & UIViewController)?
    
    func setup(with viewController: (ChallengeReflectionDisplayLogic & UIViewController)?) {
        self.viewController = viewController
    }
}
