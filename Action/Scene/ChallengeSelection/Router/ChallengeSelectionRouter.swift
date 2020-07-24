import UIKit

protocol ChallengeSelectionRouterDelegate: AnyObject {
    
    func setup(with viewController: (ChallengeSelectionDisplayLogic & UIViewController)?, challengeStatusTransitioningDelegate: ChallengeStatusTransitioningDelegate)
    func route(to challenge: Challenge)
    func routeToActiveChallenge(_ challenge: Challenge)
    func routeToFinishedChallenge(_ challenge: Challenge)
    func routeToAvailableChallenges(for challengeProgram: ChallengeProgram, challenges: [Challenge])
    func routeToChallengeProgram(onChallengeStatusTransition: Bool)
    func routeToReflection(for challenge: Challenge, withDelegate refectionDelegate: ChallengeReflectionDelegate)
}

final class ChallengeSelectionRouter: NSObject, ChallengeSelectionRouterDelegate {
    
    private let makeChallengesAvailableViewController: (ChallengeProgram, [Challenge], ChallengeSelectionRouterDelegate) -> ChallengesAvailableViewController
    private let makeChallengeActiveViewController: (Challenge, ChallengeSelectionRouterDelegate) -> ChallengeActiveViewController
    private let makeChallengeFinishedViewController: (Challenge, ChallengeSelectionRouterDelegate) -> ChallengeFinishedViewController
    private let makeChallengeViewController: (Challenge, ChallengeStatusTransitioningDelegate) -> ChallengeViewController
    private let makeChallengeReflectionViewController: (Challenge, ChallengeStatusTransitioningDelegate, ChallengeReflectionDelegate) -> ChallengeReflectionViewController
    
    private weak var challengeStatusTransitioningDelegate: ChallengeStatusTransitioningDelegate?
    private weak var viewController: (ChallengeSelectionDisplayLogic & UIViewController)?
    private var modalPresentationController: ModalPresentationController?
    
    init(makeChallengesAvailableViewController: @escaping (ChallengeProgram, [Challenge], ChallengeSelectionRouterDelegate) -> ChallengesAvailableViewController = ChallengesAvailableViewControllerFactory.make,
        makeChallengeActiveViewController: @escaping (Challenge, ChallengeSelectionRouterDelegate) -> ChallengeActiveViewController = ChallengeActiveViewControllerFactory.make,
        makeChallengeFinishedViewController: @escaping (Challenge, ChallengeSelectionRouterDelegate) -> ChallengeFinishedViewController = ChallengeFinishedViewControllerFactory.make,
        makeChallengeViewController: @escaping (Challenge, ChallengeStatusTransitioningDelegate) -> ChallengeViewController = ChallengeViewControllerFactory.make,
        makeChallengeReflectionViewController: @escaping (Challenge, ChallengeStatusTransitioningDelegate, ChallengeReflectionDelegate) -> ChallengeReflectionViewController = ChallengeReflectionViewControllerFactory.make) {
        self.makeChallengesAvailableViewController = makeChallengesAvailableViewController
        self.makeChallengeActiveViewController = makeChallengeActiveViewController
        self.makeChallengeFinishedViewController = makeChallengeFinishedViewController
        self.makeChallengeViewController = makeChallengeViewController
        self.makeChallengeReflectionViewController = makeChallengeReflectionViewController
    }
    
    func setup(with viewController: (ChallengeSelectionDisplayLogic & UIViewController)?, challengeStatusTransitioningDelegate: ChallengeStatusTransitioningDelegate) {
        self.viewController = viewController
        self.challengeStatusTransitioningDelegate = challengeStatusTransitioningDelegate
    }
    
    func route(to challenge: Challenge) {
        guard let viewController = viewController, let transitioningDelegate = challengeStatusTransitioningDelegate else { return }
        let targetViewController = makeChallengeViewController(challenge, transitioningDelegate)
        
        targetViewController.tableView.contentInsetAdjustmentBehavior = .never
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: viewController.view.safeAreaInsets.bottom, right: 0)
        targetViewController.tableView.contentInset = insets
        targetViewController.tableView.scrollIndicatorInsets = insets
        
        modalPresentationController = ModalPresentationController(presentedViewController: targetViewController, presenting: viewController)
        modalPresentationController?.present(with: CardExpandNavigationAnimator(), andDismissWith: CardCloseCollapseNavigationAnimator())
    }
    
    func routeToActiveChallenge(_ challenge: Challenge) {
        let targetViewController = makeChallengeActiveViewController(challenge, self)
        viewController?.set(presentable: targetViewController)
    }
    
    func routeToFinishedChallenge(_ challenge: Challenge) {
        if viewController?.children.first(where: { $0 is ChallengeActiveViewController }) != nil {
            modalPresentationController?.dismiss { [weak self] in
                guard let self = self else { return }
                let targetViewController = self.makeChallengeFinishedViewController(challenge, self)
                self.viewController?.set(presentable: targetViewController)
            }
        } else if viewController?.children.first(where: { $0 is ChallengeFinishedViewController }) != nil {
            modalPresentationController?.dismiss()
        } else {
            let targetViewController = self.makeChallengeFinishedViewController(challenge, self)
            viewController?.set(presentable: targetViewController)
        }
    }
    
    func routeToAvailableChallenges(for challengeProgram: ChallengeProgram, challenges: [Challenge]) {
        let targetViewController = makeChallengesAvailableViewController(challengeProgram, challenges, self)
        viewController?.set(presentable: targetViewController)
    }
    
    func routeToChallengeProgram(onChallengeStatusTransition: Bool = false) {
        if onChallengeStatusTransition {
            modalPresentationController?.dismiss { [weak self] in
                self?.viewController?.navigationController?.popViewController(animated: true)
            }
        } else {
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
    
    func routeToReflection(for challenge: Challenge, withDelegate refectionDelegate: ChallengeReflectionDelegate) {
        guard let viewController = viewController, let transitioningDelegate = challengeStatusTransitioningDelegate else { return }
        let targetViewController = makeChallengeReflectionViewController(challenge, transitioningDelegate, refectionDelegate)
        
        targetViewController.tableView.contentInsetAdjustmentBehavior = .never
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: viewController.view.safeAreaInsets.bottom, right: 0)
        targetViewController.tableView.contentInset = insets
        targetViewController.tableView.scrollIndicatorInsets = insets
        
        modalPresentationController = ModalPresentationController(presentedViewController: targetViewController, presenting: viewController, includeNavigation: false)
        modalPresentationController?.present(with: MaskExpandNavigationAnimator(), andDismissWith: MaskCollapseNavigationAnimator())
    }
}
