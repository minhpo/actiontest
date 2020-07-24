import UIKit

protocol ChallengeProgramRouterDelegate: AnyObject {
    
    func setup(with viewController: (ChallengeProgramDisplayLogic & UIViewController)?)
    func routeToChallengeSelection(for challengeProgram: ChallengeProgram, dailyChallenges: [Challenge])
    func routeToQuiz(for challengeProgram: ChallengeProgram)
}

final class ChallengeProgramRouter: NSObject, ChallengeProgramRouterDelegate {
    
    private weak var viewController: (ChallengeProgramDisplayLogic & UIViewController)?
    private let makeChallengeSelectionViewController: (ChallengeProgram, [Challenge]) -> ChallengeSelectionViewController
    private let makeQuizViewController: (ChallengeProgram) -> QuizViewController
    private var modalPresentationController: ModalPresentationController?
    
    init(makeChallengeSelectionViewController: @escaping (ChallengeProgram, [Challenge]) -> ChallengeSelectionViewController = ChallengeSelectionViewControllerFactory.make,
         makeQuizViewController: @escaping (ChallengeProgram) -> QuizViewController = QuizViewControllerFactory.make) {
        self.makeChallengeSelectionViewController = makeChallengeSelectionViewController
        self.makeQuizViewController = makeQuizViewController
    }
    
    func setup(with viewController: (ChallengeProgramDisplayLogic & UIViewController)?) {
        self.viewController = viewController
    }
    
    func routeToChallengeSelection(for challengeProgram: ChallengeProgram, dailyChallenges: [Challenge]) {
        let targetViewController = makeChallengeSelectionViewController(challengeProgram, dailyChallenges)
        viewController?.navigationController?.pushViewController(targetViewController, animated: true)
    }
    
    func routeToQuiz(for challengeProgram: ChallengeProgram) {
        let targetViewController = makeQuizViewController(challengeProgram)
        modalPresentationController = ModalPresentationController(presentedViewController: targetViewController, presenting: viewController)
        modalPresentationController?.present(with: CardExpandNavigationAnimator(), andDismissWith: CardCollapseNavigationAnimator())
    }
}
