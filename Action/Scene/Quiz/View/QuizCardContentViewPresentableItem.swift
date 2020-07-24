import Foundation

enum QuizCardContentViewPresentableItem {
    case title(viewModel: QuizTitleViewPresentable)
    case question(viewModel: QuizQuestionViewPresentable)
    case answers(viewModel: QuizAnswersViewPresentable)
}
