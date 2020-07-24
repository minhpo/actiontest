import UIKit
import EasyPeasy

private enum Constants {
    
    enum Images {
        static let settingsNavigation: UIImage = UIImage(named: "icon.navigation.settings") ?? UIImage()
    }
    
    enum Size {
        static let settingsNavigationHeight: CGFloat = Constants.Images.settingsNavigation.size.height
    }
    
    enum Margin {
        // Align with top of settings button as per request of design
        static let top: CGFloat = (Constants.Size.settingsNavigationHeight / 2) - StyleGuide.DefaultSizes.navigationBarHeight
    }
}

protocol ChallengeProgramsDisplayLogic: AnyObject {
    func display(viewModels: [ChallengeProgramsViewModel])
}

final class ChallengeProgramsViewController: UIViewController {
    
    // MARK: Internal properties
    
    // MARK: Private properties
    private enum SelectionType {
        case cardDeck(viewModel: ChallengeProgramsViewModel)
        case moreInfo(viewModel: ChallengeProgramsViewModel)
    }
    
    private typealias CardDeckContext = (cardDeck: CardDeckView, moreInfoButton: UIButton)
    private let interactor: ChallengeProgramsInteractorDelegate
    
    private let logoImageView = UIImageView(image: UIImage(named: "icon.navigation.logo"))
    private let scrollView = ScrollView()
    private let pageControl = UIPageControl()
    
    private var didStartInitialize = false
    private var additionalInfoButtons: [UIButton] = []
    private var cardDeckContexts: [CardDeckContext] = []
    private var highLightCoordinators: [ScrollViewPaginationHighlightCoordinator] = []
    private var viewModels: [ChallengeProgramsViewModel] = []
    private var selectionType: SelectionType?
    
    private var shouldHideCardsOnTransition = false
    
    // MARK: Lifecycle
    required init(interactor: ChallengeProgramsInteractorDelegate) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let horizontalInset = scrollView.frame.minX
        let verticalInset = scrollView.frame.minY
        scrollView.hitAreaInsets = UIEdgeInsets(top: -verticalInset, left: -horizontalInset, bottom: -verticalInset, right: -horizontalInset)
        
        if !didStartInitialize {
            didStartInitialize = true
            interactor.handle(request: .initialize)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if shouldHideCardsOnTransition {
            let cardDeck = cardDeckContexts.first(where: { !$0.cardDeck.isSpread })?.cardDeck
            cardDeck?.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectionType = nil
        
        if shouldHideCardsOnTransition {
            let cardDeck = cardDeckContexts.first(where: { !$0.cardDeck.isSpread })?.cardDeck
            cardDeck?.isHidden = false
            cardDeck?.spread()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - ChallengeProgramsDisplayLogic -

extension ChallengeProgramsViewController: ChallengeProgramsDisplayLogic {
    
    func display(viewModels: [ChallengeProgramsViewModel]) {
        highLightCoordinators.removeAll()
        cardDeckContexts.forEach { context in
            context.cardDeck.removeFromSuperview()
            context.moreInfoButton.removeFromSuperview()
        }
        cardDeckContexts.removeAll()
        
        self.viewModels = viewModels
        viewModels.enumerated().forEach { offset, viewModel in
            var cards: [Card] = []
            for _ in 0..<3 {
                let card = challengeProgramCardView(for: viewModel)
                cards.append(card)
            }
            
            let cardDeck = CardDeckView(cards: cards)
            cardDeck.spread()
            cardDeck.isUserInteractionEnabled = (offset == 0)
            cardDeck.addTarget(self, action: #selector(onTapCardDeck), for: .touchUpInside)
            
            let moreInfoButton = UIButton()
            moreInfoButton.setImage(UIImage(named: "icon.moreInfo"), for: .normal)
            moreInfoButton.contentMode = .center
            moreInfoButton.addTarget(self, action: #selector(onTapMoreInfo), for: .touchUpInside)
            
            cardDeckContexts.append(CardDeckContext(cardDeck: cardDeck, moreInfoButton: moreInfoButton))
        }
        
        let translation = view.frame.width / 2
        let tolerance = translation / 10
        cardDeckContexts.enumerated().forEach { offset, context in
            let cardDeck = context.cardDeck
            let moreInfoButton = context.moreInfoButton
            
            scrollView.addSubview(cardDeck)
            let cardDeckOrigin = CGPoint(x: CGFloat(offset) * scrollView.frame.width, y: 0)
            let cardDeckSize = scrollView.frame.size
            cardDeck.frame = CGRect(origin: cardDeckOrigin, size: cardDeckSize)
            scrollView.contentSize = CGSize(width: cardDeck.frame.maxX, height: cardDeck.frame.maxY)
            
            scrollView.addSubview(moreInfoButton)
            // Button frame falls off scrollview frame intentionally. Scrollview hit area is extended, so button can still react to tap.
            let buttonOrigin = CGPoint(x: cardDeck.frame.midX - 22, y: cardDeck.frame.maxY + 24)
            
            let buttonDimension: CGFloat = StyleGuide.DefaultSizes.buttonHeight
            let buttonSize = CGSize(width: buttonDimension, height: buttonDimension)
            moreInfoButton.frame = CGRect(origin: buttonOrigin, size: buttonSize)
            
            let highLightAnimator = ScrollViewPaginationHighlightCoordinator(scrollView: scrollView, pageView: cardDeck, pageIndex: CGFloat(offset), translation: translation, tolerance: tolerance)
            highLightCoordinators.append(highLightAnimator)
        }
        
        pageControl.numberOfPages = cardDeckContexts.count
    }
}

// MARK: - Private methods -

private extension ChallengeProgramsViewController {
    
    @objc
    func onTapCardDeck(cardDeck: CardDeckView) {
        guard let index = cardDeckContexts.firstIndex(where: { $0.cardDeck == cardDeck }), let viewModel = viewModels[safe: index] else { return }
        selectionType = .cardDeck(viewModel: viewModel)
        interactor.handle(request: .openChallengeProgram(index: index))
    }
    
    @objc
    func onTapMoreInfo(button: UIButton) {
        guard let index = cardDeckContexts.firstIndex(where: { $0.moreInfoButton == button }), let viewModel = viewModels[safe: index] else { return }
        selectionType = .moreInfo(viewModel: viewModel)
        
        let cardDeck = cardDeckContexts[index].cardDeck
        if cardDeck.isSpread {
            cardDeck.close { [weak self] in
                self?.shouldHideCardsOnTransition = true
                self?.interactor.handle(request: .openChallengeProgramInfo(index: index))
            }
        }
    }
    
    func challengeProgramCardView(for viewModel: ChallengeProgramsViewModel) -> ChallengeProgramCardView {
        let challengeProgramCardView = ChallengeProgramCardView()
        challengeProgramCardView.contentView.update(for: viewModel)
        return challengeProgramCardView
    }
    
    func challengeProgramInfoCardView(for viewModel: ChallengeProgramsViewModel) -> ChallengeProgramInfoCardView {
        let challengeProgramInfoCardView = ChallengeProgramInfoCardView()
        challengeProgramInfoCardView.contentView.topInset = view.safeAreaInsets.top
        challengeProgramInfoCardView.contentView.update(for: viewModel)
        return challengeProgramInfoCardView
    }
}

// MARK: - ConfigurableView -

extension ChallengeProgramsViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = StyleGuide.Colors.Secondary.purple
    }
    
    func configureSubviews() {
        view.addSubview(logoImageView)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = false
        view.addSubview(scrollView)
        
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        pageControl.currentPageIndicatorTintColor = StyleGuide.Colors.Primary.ghGreen
        view.addSubview(pageControl)
    }
    
    func configureLayout() {
        logoImageView.easy.layout(
            CenterX(),
            Top(Constants.Margin.top).to(view, .topMargin)
        )
        
        scrollView.easy.layout(
            CenterX(),
            CenterY(),
            Width(*0.67).like(view),
            Height(*1.5).like(scrollView, .width)
        )
        
        pageControl.easy.layout(
            CenterX(),
            Top(80).to(scrollView)
        )
    }
}

// MARK: - UIScrollViewDelegate -

extension ChallengeProgramsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.currentPage)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cardDeckIndex = Int(scrollView.currentPage)
        cardDeckContexts.enumerated().forEach { $1.cardDeck.isUserInteractionEnabled = ($0 == cardDeckIndex) }
    }
}

// MARK: - CardExpandAnimatableContext -

extension ChallengeProgramsViewController: CardExpandAnimatableContext {
    var expandable: UIView? {
        switch selectionType {
        case .cardDeck(let viewModel):
            return challengeProgramCardView(for: viewModel)
        case .moreInfo(let viewModel):
            return challengeProgramInfoCardView(for: viewModel)
        case .none:
            return nil
        }
    }
    var origin: CGRect? { scrollView.frame }
}

// MARK: - CardCollapseAnimatableContext -

extension ChallengeProgramsViewController: CardCollapseAnimatableContext {
    var collapsible: UIView? {
        switch selectionType {
        case .cardDeck(let viewModel):
            return challengeProgramCardView(for: viewModel)
        case .moreInfo(let viewModel):
            return challengeProgramInfoCardView(for: viewModel)
        case .none:
            return nil
        }
    }
    var destination: CGRect { scrollView.frame }
}

// MARK: - CardOpenExpandAnimatableContext, CardCloseCollapseAnimatableContext -

extension ChallengeProgramsViewController: CardOpenExpandAnimatableContext, CardCloseCollapseAnimatableContext {
    var backSide: CardDealable {
        guard case .moreInfo(let viewModel) = selectionType else { return SimpleCardView() }
        return challengeProgramCardView(for: viewModel)
    }
    var frontSide: CardDealable {
        guard case .moreInfo(let viewModel) = selectionType else { return SimpleCardView() }
        return challengeProgramInfoCardView(for: viewModel)
    }
    var position: CGRect { scrollView.frame }
}
