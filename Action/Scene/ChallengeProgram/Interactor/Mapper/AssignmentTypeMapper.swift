import Foundation

protocol AssignmentTypeMapper {
    func map(from typeString: String) -> AssignmentType?
}

struct AssignmentTypeMappingService: AssignmentTypeMapper {
    
    func map(from typeString: String) -> AssignmentType? {
        AssignmentType(rawValue: typeString)
    }
}
