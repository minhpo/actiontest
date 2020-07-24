import Foundation

protocol AssignmentMapper {
    func map(from challengeElementEntity: ChallengeElementEntity) -> Assignment?
}

struct AssignmentMappingService: AssignmentMapper {
    
    private let assignmentTypeMapper: AssignmentTypeMapper
    private let selectOptionMapper: SelectOptionMapper
    
    init(assignmentTypeMapper: AssignmentTypeMapper = AssignmentTypeMappingService(),
         selectOptionMapper: SelectOptionMapper = SelectOptionMappingService()) {
        self.assignmentTypeMapper = assignmentTypeMapper
        self.selectOptionMapper = selectOptionMapper
    }
    
    func map(from challengeElementEntity: ChallengeElementEntity) -> Assignment? {
        guard let type = assignmentTypeMapper.map(from: challengeElementEntity.challengeElementType) else {
            return nil
        }
        
        guard let title = challengeElementEntity.label else {
            return nil
        }
        
        let options: [SelectOption]
        if let optionList = challengeElementEntity.optionList {
            options = optionList.map { selectOptionMapper.map(from: $0) }
        } else {
            options = []
        }
        
        return Assignment(type: type,
                          title: title,
                          placeholder: challengeElementEntity.value ?? "",
                          options: options)
    }
}
