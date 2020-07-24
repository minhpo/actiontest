import Foundation

struct QuizViewModel {
    let questionsContext: QuizQuestionsContext
    let feedbackContext: QuizFeedbackContext
    
    struct QuizQuestionsContext: QuizCardContentViewPresentable {
        let content: [QuizCardContentViewPresentableItem]
        let delaySubmit: Bool
    }
    
    struct QuizFeedbackContext: QuizFeedbackContentViewPresentable {
        let content: [QuizFeedbackContentViewPresentableItem]
    }
    
    struct QuizTitle: QuizTitleViewPresentable {
        let title: String
    }
    
    struct QuizQuestion: QuizQuestionViewPresentable {
        let question: String
    }
    
    struct QuizAnswers: QuizAnswersViewPresentable {
        let content: [QuizAnswersViewPresentableItem]
    }
    
    struct QuizFeedback: QuizFeedbackViewPresentable {
        let feedback: String
    }
    
    struct QuizExplanation: QuizExplanationViewPresentable {
        let explanation: String
    }
}
