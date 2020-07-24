import UIKit
import EasyPeasy

protocol ChallengeProgramDisplayLogic: AnyObject {
    func display(viewModel: ChallengeProgramViewModel)
}

final class ChallengeProgramViewController: UIViewController {
    
    // MARK: Internal properties
    
    var backgroundColor: UIColor? {
        get {
            return view.backgroundColor
        }
        set {
            view.backgroundColor = newValue
        }
    }
    
    // MARK: Private properties
    
    private let interactor: ChallengeProgramInteractorDelegate
    private let largeCardView = ChallengeProgramLargeContentView()
    private let smallCardView = ChallengeProgramSmallContentView()
    private let contentLayoutGuide = UILayoutGuide()
    
    private var viewModel: ChallengeProgramViewModel?
    private var animatable: UIView = UIView()
    
    // MARK: Lifecycle
    
    required init(interactor: ChallengeProgramInteractorDelegate) {
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - ChallengeProgramDisplayLogic -
extension ChallengeProgramViewController: ChallengeProgramDisplayLogic {
    
    func display(viewModel: ChallengeProgramViewModel) {
        self.viewModel = viewModel
        largeCardView.contentView.update(for: viewModel.largeCardContent)
        smallCardView.contentView.update(for: viewModel.smallCardContent)
    }
}

// MARK: - ConfigurableView -

extension ChallengeProgramViewController: ConfigurableView {
    
    func configureSubviews() {
        view.addLayoutGuide(contentLayoutGuide)
        
        largeCardView.addTarget(self, action: #selector(onTapLargeCard), for: .touchUpInside)
        view.addSubview(largeCardView)
        
        smallCardView.addTarget(self, action: #selector(onTapSmallCard), for: .touchUpInside)
        view.addSubview(smallCardView)
    }
    
    func configureLayout() {
        largeCardView.easy.layout(
            Leading().to(contentLayoutGuide, .leading),
            Trailing().to(contentLayoutGuide, .trailing),
            Top().to(contentLayoutGuide, .top),
            Height().like(largeCardView, .width)
        )
        
        smallCardView.easy.layout(
            Leading().to(contentLayoutGuide, .leading),
            Trailing().to(contentLayoutGuide, .trailing),
            Top(35).to(largeCardView),
            Bottom().to(contentLayoutGuide, .bottom),
            Height(100)
        )
        
        let horizontalMargin: CGFloat = 24
        contentLayoutGuide.easy.layout(
            Leading(horizontalMargin),
            Trailing(horizontalMargin),
            Center()
        )
    }
}

// MARK: - Private methods -

private extension ChallengeProgramViewController {
    
    @objc
    func onTapLargeCard() {
        guard let viewModel = self.viewModel else { return }
        
        let animatable = ChallengeProgramLargeContentView()
        animatable.contentView.update(for: viewModel.largeCardContent)
        self.animatable = animatable
        
        interactor.handle(request: .onTap(cardSize: .large))
    }
    
    @objc
    func onTapSmallCard() {
        guard let viewModel = self.viewModel else { return }
        
        let animatable = ChallengeProgramSmallContentView()
        animatable.contentView.update(for: viewModel.smallCardContent)
        self.animatable = animatable
        
        interactor.handle(request: .onTap(cardSize: .small))
    }
}

// MARK: - CardExpandAnimatableContext -

extension ChallengeProgramViewController: CardExpandAnimatableContext {
    var expandable: UIView? { animatable }
    
    var origin: CGRect? {
        if animatable is ChallengeProgramSmallContentView {
            return smallCardView.frame
        } else {
            return largeCardView.frame
        }
    }
}

// MARK: - CardCollapseAnimatableContext -

extension ChallengeProgramViewController: CardCollapseAnimatableContext {
    var collapsible: UIView? { animatable }
    
    var destination: CGRect {
        if animatable is ChallengeProgramSmallContentView {
            return smallCardView.frame
        } else {
            return largeCardView.frame
        }
    }
}
