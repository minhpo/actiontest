import UIKit

extension StyleGuide {
    
    enum Colors {
        
        enum GreyTones {
            static let white: UIColor = .white
            static let black: UIColor = UIColor(hex: "#1E1E1E")
            static let lightGrey: UIColor = UIColor(hex: "#E1E1E1")
            static let midGrey: UIColor = UIColor(hex: "#6E6E6E")
            static let darkGrey: UIColor = UIColor(hex: "#3C3C3C")
        }
        
        enum Primary {
            static let ghPurple: UIColor = UIColor(hex: "#5A1EEC")
            static let ghGreen: UIColor = UIColor(hex: "#0AFFBA")
        }
        
        enum Secondary {
            static let lightBlue: UIColor = UIColor(hex: "#2DD8FE")
            static let pink: UIColor = UIColor(hex: "#FA00CC")
            static let purple: UIColor = UIColor(hex: "#8000EC")
            static let yellow: UIColor = UIColor(hex: "#FAC541")
        }
        
        enum Tertiary {
            static let red: UIColor = UIColor(hex: "#DA014E")
            static let badRed: UIColor = UIColor(hex: "#DF224F")
            static let goodGreen: UIColor = UIColor(hex: "#40DB9B")
        }
    }
}
