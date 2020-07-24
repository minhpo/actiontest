struct DailyChallengeEntity: Decodable {
    let id: Int
    let challengeCardList: [ChallengeCardEntity]?
    let selectedCardId: String?
    let status: String
}
