import UIKit
import AVKit

protocol ChallengeRouterDelegate: AnyObject {
    func setup(with viewController: (ChallengeDisplayLogic & UIViewController)?)
    func routeToVideo(at url: URL)
}

final class ChallengeRouter: ChallengeRouterDelegate {
    
    private weak var viewController: (ChallengeDisplayLogic & UIViewController)?
    
    func setup(with viewController: (ChallengeDisplayLogic & UIViewController)?) {
        self.viewController = viewController
    }
    
    func routeToVideo(at url: URL) {
        let viewController = AVPlayerViewController()
        viewController.player = AVPlayer(url: url)
        self.viewController?.present(viewController, animated: true, completion: {
            viewController.player?.play()
        })
    }
}
