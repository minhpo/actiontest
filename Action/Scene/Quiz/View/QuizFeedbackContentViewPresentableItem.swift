import Foundation

enum QuizFeedbackContentViewPresentableItem {
    case title(viewModel: QuizTitleViewPresentable)
    case feedback(viewModel: QuizFeedbackViewPresentable)
    case explanation(viewModel: QuizExplanationViewPresentable)
    case moreInfo
}
