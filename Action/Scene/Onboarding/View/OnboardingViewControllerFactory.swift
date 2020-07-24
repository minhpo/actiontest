import Foundation

enum OnboardingViewControllerFactory {
    
    static func make() -> OnboardingViewController {
        let interactor = OnboardingInteractor()
        let presenter = OnboardingPresenter()
        let router = OnboardingRouter()
        let viewController = OnboardingViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router)
        presenter.setup(with: viewController)
        router.setup(with: viewController)
        
        return viewController
    }
}
