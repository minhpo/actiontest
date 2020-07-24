import UIKit
import EasyPeasy

protocol QuizDisplayLogic: AnyObject, CardDisplayLogic { }

final class QuizViewController: UIViewController {
    
    // MARK: Internal properties
    let cardLayoutGuide = UILayoutGuide()
    
    // MARK: Private properties
    private let interactor: QuizInteractorDelegate
    private let stacker: CardStacker = CardStacker()
    
    // TODO: Should replace with real quizcards
    private let cards: [CardDealable & CardStackable] = {
        let viewModel = QuizViewModel(
            questionsContext: QuizViewModel.QuizQuestionsContext(
                content: [
                    .title(viewModel: QuizViewModel.QuizTitle(title: "titel")),
                    .question(viewModel: QuizViewModel.QuizQuestion(question: "Dit is een vraag die wordt gesteld aan de gebruiker?")),
                    .answers(viewModel: QuizViewModel.QuizAnswers(content: [
                        .solid(text: "antwoord 1", color: StyleGuide.Colors.Primary.ghPurple),
                        .solid(text: "antwoord 1", color: StyleGuide.Colors.Tertiary.badRed),
                        .solid(text: "antwoord 1", color: StyleGuide.Colors.Tertiary.goodGreen),
                        .border(text: "antwoord 1", color: StyleGuide.Colors.Primary.ghPurple)
                    ]))
                ],
                delaySubmit: false),
            feedbackContext: QuizViewModel.QuizFeedbackContext(
                content: [
                    .title(viewModel: QuizViewModel.QuizTitle(title: "titel")),
                    .feedback(viewModel: QuizViewModel.QuizFeedback(feedback: "Helaas! Je had het niet goed")),
                    .explanation(viewModel: QuizViewModel.QuizExplanation(explanation: "Het juiste antwoord is: niet waar. Deze taktiek komt voort uit één van de zes beïnvloedingsprincipes van Robert Cialdini: Autoriteit.")),
                    .explanation(viewModel: QuizViewModel.QuizExplanation(explanation: "Door specifiek benoemen van de ervaring en expertise van bijvoorbeeld één van je collega’s zouden verkoopcijfers met 15% stijgen en met het aantal afspraken met 20%.")),
                    .moreInfo
            ])
        )
        
        let prefilledQuizCard = QuizCardView()
        prefilledQuizCard.contentView.update(for: viewModel.questionsContext)
        
        let prefilledQuizFeedbackCard = QuizFeedbackCardView()
        prefilledQuizFeedbackCard.contentView.update(for: viewModel.feedbackContext)
        
        return [prefilledQuizFeedbackCard, prefilledQuizCard, QuizCardView(), QuizCardView()]
    }()
    private var didPresentCards = false
    
    // MARK: Lifecycle
    required init(interactor: QuizInteractorDelegate) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        stacker.isUserInteractionEnabled = false
        interactor.handle(request: .initialize)
    }
    
    //TODO: Remove temporary solution to display temporary content
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !didPresentCards {
            stacker.present(cards: cards)
            didPresentCards = true
        }
    }
}

// MARK: - QuizDisplayLogic -

extension QuizViewController: QuizDisplayLogic { }

// MARK: - ConfigurableView -

extension QuizViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = StyleGuide.Colors.Secondary.lightBlue
    }
    
    func configureSubviews() {
        view.addLayoutGuide(cardLayoutGuide)
        
        cards.forEach { view.insertSubview($0, at: 0) }
    }
    
    func configureLayout() {
        setupCardLayout(margin: StyleGuide.Margins.default)
        
        cards.forEach(applyCardLayout)
    }
}

// MARK: - Private methods -

private extension QuizViewController { }
