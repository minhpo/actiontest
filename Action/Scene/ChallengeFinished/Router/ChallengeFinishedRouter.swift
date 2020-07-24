import UIKit

protocol ChallengeFinishedRouterDelegate: AnyObject {
    func setup(with viewController: (ChallengeFinishedDisplayLogic & UIViewController)?, routingCoordinator: ChallengeSelectionRouterDelegate)
    func routeToRelection(for challenge: Challenge, withDelegate refectionDelegate: ChallengeReflectionDelegate)
}

final class ChallengeFinishedRouter: ChallengeFinishedRouterDelegate {
    
    private var routingCoordinator: ChallengeSelectionRouterDelegate?
    private weak var viewController: (ChallengeFinishedDisplayLogic & UIViewController)?
    
    func setup(with viewController: (ChallengeFinishedDisplayLogic & UIViewController)?, routingCoordinator: ChallengeSelectionRouterDelegate) {
        self.viewController = viewController
        self.routingCoordinator = routingCoordinator
    }
    
    func routeToRelection(for challenge: Challenge, withDelegate refectionDelegate: ChallengeReflectionDelegate) {
        routingCoordinator?.routeToReflection(for: challenge, withDelegate: refectionDelegate)
    }
}
