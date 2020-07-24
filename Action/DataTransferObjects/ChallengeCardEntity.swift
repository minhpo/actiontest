struct ChallengeCardEntity: Decodable {
    let id: String
    let xp: Int
    let challengeCardColor: String
    let estimatedDuration: Int
    let participantCount: Int
    let challengeFrontTitle: String
    let challengeFrontDescription: String?
    let challengeBackTitle: String
    let challengeBackDescription: String?
    let challengeBackMediaType: String?
    let challengeBackMediaValue: String?
    let challengeElementList: [ChallengeElementEntity]?
}
