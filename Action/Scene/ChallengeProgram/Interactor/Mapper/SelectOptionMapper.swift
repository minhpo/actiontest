import Foundation

protocol SelectOptionMapper {
    func map(from entity: SelectOptionEntity) -> SelectOption
}

struct SelectOptionMappingService: SelectOptionMapper {
    
    func map(from entity: SelectOptionEntity) -> SelectOption {
        SelectOption(key: entity.key, value: entity.value)
    }
}
