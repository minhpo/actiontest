import UIKit

struct ChallengeCardContentViewModel {
    let tintColor: UIColor
    let challengeInfo: ChallengeInfoPresentable
    let banner: ChallengeBannerViewPresentable
}

extension ChallengeCardContentViewModel: ChallengeFrontSideCardContentViewPresentable {
    
    var backgroundColor: UIColor {
        return tintColor
    }
}

extension ChallengeCardContentViewModel: ChallengeBackSideCardContentViewPresentable { }
