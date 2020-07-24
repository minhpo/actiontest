import Foundation

protocol ChallengeButtonsTableViewCellDelegate: AnyObject {
    func challengeButtonsTableViewCell(_ cell: ChallengeButtonsTableViewCell, didTapButton: ChallengeDetailsViewModel.ButtonType)
}
