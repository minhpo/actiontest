struct AppSessionResponse: Decodable {
    let keywordList: [KeywordEntity]?
    let reflectionQuestionList: [ReflectionQuestionEntity]?
    let cardDeckList: [CardDeckEntity]?
}
