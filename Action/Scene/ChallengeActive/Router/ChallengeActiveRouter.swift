import UIKit

protocol ChallengeActiveRouterDelegate: AnyObject {
    func setup(with viewController: (ChallengeActiveDisplayLogic & UIViewController)?, routingCoordinator: ChallengeSelectionRouterDelegate)
    func route(to challenge: Challenge)
    func routeToChallengeProgram()
}

final class ChallengeActiveRouter: ChallengeActiveRouterDelegate {
    
    private var routingCoordinator: ChallengeSelectionRouterDelegate?
    private weak var viewController: (ChallengeActiveDisplayLogic & UIViewController)?
    
    func setup(with viewController: (ChallengeActiveDisplayLogic & UIViewController)?, routingCoordinator: ChallengeSelectionRouterDelegate) {
        self.viewController = viewController
        self.routingCoordinator = routingCoordinator
    }
    
    func route(to challenge: Challenge) {
        routingCoordinator?.route(to: challenge)
    }
    
    func routeToChallengeProgram() {
        routingCoordinator?.routeToChallengeProgram(onChallengeStatusTransition: false)
    }
}
