import UIKit
import EasyPeasy

private enum Constants {
    static let stackCardTranslationY: CGFloat = -10
}

protocol ChallengeFinishedDisplayLogic: AnyObject, CardDisplayLogic {
    func display(viewModel: ChallengeFinishedViewModel)
}

final class ChallengeFinishedViewController: UIViewController {
    
    // MARK: Internal properties
    let cardLayoutGuide = UILayoutGuide()
    
    // MARK: Private properties
    private let titleLayoutGuide = UILayoutGuide()
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    private let reflectionButton = GHButton()
    
    private let frontSideCard = ChallengeFrontSideCardView()
    private let flippedCards = [SimpleCardView(), SimpleCardView()]
    private let interactor: ChallengeFinishedInteractorDelegate
    
    private let confettiDecorator = ConfettiDecorator()
    
    private var didStackBackSideCard = false
    
    // MARK: Lifecycle
    required init(interactor: ChallengeFinishedInteractorDelegate) {
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
        
        guard !didStackBackSideCard else { return }
        animateCardOnDeck()
        didStackBackSideCard = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        confettiDecorator.detach()
    }
}

// MARK: - ChallengeFinishedDisplayLogic -

extension ChallengeFinishedViewController: ChallengeFinishedDisplayLogic {
    
    func display(viewModel: ChallengeFinishedViewModel) {
        reflectionButton.backgroundColor = viewModel.tintColor
        frontSideCard.contentView.update(for: viewModel.card)
        reflectionButton.isHidden = viewModel.shouldHideReflection
    }
}

// MARK: - ConfigurableView -

extension ChallengeFinishedViewController: ConfigurableView {
    
    func configureSubviews() {
        view.addLayoutGuide(cardLayoutGuide)
        view.addLayoutGuide(titleLayoutGuide)
        
        flippedCards.enumerated().forEach { offset, card in
            transform(card, translation: CGPoint(x: 0, y: CGFloat(offset) * Constants.stackCardTranslationY))
            card.layer.zPosition = frontSideCard.layer.zPosition - 1
            view.addSubview(card)
        }
        
        view.addSubview(frontSideCard)
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.contentMode = .top
        let title = NSMutableAttributedString(string: "challenge_finished_title_highlight".localized(), attributes: [.foregroundColor: StyleGuide.Colors.Primary.ghGreen, .font: StyleGuide.Fonts.ChallengeFinished.title])
        title.append(NSAttributedString(string: "challenge_finished_title_postfix".localized(), attributes: [.foregroundColor: StyleGuide.Colors.GreyTones.white, .font: StyleGuide.Fonts.ChallengeFinished.title]))
        titleLabel.attributedText = title
        view.addSubview(titleLabel)
        
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        let text = NSMutableAttributedString(string: "challenge_finished_text_highlight".localized(), attributes: [.foregroundColor: StyleGuide.Colors.Primary.ghGreen, .font: StyleGuide.Fonts.ChallengeFinished.text])
        text.append(NSAttributedString(string: "challenge_finished_text_postfix".localized(), attributes: [.foregroundColor: StyleGuide.Colors.GreyTones.white, .font: StyleGuide.Fonts.ChallengeFinished.text]))
        textLabel.attributedText = text
        view.addSubview(textLabel)
        
        reflectionButton.addTarget(self, action: #selector(onTapReflectionButton), for: .touchUpInside)
        reflectionButton.setTitle("challenge_reflection_button".localized(), for: .normal)
        view.addSubview(reflectionButton)
        
        hideOtherContent()
    }
    
    func configureLayout() {
        setupCardLayout()
        
        flippedCards.forEach { card in
            applyCardLayout(to: card)
        }
        
        applyCardLayout(to: frontSideCard)
        
        titleLayoutGuide.easy.layout(
            Leading(),
            Trailing(),
            Top(StyleGuide.Margins.default).to(view, .top),
            Height(*0.25).like(view, .height)
        )
        
        titleLabel.easy.layout(
            Leading(StyleGuide.Margins.default),
            Trailing(StyleGuide.Margins.default),
            Top(>=StyleGuide.Margins.default).to(titleLayoutGuide, .top),
            Bottom().to(titleLayoutGuide, .bottom)
        )
        
        textLabel.easy.layout(
            Leading(StyleGuide.Margins.default),
            Trailing(StyleGuide.Margins.default),
            Top(>=StyleGuide.Margins.default).to(view, .centerY)
        )
        
        let buttonMargin: CGFloat = 32
        reflectionButton.easy.layout(
            CenterX(),
            Top(buttonMargin).to(textLabel),
            Bottom(buttonMargin).to(view, .bottomMargin),
            Width(250)
        )
    }
}

// MARK: - ChallengeSelectionChildViewController -

extension ChallengeFinishedViewController: ChallengeSelectionChildViewController { }

// MARK: - MaskExpandAnimatableContext -

extension ChallengeFinishedViewController: MaskExpandAnimatableContext {
    var startingMask: UIView? {
        return reflectionButton
    }
}

// MARK: - MaskCollapseAnimatableContext -

extension ChallengeFinishedViewController: MaskCollapseAnimatableContext {
    var endingMask: UIView? {
        return reflectionButton
    }
}

// MARK: - Private methods -

private extension ChallengeFinishedViewController {
    
    func hideOtherContent() {
        setAlphaForOtherContent(0)
    }
    
    func showOtherContent() {
        setAlphaForOtherContent(1)
    }
    
    func setAlphaForOtherContent(_ alpha: CGFloat) {
        var otherContent: [UIView] = [titleLabel, textLabel, reflectionButton]
        otherContent.append(contentsOf: flippedCards)
        
        otherContent.forEach { $0.alpha = alpha }
    }
    
    func animateCardOnDeck() {
        let duration: TimeInterval = 1
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.transform(self.frontSideCard, translation: CGPoint(x: 0, y: -100))
                }

                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.showOtherContent()
                    self.transform(self.frontSideCard, translation: CGPoint(x: 0, y: CGFloat(self.flippedCards.count) * Constants.stackCardTranslationY))
                }
            })
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            
            self.confettiDecorator.attach(to: self.view)
        })
    }
    
    func transform(_ card: CardDealable, translation: CGPoint = .zero) {
        var transform = CATransform3DIdentity
        transform.m34 = 1 / -2000
        
        let translated = CATransform3DTranslate(transform, translation.x, translation.y, 0)
        
        let angle = CGFloat.radians(degrees: 75)
        let rotated = CATransform3DRotate(translated, angle, 1, 0, 0)
        
        card.layer.transform = rotated
    }
    
    @objc
    func onTapReflectionButton() {
        interactor.handle(request: .reflection)
    }
}
