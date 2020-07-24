import Foundation

struct Challenge {
    
    enum Status: String {
        case open
        case active
        case pendingReview = "pendingreview"
        case postponed
        case closed
    }
    
    let id: String
    let color: String
    let status: Status
    let banner: Banner
    let titleFront: String
    let descriptionFront: String
    let titleBack: String
    let descriptionBack: String
    let additionalInfo: AdditionalInfo
    let assignments: [Assignment]
}
