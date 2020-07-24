enum DailyChallengeCommand: String, Encodable {
    case activate
}

struct ActivateDailyChallengePayload: Encodable {
    let command: DailyChallengeCommand
    let dailyChallengeId: Int
    let selectedCardId: String
}
