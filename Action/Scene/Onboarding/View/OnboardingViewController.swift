import UIKit
import EasyPeasy

private enum Constants {
    static let animationDuration: TimeInterval = 0.2
}

protocol OnboardingDisplayLogic: AnyObject, CardDisplayLogic {
    func displayContent(viewModel: OnboardingViewModel)
}

final class OnboardingViewController: UIViewController {
    
    // MARK: Internal properties
    let cardLayoutGuide = UILayoutGuide()
    
    // MARK: Private properties
    private let interactor: OnboardingInteractorDelegate
    
    private let drawCardImageView = UIImageView(image: UIImage(named: "icon.swipe.down"))
    private let activateCardImageView = UIImageView(image: UIImage(named: "icon.swipe.open"))
    private let discardCardImageView = UIImageView(image: UIImage(named: "icon.swipe.away"))
    private let textLabel = UILabel()
    
    private var dealer: CardDealer?
    private var stacker: CardStacker?
    private var didStartInitialize = false
    private var instructionCard = OnboardingInstructionCardView()
    private var instructionCards: [OnboardingInstructionCardView] = []
    
    // MARK: Lifecycle
    required init(interactor: OnboardingInteractorDelegate) {
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
        
        if !didStartInitialize {
            didStartInitialize = true
            interactor.handle(request: .initialize)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - OnboardingDisplayLogic -

extension OnboardingViewController: OnboardingDisplayLogic {
    
    func displayContent(viewModel: OnboardingViewModel) {
        let dragableCards: [CardDealable] = viewModel.dragableCards.map { viewModel -> CardDealable in
            let card = SimpleCardView()
            card.contentView.update(for: viewModel)
            
            return card
        }
        
        dragableCards.shuffled().forEach { card in
            view.insertSubview(card, aboveSubview: instructionCard)
            applyCardLayout(to: card)
        }
        
        instructionCards = viewModel.instructionCards.map { instructionCardViewModel -> OnboardingInstructionCardView in
            let card = OnboardingInstructionCardView()
            card.contentView.update(for: instructionCardViewModel)
            view.insertSubview(card, aboveSubview: instructionCard)
            applyCardLayout(to: card)
            card.alpha = 0
            return card
        }
        
        if let instructionCardViewModel = viewModel.instructionCards.first {
            instructionCard.contentView.update(for: instructionCardViewModel)
        }
        
        dealer = CardDealer(backSideCard: instructionCard)
        dealer?.delegate = self
        dealer?.present(cards: dragableCards, on: view)
        
        updateScreen(for: .drawCard)
    }
}

// MARK: - Private methods -

private extension OnboardingViewController {
    
    enum Step: Int {
        case drawCard
        case activateCard
        case discardFirstCard
        case discardRemainingCards
    }
    
    func updateScreen(for step: Step) {
        setVisualCue(for: step)
        
        // Leave text as is for final step
        if case .discardRemainingCards = step { return }
        setText(for: step)
    }
    
    func setVisualCue(for step: Step) {
        let imageViews = [drawCardImageView, activateCardImageView, discardCardImageView]
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: Constants.animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            imageViews.enumerated().forEach { offset, imageView in
                imageView.alpha = offset == step.rawValue ? 1 : 0
            }
        }, completion: nil)
    }
    
    func setText(for step: Step) {
        let highlight = "step_\(step.rawValue)_text_highlight".localized()
        let postfix = "step_\(step.rawValue)_text_postfix".localized()
        let font = StyleGuide.Fonts.Onboarding.text
        
        let text = NSMutableAttributedString(string: highlight, attributes: [.foregroundColor: StyleGuide.Colors.Primary.ghGreen, .font: font])
        text.append(NSAttributedString(string: postfix, attributes: [.foregroundColor: StyleGuide.Colors.GreyTones.white, .font: font]))
        
        UIView.transition(with: textLabel, duration: Constants.animationDuration, options: .transitionCrossDissolve, animations: { [unowned self] in
            self.textLabel.attributedText = text
        }, completion: nil)
    }
}

// MARK: - ConfigurableView -

extension OnboardingViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = StyleGuide.Colors.Secondary.purple
    }
    
    func configureSubviews() {
        view.addLayoutGuide(cardLayoutGuide)
        
        view.addSubview(instructionCard)
        
        drawCardImageView.alpha = 0
        drawCardImageView.layer.zPosition = 1000
        view.addSubview(drawCardImageView)
        
        activateCardImageView.alpha = 0
        activateCardImageView.layer.zPosition = 1000
        view.addSubview(activateCardImageView)
        
        discardCardImageView.alpha = 0
        discardCardImageView.layer.zPosition = 1000
        view.addSubview(discardCardImageView)
        
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        view.addSubview(textLabel)
    }
    
    func configureLayout() {
        setupCardLayout(margin: 48)
        
        applyCardLayout(to: instructionCard)
        
        drawCardImageView.easy.layout(
            CenterX(),
            Bottom().to(view, .centerY)
        )
        
        activateCardImageView.easy.layout(
            Trailing().to(cardLayoutGuide, .trailing),
            Top().to(view, .centerY)
        )
        
        discardCardImageView.easy.layout(
            Trailing(),
            CenterY().to(cardLayoutGuide, .bottom)
        )
        
        let horizontalMargin = StyleGuide.Margins.default
        textLabel.easy.layout(
            Leading(horizontalMargin),
            Trailing(horizontalMargin),
            Bottom(32).to(view, .bottomMargin)
        )
    }
}

// MARK: - CardDealerDelegate -

extension OnboardingViewController: CardDealerDelegate {
    
    func cardDealder(_ dealer: CardDealer, didDraw card: CardDealable) {
        updateScreen(for: .activateCard)
    }
    
    func cardDealder(_ dealer: CardDealer, didReturn card: CardDealable) {
        updateScreen(for: .drawCard)
    }
    
    func cardDealder(_ dealer: CardDealer, didOpen card: CardDealable) {
        updateScreen(for: .discardFirstCard)
        
        card.alpha = 0
        instructionCard.alpha = 0
        
        instructionCards.forEach { $0.alpha = 1 }
        stacker = CardStacker()
        stacker?.delegate = self
        stacker?.present(cards: instructionCards)
    }
}

// MARK: - CardStackerDelegate -

extension OnboardingViewController: CardStackerDelegate {
    
    func cardStacker(_ stacker: CardStacker, didPop card: CardStackable) {
        updateScreen(for: .discardRemainingCards)
        
        guard let index = instructionCards.firstIndex(where: { $0 === card }) else { return }
        let removedCard = instructionCards.remove(at: index)
        removedCard.removeFromSuperview()
        
        if instructionCards.isEmpty {
            interactor.handle(request: .close)
        }
    }
}
