import UIKit

private enum Constants {
    
    enum Colors {
        enum Challenge {
            static let background: UIColor = StyleGuide.Colors.Primary.ghPurple
            static let textColor: UIColor = StyleGuide.Colors.GreyTones.white
            static let textHighlightedColor: UIColor = StyleGuide.Colors.Primary.ghGreen
        }
        enum Quiz {
            static let background: UIColor = StyleGuide.Colors.Secondary.lightBlue
            static let textColor: UIColor = StyleGuide.Colors.GreyTones.white
            static let textHighlightedColor: UIColor = StyleGuide.Colors.Secondary.purple
        }
    }
    
    enum Fonts {
        enum Large {
            static let text: UIFont = StyleGuide.Fonts.ChallengeProgramLargeCard.text
        }
        enum Small {
            static let text: UIFont = StyleGuide.Fonts.ChallengeProgramSmallCard.text
        }
    }
    
    enum Icons {
        static let challenge: UIImage = UIImage(named: "icon.challenge") ?? UIImage()
        static let quiz: UIImage = UIImage(named: "icon.quiz") ?? UIImage()
    }
}

protocol ChallengeProgramPresenterDelegate: AnyObject {
    func setup(with displayLogic: ChallengeProgramDisplayLogic?)
    func present(response: ChallengeProgramResponse)
}

final class ChallengeProgramPresenter: ChallengeProgramPresenterDelegate {
    
    // MARK: private properties
    private weak var displayLogic: ChallengeProgramDisplayLogic?
}

// MARK: - ChallengeProgramPresenterDelegate -

extension ChallengeProgramPresenter {
    
    func setup(with displayLogic: ChallengeProgramDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func present(response: ChallengeProgramResponse) {
        guard case .content(let mostImportantChallengeStatus) = response else { return }
        
        var viewModel: ChallengeProgramViewModel?
        switch mostImportantChallengeStatus {
        case .closed:
            viewModel = .init(largeCardContent: viewModelForQuizCard, smallCardContent: viewModelForSmallChallengeCard)
        default:
            guard let context = largeChallengeCardTextContexts[mostImportantChallengeStatus] else { return }
            viewModel = .init(largeCardContent: viewModelForLargeChallengeCard(textPrefixKey: context.textPrefixKey, textHighlightKey: context.textHighlightKey, textPostfixKey: context.textPostfixKey), smallCardContent: viewModelForQuizCard)
        }
        
        guard let unwrappedViewModel = viewModel else { return }
        displayLogic?.display(viewModel: unwrappedViewModel)
    }
}

// MARK: - Private methods -

private extension ChallengeProgramPresenter {
    
    typealias LargeChallengeCardTextContext = (textPrefixKey: String, textHighlightKey: String, textPostfixKey: String)
    var largeChallengeCardTextContexts: [Challenge.Status: LargeChallengeCardTextContext] {
        [
            .open: LargeChallengeCardTextContext(textPrefixKey: "challenge_start_text_prefix", textHighlightKey: "challenge_start_text_highlight", textPostfixKey: "challenge_start_text_postfix"),
            .active: LargeChallengeCardTextContext(textPrefixKey: "challenge_active_text_prefix", textHighlightKey: "challenge_active_text_highlight", textPostfixKey: "challenge_active_text_postfix"),
            .pendingReview: LargeChallengeCardTextContext(textPrefixKey: "challenge_review_text_prefix", textHighlightKey: "challenge_review_text_highlight", textPostfixKey: "challenge_review_text_postfix")
        ]
    }
    
    func viewModelForLargeChallengeCard(textPrefixKey: String, textHighlightKey: String, textPostfixKey: String) -> ChallengeProgramViewModel.CardContentViewModel {
        let text = NSMutableAttributedString(string: textPrefixKey.localized(), attributes: [.foregroundColor: Constants.Colors.Challenge.textColor, .font: Constants.Fonts.Large.text])
        text.append(NSAttributedString(string: textHighlightKey.localized(), attributes: [.foregroundColor: Constants.Colors.Challenge.textHighlightedColor, .font: Constants.Fonts.Large.text]))
        text.append(NSAttributedString(string: textPostfixKey.localized(), attributes: [.foregroundColor: Constants.Colors.Challenge.textColor, .font: Constants.Fonts.Large.text]))
        return .init(backgroundColor: Constants.Colors.Challenge.background, icon: Constants.Icons.challenge, text: text)
    }
    
    var viewModelForSmallChallengeCard: ChallengeProgramViewModel.CardContentViewModel {
        let text = NSMutableAttributedString(string: "challenge_finished_text_prefix".localized(), attributes: [.foregroundColor: Constants.Colors.Challenge.textColor, .font: Constants.Fonts.Small.text])
        text.append(NSAttributedString(string: "challenge_finished_text_highlight_postfix".localized(), attributes: [.foregroundColor: Constants.Colors.Challenge.textHighlightedColor, .font: Constants.Fonts.Small.text]))
        return .init(backgroundColor: Constants.Colors.Challenge.background, icon: Constants.Icons.challenge, text: text)
    }
    
    var viewModelForQuizCard: ChallengeProgramViewModel.CardContentViewModel {
        let text = NSMutableAttributedString(string: "quiz_text_prefix".localized(), attributes: [.foregroundColor: Constants.Colors.Quiz.textColor, .font: Constants.Fonts.Small.text])
        text.append(NSAttributedString(string: "quiz_text_highlight".localized(), attributes: [.foregroundColor: Constants.Colors.Quiz.textHighlightedColor, .font: Constants.Fonts.Small.text]))
        return .init(backgroundColor: Constants.Colors.Quiz.background, icon: Constants.Icons.quiz, text: text)
    }
}
