import UIKit

struct ChallengeReflectionViewModel {
    
    enum ContentItem {
        case metadata(viewModel: ChallengeReflectionMetadataPresentable)
        case questions(viewModel: ChallengeReflectionQuestionPresentable)
        case buttons(viewModel: ChallengeReflectionButtonsPresentable)
    }
    
    struct MetaData: ChallengeReflectionMetadataPresentable {
        let tintColor: UIColor
    }
    
    struct Buttons: ChallengeReflectionButtonsPresentable {
        let tintColor: UIColor
    }
    
    struct Question: ChallengeReflectionQuestionPresentable {
        let question: String
        let minValueText: String
        let maxValueText: String
    }
    
    let items: [ContentItem]
}
