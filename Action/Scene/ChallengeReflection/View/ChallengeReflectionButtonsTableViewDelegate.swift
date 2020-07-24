import Foundation

protocol ChallengeReflectionButtonsTableViewDelegate: AnyObject {
    func buttonsCellDidSubmit(_ cell: ChallengeReflectionButtonsTableViewCell)
    func buttonsCellDidCancel(_ cell: ChallengeReflectionButtonsTableViewCell)
}
