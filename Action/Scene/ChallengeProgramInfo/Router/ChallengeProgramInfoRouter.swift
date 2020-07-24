import UIKit
import SafariServices

protocol ChallengeProgramInfoRouterDelegate: AnyObject {
    
    func setup(with viewController: (ChallengeProgramInfoDisplayLogic & UIViewController)?)
    func routeToBrowser(for challengeProgram: ChallengeProgram)
}

final class ChallengeProgramInfoRouter: ChallengeProgramInfoRouterDelegate {
    
    private weak var viewController: (ChallengeProgramInfoDisplayLogic & UIViewController)?
    
    func setup(with viewController: (ChallengeProgramInfoDisplayLogic & UIViewController)?) {
        self.viewController = viewController
    }
    
    func routeToBrowser(for challengeProgram: ChallengeProgram) {
        guard let urlString = challengeProgram.infoUrl, let url = URL(string: urlString) else { return }
        
        let targetViewController = SFSafariViewController(url: url)
        viewController?.present(targetViewController, animated: true, completion: nil)
    }
}
