import UIKit

protocol ChallengesAvailableRouterDelegate: AnyObject {
    
    func setup(with viewController: (ChallengesAvailableDisplayLogic & UIViewController)?, routingCoordinator: ChallengeSelectionRouterDelegate)
    func route(to challenge: Challenge)
}

final class ChallengesAvailableRouter: ChallengesAvailableRouterDelegate {
    
    private var routingCoordinator: ChallengeSelectionRouterDelegate?
    private weak var viewController: (ChallengesAvailableDisplayLogic & UIViewController)?
    
    func setup(with viewController: (ChallengesAvailableDisplayLogic & UIViewController)?, routingCoordinator: ChallengeSelectionRouterDelegate) {
        self.viewController = viewController
        self.routingCoordinator = routingCoordinator
    }
    
    func route(to challenge: Challenge) {
        routingCoordinator?.route(to: challenge)
    }
}
