import UIKit
import EasyPeasy

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

protocol ChallengesAvailableDisplayLogic: AnyObject, CardDisplayLogic {
    func display(viewModels: [ChallengeCardContentViewModel])
    func showLoadingIndicator()
    func removeLoadingIndicator()
    func cancelCardOpening()
}

final class ChallengesAvailableViewController: UIViewController {
    
    // MARK: Internal properties
    let cardLayoutGuide = UILayoutGuide()
    
    // MARK: Private properties
    private let interactor: ChallengesAvailableInteractorDelegate
    private let dealer: CardDealer
    private let primaryInstructionLabel = UILabel()
    private let secondaryInstructionLabel = UILabel()
    
    private let backSideCard: ChallengeBackSideCardView = ChallengeBackSideCardView()
    private let scalingAnimatableCard: ChallengeBackSideCardView = ChallengeBackSideCardView()
    
    private var selectedFrontSideCard: CardDealable?
    private var flipingFrontSideCard: CardDealable = SimpleCardView()
    private var flipingBackSideCard: CardDealable = SimpleCardView()
    private lazy var loadingIndicator = SemiTransparentLoadingIndicatorView()
    
    private var viewModels: [ChallengeCardContentViewModel] = []
    private var cards: [CardDealable] = []
    
    private var shouldHideCardsOnTransition = false
    
    // MARK: Lifecycle
    required init(interactor: ChallengesAvailableInteractorDelegate) {
        self.interactor = interactor
        dealer = CardDealer(backSideCard: backSideCard)
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        
        dealer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        interactor.handle(request: .initialize)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if shouldHideCardsOnTransition {
            backSideCard.isHidden = true
            selectedFrontSideCard?.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldHideCardsOnTransition {
            backSideCard.isHidden = false
            selectedFrontSideCard?.isHidden = false
            selectedFrontSideCard = nil
        }
        
        dealer.representCards()
    }
}

// MARK: - ChallengesAvailableDisplayLogic -

extension ChallengesAvailableViewController: ChallengesAvailableDisplayLogic {
    
    func display(viewModels: [ChallengeCardContentViewModel]) {
        self.viewModels = viewModels
        cards = viewModels.map { viewModel -> CardDealable in
            let card = ChallengeFrontSideCardView()
            card.contentView.update(for: viewModel)
            return card
        }
        
        cards.shuffled().forEach { card in
            view.addSubview(card)
            applyCardLayout(to: card)
        }
        
        dealer.present(cards: cards, on: view)
    }
    
    func showLoadingIndicator() {
        guard let card = selectedFrontSideCard else {
            return assertionFailure("There is no context to present the spinner in")
        }
        
        loadingIndicator.startAnimating()
        loadingIndicator.frame = card.bounds

        flipingBackSideCard.addSubview(loadingIndicator)
        flipingBackSideCard.frame = card.frame
        view.addSubview(flipingBackSideCard)
    }
    
    func removeLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
    
    func cancelCardOpening() {
        guard let card = selectedFrontSideCard else { return }
        
        selectedFrontSideCard?.isHidden = true
        
        flipingFrontSideCard.frame = card.frame
        view.addSubview(flipingFrontSideCard)
        
        flipingBackSideCard.frame = card.frame
        view.addSubview(flipingBackSideCard)
        
        dealer.closeCard(frontSide: flipingFrontSideCard, backSide: flipingBackSideCard)
    }
}

// MARK: - ConfigurableView -

extension ChallengesAvailableViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = StyleGuide.Colors.Primary.ghPurple
    }
    
    func configureSubviews() {
        view.addLayoutGuide(cardLayoutGuide)
        view.addSubview(backSideCard)
        
        let primaryInstructionText = NSMutableAttributedString(string: "primary_instruction_text_highlighted".localized(), attributes: [.foregroundColor: Constants.Colors.textHighlightedColor, .font: Constants.Fonts.primaryInstruction])
        primaryInstructionText.append(NSAttributedString(string: "primary_instruction_text_postfix".localized(), attributes: [.foregroundColor: Constants.Colors.textColor, .font: Constants.Fonts.primaryInstruction]))
        primaryInstructionLabel.attributedText = primaryInstructionText
        primaryInstructionLabel.numberOfLines = 0
        primaryInstructionLabel.textAlignment = .center
        view.addSubview(primaryInstructionLabel)
        
        let secondaryInstructionText = NSMutableAttributedString(string: "secondary_instruction_text_highlighted".localized(), attributes: [.foregroundColor: Constants.Colors.textHighlightedColor, .font: Constants.Fonts.secondaryInstruction])
        secondaryInstructionText.append(NSAttributedString(string: "secondary_instruction_text_postfix".localized(), attributes: [.foregroundColor: Constants.Colors.textColor, .font: Constants.Fonts.secondaryInstruction]))
        secondaryInstructionLabel.attributedText = secondaryInstructionText
        secondaryInstructionLabel.numberOfLines = 0
        secondaryInstructionLabel.alpha = 0
        secondaryInstructionLabel.textAlignment = .center
        view.addSubview(secondaryInstructionLabel)
    }
    
    func configureLayout() {
        setupCardLayout()
        applyCardLayout(to: backSideCard)
        
        primaryInstructionLabel.easy.layout(
            Leading(Constants.Margin.default),
            Trailing(Constants.Margin.default),
            CenterY()
        )
        
        secondaryInstructionLabel.easy.layout(
            Leading(Constants.Margin.default),
            Trailing(Constants.Margin.default),
            Bottom(Constants.Margin.default).to(view, .bottomMargin)
        )
    }
}

// MARK: - CardDealerDelegate -

extension ChallengesAvailableViewController: CardDealerDelegate {
    
    func cardDealder(_ dealer: CardDealer, didDraw card: CardDealable) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, animations: {
            self.primaryInstructionLabel.alpha = 0
            self.secondaryInstructionLabel.alpha = 1
        })
        
        if let index = cards.firstIndex(where: { $0 === card }), let viewModel = viewModels[safe: index] {
            backSideCard.contentView.update(for: viewModel)
            scalingAnimatableCard.contentView.update(for: viewModel)
        }
    }
    
    func cardDealder(_ dealer: CardDealer, willReturn card: CardDealable) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, animations: {
            self.secondaryInstructionLabel.alpha = 0
        })
    }
    
    func cardDealder(_ dealer: CardDealer, didReturn card: CardDealable) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, animations: {
            self.primaryInstructionLabel.alpha = 1
        })
    }
    
    func cardDealder(_ dealer: CardDealer, willOpen card: CardDealable) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, animations: {
            self.secondaryInstructionLabel.alpha = 0
        })
    }
    
    func cardDealder(_ dealer: CardDealer, didOpen card: CardDealable) {
        guard let index = cards.firstIndex(where: { $0 === card }), let viewModel = viewModels[safe: index] else { return }
        
        resetFlippingCards(with: viewModel)
        
        selectedFrontSideCard = card
        shouldHideCardsOnTransition = true
        
        interactor.handle(request: .startChallenge(index: index))
    }
    
    private func resetFlippingCards(with viewModel: ChallengeCardContentViewModel) {
        let flipingBackSideCard = ChallengeBackSideCardView()
        flipingBackSideCard.contentView.update(for: viewModel)
        self.flipingBackSideCard = flipingBackSideCard
        
        let flipingFrontSideCard = ChallengeFrontSideCardView()
        flipingFrontSideCard.contentView.update(for: viewModel)
        self.flipingFrontSideCard = flipingFrontSideCard
    }
    
    func cardDealder(_ dealer: CardDealer, didClose card: CardDealable) {
        flipingBackSideCard.removeFromSuperview()
        flipingFrontSideCard.removeFromSuperview()
        selectedFrontSideCard?.isHidden = false
        
        cardDealder(dealer, willReturn: flipingBackSideCard)
        dealer.representCards()
        cardDealder(dealer, didReturn: flipingBackSideCard)
        
        guard let selectedCard = selectedFrontSideCard,
            let index = cards.firstIndex(where: { $0 === selectedCard }),
            let viewModel = viewModels[safe: index] else {
                return
        }
        
        resetFlippingCards(with: viewModel)
    }
}

// MARK: - ChallengeSelectionChildViewController -

extension ChallengesAvailableViewController: ChallengeSelectionChildViewController { }

// MARK: - CardExpandAnimatableContext -

extension ChallengesAvailableViewController: CardExpandAnimatableContext {
    var expandable: UIView? { scalingAnimatableCard }
    var origin: CGRect? { cardLayoutGuide.layoutFrame }
}

// MARK: - CardCollapseAnimatableContext -

extension ChallengesAvailableViewController: CardCollapseAnimatableContext {
    var collapsible: UIView? { scalingAnimatableCard }
    var destination: CGRect { cardLayoutGuide.layoutFrame }
}

// MARK: - CardCloseCollapseAnimatableContext -

extension ChallengesAvailableViewController: CardCloseCollapseAnimatableContext {
    var backSide: CardDealable { flipingBackSideCard }
    var frontSide: CardDealable { flipingFrontSideCard }
    var position: CGRect { cardLayoutGuide.layoutFrame }
}

// MARK: - Private setup methods -

private extension ChallengesAvailableViewController { }
