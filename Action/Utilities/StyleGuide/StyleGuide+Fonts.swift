import UIKit

extension StyleGuide {
    
    enum Fonts {
        
        private static func font(name: String, size: CGFloat) -> UIFont {
            guard let font = UIFont(name: name, size: size) else {
                fatalError("Font not found")
            }
            
            return font
        }
        
        private static func black(size: CGFloat) -> UIFont { font(name: "CircularStd-Black", size: size) }
        private static func blackItalic(size: CGFloat) -> UIFont { font(name: "CircularStd-BlackItalic", size: size) }
        private static func bold(size: CGFloat) -> UIFont { font(name: "CircularStd-Bold", size: size) }
        private static func boldItalic(size: CGFloat) -> UIFont { font(name: "CircularStd-BoldItalic", size: size) }
        private static func book(size: CGFloat) -> UIFont { font(name: "CircularStd-Book", size: size) }
        private static func bookItalic(size: CGFloat) -> UIFont { font(name: "CircularStd-BookItalic", size: size) }
        private static func medium(size: CGFloat) -> UIFont { font(name: "CircularStd-Medium", size: size) }
        
        enum NavigationBar {
            static let title: UIFont = Fonts.bold(size: 16)
        }
        
        enum OnboardingInstructionCard {
            static let title: UIFont = Fonts.bold(size: 24)
            static let text: UIFont = Fonts.book(size: 16)
        }
        
        enum SimpleCard {
            static let text: UIFont = Fonts.bold(size: 21.5)
        }
        
        enum Onboarding {
            static let text: UIFont = Fonts.bold(size: 20)
        }
        
        enum Login {
            static let text: UIFont = Fonts.bold(size: 32)
            static let button: UIFont = Fonts.bold(size: 18)
        }
        
        enum ChallengeQuoteBanner {
            static let text: UIFont = Fonts.black(size: 32)
        }
        
        enum ChallengeSelection {
            static let primaryInstruction: UIFont = Fonts.bold(size: 32)
            static let secondaryInstruction: UIFont = Fonts.bold(size: 20)
        }
        
        enum ChallengeFinished {
            static let title: UIFont = Fonts.bold(size: 32)
            static let text: UIFont = Fonts.bold(size: 20)
        }
        
        enum ChallengeInfoView {
            static let title: UIFont = Fonts.bold(size: 24)
            static let subtitle: UIFont = Fonts.book(size: 16)
        }
        
        enum InfoView {
            static let text: UIFont = Fonts.medium(size: 11)
        }
        
        enum ChallengeProgramCard {
            static let title: UIFont = Fonts.bold(size: 24)
        }
        
        enum ChallengeProgramInfo {
            static let title: UIFont = Fonts.bold(size: 24)
            static let text: UIFont = Fonts.book(size: 16)
        }
        
        enum ChallengeProgramLargeCard {
            static let text: UIFont = Fonts.bold(size: 24)
        }
        
        enum ChallengeProgramSmallCard {
            static let text: UIFont = Fonts.bold(size: 20)
        }
        
        enum ChallengeReflection {
            static let header: UIFont = Fonts.bold(size: 18)
            static let title: UIFont = Fonts.bold(size: 32)
            static let points: UIFont = Fonts.medium(size: 14)
            static let question: UIFont = Fonts.medium(size: 20)
            static let answer: UIFont = Fonts.medium(size: 16)
        }
        
        enum Button {
            static let title: UIFont = Fonts.bold(size: 16)
        }
        
        enum QuizCard {
            static let title: UIFont = Fonts.book(size: 16)
            static let question: UIFont = Fonts.bold(size: 24)
            static let feedback: UIFont = Fonts.bold(size: 24)
            static let explanation: UIFont = Fonts.book(size: 16)
        }
    }
}
