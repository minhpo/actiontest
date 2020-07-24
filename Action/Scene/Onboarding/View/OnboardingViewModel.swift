import UIKit

struct OnboardingViewModel {
    
    struct DragableCard {
        let color: UIColor
    }
    
    struct InstructionCard: OnboardingInstructionCardContentViewPresentable {
        let title: NSAttributedString
        let text: String
    }
    
    let dragableCards: [SimpleCardContentViewPresentable]
    let instructionCards: [OnboardingInstructionCardContentViewPresentable]
}

// MARK: - SimpleCardContentViewPresentable -

extension OnboardingViewModel.DragableCard: SimpleCardContentViewPresentable {
    var text: String? { nil }
}
