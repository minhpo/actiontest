import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        
        window = UIWindow()
        
        window?.rootViewController = LaunchViewControllerFactory.make()
        window?.makeKeyAndVisible()
        
        return true
    }

}

private extension AppDelegate {
    
    func customizeAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.titleTextAttributes = [.foregroundColor: StyleGuide.Colors.GreyTones.white, .font: StyleGuide.Fonts.NavigationBar.title]
        appearance.tintColor = StyleGuide.Colors.GreyTones.white
        appearance.barTintColor = StyleGuide.Colors.GreyTones.white
        appearance.barStyle = .black
        appearance.setBackgroundImage(UIImage(), for: .default)
        appearance.shadowImage = UIImage()
        appearance.isTranslucent = true
    }
}

