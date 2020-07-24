import UIKit
import EasyPeasy

protocol ChallengeProgramInfoDisplayLogic: AnyObject {
    func display(viewModel: ChallengeProgramInfoViewModel)
}

// MARK: ViewController
final class ChallengeProgramInfoViewController: UIViewController {
    
    // MARK: Internal properties
    
    // MARK: Private properties
    private let interactor: ChallengeProgramInfoInteractorDelegate
    private let scrollView = UIScrollView()
    private let contentLayoutGuide = UILayoutGuide()
    private let infoView = ChallengeProgramInfoView()
    
    // MARK: Lifecycle
    required init(interactor: ChallengeProgramInfoInteractorDelegate) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        interactor.handle(request: .initialize)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        guard let navigationBar = view.subviews.first(where: { $0 is UINavigationBar }) else { return }
        scrollView.easy.layout(
            Top(navigationBar.frame.height).to(view, .topMargin)
        )
    }
}

// MARK: - Private methods -

private extension ChallengeProgramInfoViewController {
    
    @objc
    func onTap() {
        interactor.handle(request: .readMore)
    }
}

// MARK: - ChallengeProgramInfoDisplayLogic -

extension ChallengeProgramInfoViewController: ChallengeProgramInfoDisplayLogic {
    
    func display(viewModel: ChallengeProgramInfoViewModel) {
        infoView.update(for: viewModel)
    }
}

// MARK: - ConfigurableView -

extension ChallengeProgramInfoViewController: ConfigurableView {
    func configureViewProperties() {
        view.backgroundColor = .white
    }
    
    func configureSubviews() {
        view.addLayoutGuide(contentLayoutGuide)
        
        view.addSubview(scrollView)
        
        infoView.readMoreHandler = { [weak self] in
            self?.interactor.handle(request: .readMore)
        }
        scrollView.addSubview(infoView)
    }
    
    func configureLayout() {
        let horizontalMargin: CGFloat = StyleGuide.Margins.default
        let verticalMargin: CGFloat = 20
        
        contentLayoutGuide.easy.layout(
            Top(),
            Leading(horizontalMargin),
            Trailing(horizontalMargin)
        )
        
        scrollView.easy.layout(
            Top().to(view, .topMargin),
            Leading(),
            Trailing(),
            Bottom()
        )
        
        infoView.easy.layout(
            Leading(horizontalMargin),
            Trailing(horizontalMargin),
            Top(verticalMargin),
            Bottom(verticalMargin),
            Width().like(contentLayoutGuide)
        )
    }
}
