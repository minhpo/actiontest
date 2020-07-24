import Foundation

struct ChallengeProgram {
    
    public enum Status {
        case open
        case active
    }
    
    let id: Int
    let title: String
    let description: String
    let imageUrl: String
    let color: String
    let status: Status
    let infoUrl: String?
}
