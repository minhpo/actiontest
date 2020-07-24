import UIKit
import EasyPeasy

protocol ChallengeActiveDisplayLogic: AnyObject, CardDisplayLogic {
    func display(viewModel: ChallengeCardContentViewModel)
}

final class ChallengeActiveViewController: UIViewController {
    
    // MARK: Internal properties
    let cardLayoutGuide = UILayoutGuide()
    
    // MARK: Private properties
    private let frontSideCard: ChallengeFrontSideCardView = ChallengeFrontSideCardView()
    private let backSideCard: ChallengeBackSideCardView = ChallengeBackSideCardView()
    private let openCardAnimator: InteractiveOpenCardAnimator = InteractiveOpenCardAnimator()
    
    private let interactor: ChallengeActiveInteractorDelegate
    
    private var viewModel: ChallengeCardContentViewModel?
    private var flipingBackSideCard: CardDealable = SimpleCardView()
    private var flipingFrontSideCard: CardDealable = SimpleCardView()
    
    private var shouldHideCardsOnTransition = false
    private var didOpenCard = false
    
    // MARK: Lifecycle
    required init(interactor: ChallengeActiveInteractorDelegate) {
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
        openCardAnimator.delegate = self
        openCardAnimator.setupBackSide(backSideCard)
        openCardAnimator.attach(to: frontSideCard)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if shouldHideCardsOnTransition {
            backSideCard.isHidden = true
            frontSideCard.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldHideCardsOnTransition {
            backSideCard.isHidden = false
            frontSideCard.isHidden = false
            shouldHideCardsOnTransition = false
        }
        
        if !didOpenCard {
            openCardAnimator.openCard()
        } else {
            interactor.handle(request: .close)
        }
    }
}

// MARK: - ChallengeActiveDisplayLogic -

extension ChallengeActiveViewController: ChallengeActiveDisplayLogic {
    
    func display(viewModel: ChallengeCardContentViewModel) {
        self.viewModel = viewModel
        backSideCard.contentView.update(for: viewModel)
        frontSideCard.contentView.update(for: viewModel)
    }
}

// MARK: - ConfigurableView -

extension ChallengeActiveViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = StyleGuide.Colors.Primary.ghPurple
    }
    
    func configureSubviews() {
        view.addLayoutGuide(cardLayoutGuide)
        view.addSubview(backSideCard)
        view.addSubview(frontSideCard)
    }
    
    func configureLayout() {
        setupCardLayout()
        applyCardLayout(to: frontSideCard)
        applyCardLayout(to: backSideCard)
    }
}

// MARK: - ChallengeSelectionChildViewController -

extension ChallengeActiveViewController: ChallengeSelectionChildViewController { }

// MARK: - CardExpandAnimatableContext -

extension ChallengeActiveViewController: CardExpandAnimatableContext {
    var expandable: UIView? { animatableCard() }
    var origin: CGRect? { cardLayoutGuide.layoutFrame }
}

// MARK: - CardCollapseAnimatableContext -

extension ChallengeActiveViewController: CardCollapseAnimatableContext {
    var collapsible: UIView? { animatableCard() }
    var destination: CGRect { cardLayoutGuide.layoutFrame }
}

// MARK: - CardCloseCollapseAnimatableContext -

extension ChallengeActiveViewController: CardCloseCollapseAnimatableContext {
    var backSide: CardDealable { flipingBackSideCard }
    var frontSide: CardDealable { flipingFrontSideCard }
    var position: CGRect { cardLayoutGuide.layoutFrame }
}

// MARK: - InteractiveOpenCardAnimatorDelegate -

extension ChallengeActiveViewController: InteractiveOpenCardAnimatorDelegate {
    
    func openCardAnimator(_ animator: InteractiveOpenCardAnimator, didOpen card: CardDealable) {
        guard let viewModel = self.viewModel else { return }
        
        let flipingBackSideCard = ChallengeBackSideCardView()
        flipingBackSideCard.contentView.update(for: viewModel)
        self.flipingBackSideCard = flipingBackSideCard
        
        let flipingFrontSideCard = ChallengeFrontSideCardView()
        flipingFrontSideCard.contentView.update(for: viewModel)
        self.flipingFrontSideCard = flipingFrontSideCard
        
        shouldHideCardsOnTransition = true
        didOpenCard = true
        
        interactor.handle(request: .viewDetails)
    }
}

// MARK: - Private methods -

private extension ChallengeActiveViewController {
    
    func animatableCard() -> ChallengeBackSideCardView {
        let card = ChallengeBackSideCardView()
        if let viewModel = self.viewModel {
            card.contentView.update(for: viewModel)
        }
        return card
    }
}
