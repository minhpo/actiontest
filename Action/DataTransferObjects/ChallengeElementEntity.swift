struct ChallengeElementEntity: Decodable {
    let challengeElementType: String
    let label: String?
    let className: String?
    let value: String?
    let optionList: [SelectOptionEntity]?
}
