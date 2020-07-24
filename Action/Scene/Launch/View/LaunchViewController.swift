import UIKit

protocol LaunchDisplayLogic: AnyObject { }

// MARK: ViewController
final class LaunchViewController: UIViewController {
    
    // MARK: Internal properties
    
    // MARK: Private properties
    private let interactor: LaunchInteractorDelegate
    
    // MARK: Lifecycle
    required init(interactor: LaunchInteractorDelegate) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.handle(request: .initialize)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - LaunchDisplayLogic -

extension LaunchViewController: LaunchDisplayLogic { }

// MARK: - Private methods -

private extension LaunchViewController { }

// MARK: - ConfigurableView -

extension LaunchViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = StyleGuide.Colors.Secondary.purple
    }
}
