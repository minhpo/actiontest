import UIKit

private enum Constants {
    
    enum Colors {
        static let titleColor: UIColor = StyleGuide.Colors.GreyTones.black
        static let titleHighlightedColor: UIColor = StyleGuide.Colors.Secondary.purple
    }
    
    enum Fonts {
        static let title: UIFont = StyleGuide.Fonts.ChallengeProgramLargeCard.text
    }
}

protocol OnboardingPresenterDelegate: AnyObject {
    func setup(with displayLogic: OnboardingDisplayLogic?)
    func presentContent()
}

final class OnboardingPresenter: OnboardingPresenterDelegate {
    
    // MARK: private properties
    private weak var displayLogic: OnboardingDisplayLogic?
}

// MARK: - Setup -

extension OnboardingPresenter {
    
    func setup(with displayLogic: OnboardingDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    
    func presentContent() {
        // TODO: replace with final content
        let dragableCardsViewModels: [SimpleCardContentViewPresentable] = [
            OnboardingViewModel.DragableCard(color: StyleGuide.Colors.Secondary.lightBlue),
            OnboardingViewModel.DragableCard(color: StyleGuide.Colors.Secondary.yellow),
            OnboardingViewModel.DragableCard(color: StyleGuide.Colors.Secondary.pink)
        ]
        
        var instructionCardsViewModels: [OnboardingInstructionCardContentViewPresentable] = []
        for index in 0..<3 {
            let title = NSMutableAttributedString(string: "card_\(index)_title_prefix".localized(), attributes: [.foregroundColor: Constants.Colors.titleColor, .font: Constants.Fonts.title])
            title.append(NSAttributedString(string: "card_\(index)_title_highlight".localized(), attributes: [.foregroundColor: Constants.Colors.titleHighlightedColor, .font: Constants.Fonts.title]))
            let instructionCardViewModel = OnboardingViewModel.InstructionCard(title: title, text: "card_\(index)_text".localized())
            instructionCardsViewModels.append(instructionCardViewModel)
        }
        
        let viewModel = OnboardingViewModel(dragableCards: dragableCardsViewModels, instructionCards: instructionCardsViewModels)
        displayLogic?.displayContent(viewModel: viewModel)
    }
}
