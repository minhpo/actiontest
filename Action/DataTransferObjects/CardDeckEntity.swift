struct CardDeckEntity: Decodable {
    let id: Int
    let courseId: Int
    let name: String
    let backgroundColor: String?
    let imageUrl: String
    let description: String
    let trainingUrl: String
    let quizCardList: [QuizCardEntity]?
    let dailyChallengeList: [DailyChallengeEntity]?
    let status: String
}
