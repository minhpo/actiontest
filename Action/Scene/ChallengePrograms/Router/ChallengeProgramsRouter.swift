import UIKit

protocol ChallengeProgramsRouterDelegate: AnyObject {
    
    func setup(with viewController: (ChallengeProgramsDisplayLogic & UIViewController)?)
    func route(to program: ChallengeProgram)
    func routeToInfo(for program: ChallengeProgram)
}

final class ChallengeProgramsRouter: NSObject, ChallengeProgramsRouterDelegate {
    
    private let makeProgramViewController: (ChallengeProgram) -> ChallengeProgramViewController
    private let makeProgramInfoViewController: (ChallengeProgram) -> ChallengeProgramInfoViewController
    
    private weak var viewController: (ChallengeProgramsDisplayLogic & UIViewController)?
    private var modalPresentationController: ModalPresentationController?
    
    init(makeProgramViewController: @escaping (ChallengeProgram) -> ChallengeProgramViewController = ChallengeProgramViewControllerFactory.make,
         makeProgramInfoViewController: @escaping (ChallengeProgram) -> ChallengeProgramInfoViewController = ChallengeProgramInfoViewControllerFactory.make) {
        self.makeProgramViewController = makeProgramViewController
        self.makeProgramInfoViewController = makeProgramInfoViewController
    }
    
    func setup(with viewController: (ChallengeProgramsDisplayLogic & UIViewController)?) {
        self.viewController = viewController
    }
    
    func route(to program: ChallengeProgram) {
        let targetViewController = makeProgramViewController(program)
        targetViewController.title = program.title
        targetViewController.backgroundColor = UIColor(hex: program.color)
        viewController?.navigationController?.pushViewController(targetViewController, animated: true)
    }
    
    func routeToInfo(for program: ChallengeProgram) {
        guard let viewController = viewController else { return }
        
        let targetViewController = makeProgramInfoViewController(program)
        
        modalPresentationController = ModalPresentationController(presentedViewController: targetViewController, presenting: viewController)
        modalPresentationController?.present(with: CardOpenExpandNavigationAnimator(), andDismissWith: CardCloseCollapseNavigationAnimator())
    }
}
