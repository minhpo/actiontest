import UIKit
import EasyPeasy

// MARK: Constants
private enum Constants {
    
    enum Margin {
        static let `default`: CGFloat = 32
    }
    
    enum Colors {
        static let textColor: UIColor = StyleGuide.Colors.GreyTones.white
        static let textHighlightedColor: UIColor = StyleGuide.Colors.Primary.ghGreen
    }
    
    enum Fonts {
        static let primaryInstruction: UIFont = StyleGuide.Fonts.ChallengeSelection.primaryInstruction
        static let secondaryInstruction: UIFont = StyleGuide.Fonts.ChallengeSelection.secondaryInstruction
    }
}

protocol ChallengeSelectionDisplayLogic: AnyObject {
    func set(presentable viewController: ChallengeSelectionChildViewController)
    func disableBackNavigation()
}

// MARK: ViewController
final class ChallengeSelectionViewController: UIViewController {
    
    // MARK: Internal properties
    
    // MARK: Private properties
    private let interactor: ChallengeSelectionInteractorDelegate
    private let navigationBar = UINavigationBar()
    
    // MARK: Lifecycle
    required init(interactor: ChallengeSelectionInteractorDelegate) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if navigationBar.isUserInteractionEnabled {
            navigationBar.isHidden = false
            navigationBar.pushItem(navigationItem, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: ChallengeSelectionDisplayLogic
extension ChallengeSelectionViewController: ChallengeSelectionDisplayLogic {
    
    func set(presentable viewController: ChallengeSelectionChildViewController) {
        currentPresentable?.view.removeFromSuperview()
        currentPresentable?.removeFromParent()
        
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.easy.layout(
            Edges()
        )
        
        viewController.view.insertSubview(navigationBar, at: 0)
        configureNavigationBarLayout()
    }
    
    func disableBackNavigation() {
        navigationBar.isUserInteractionEnabled = false
    }
}

// MARK: ConfigurableView
extension ChallengeSelectionViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = StyleGuide.Colors.Primary.ghPurple
    }
    
    func configureSubviews() {
        navigationBar.isHidden = true
        view.addSubview(navigationBar)
    }
    
    func configureLayout() {
        configureNavigationBarLayout()
    }
}

// MARK: CardExpandAnimatableContext
extension ChallengeSelectionViewController: CardExpandAnimatableContext {
    var expandable: UIView? { (currentPresentable as? CardExpandAnimatableContext)?.expandable }
    var origin: CGRect? { (currentPresentable as? CardExpandAnimatableContext)?.origin }
}

// MARK: CardCollapseAnimatableContext
extension ChallengeSelectionViewController: CardCollapseAnimatableContext {
    var collapsible: UIView? { (currentPresentable as? CardCollapseAnimatableContext)?.collapsible }
    var destination: CGRect { (currentPresentable as? CardCollapseAnimatableContext)?.destination ?? view.bounds }
}

// MARK: MaskExpandAnimatableContext
extension ChallengeSelectionViewController: MaskExpandAnimatableContext {
    var startingMask: UIView? { (currentPresentable as? MaskExpandAnimatableContext)?.startingMask }
}

// MARK: MaskCollapseAnimatableContext
extension ChallengeSelectionViewController: MaskCollapseAnimatableContext {
    var endingMask: UIView? { (currentPresentable as? MaskCollapseAnimatableContext)?.endingMask }
}

// MARK: CardCloseCollapseAnimatableContext
extension ChallengeSelectionViewController: CardCloseCollapseAnimatableContext {
    var backSide: CardDealable {
        guard let collapseAnimatableContext = currentPresentable as? CardCloseCollapseAnimatableContext else { return SimpleCardView() }
        return collapseAnimatableContext.backSide
    }
    var frontSide: CardDealable {
        guard let collapseAnimatableContext = currentPresentable as? CardCloseCollapseAnimatableContext else { return SimpleCardView() }
        return collapseAnimatableContext.frontSide
    }
    var position: CGRect {
        guard let collapseAnimatableContext = currentPresentable as? CardCloseCollapseAnimatableContext else { return .zero }
        return collapseAnimatableContext.position
    }
}

// MARK: Private methods
private extension ChallengeSelectionViewController {
    var currentPresentable: ChallengeSelectionChildViewController? { children.compactMap({ $0 as? ChallengeSelectionChildViewController }).first }
    
    func configureNavigationBarLayout() {
        guard let navigationBarContainer = navigationBar.superview else { return }
        
        navigationBar.easy.layout(
            Leading(),
            Trailing(),
            Top().to(navigationBarContainer, .topMargin)
        )
    }
}
