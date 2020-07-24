import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(_ cellClass: T.Type) {
        let identifier = String(describing: cellClass)
        register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Error dequeueing cell")
        }
        
        return cell
    }
}
