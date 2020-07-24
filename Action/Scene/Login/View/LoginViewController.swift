import UIKit
import EasyPeasy

protocol LoginDisplayLogic: ScannerViewControllerDelegate {
    func displayGrantCameraAccess()
}

final class LoginViewController: UIViewController {
    
    // MARK: Internal properties
    var isFollowUpFromOnboarding = false {
        didSet {
            setText()
        }
    }
    
    // MARK: Private properties
    private let interactor: LoginInteractorDelegate
    private let exampleCardTopRight = SimpleCardView()
    private let exampleCardBottomLeft = SimpleCardView()
    private let textLabel = UILabel()
    private let loginButton = GHButton()
    
    // MARK: Lifecycle
    required init(interactor: LoginInteractorDelegate) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - LoginDisplayLogic -

extension LoginViewController: LoginDisplayLogic {
    
    func displayGrantCameraAccess() {
        let alert = UIAlertController(title: "camera_grant_access_title".localized(), message: "camera_grant_access_text".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "camera_grant_access_yes_button".localized(), style: .default, handler: { [weak self] _ in
            self?.interactor.handle(request: .settings)
        }))
        alert.addAction(UIAlertAction(title: "camera_grant_access_no_button".localized(), style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Private methods -

private extension LoginViewController {
    
    @objc
    func onLoginButtonTap() {
        interactor.handle(request: .startScanning)
    }
    
    func setText() {
        let highlightTextKey = isFollowUpFromOnboarding ? "text_onboarding_followup_highlighted" : "text_highlighted"
        let textKey = isFollowUpFromOnboarding ? "text_onboarding_followup_postfix" : "text_postfix"
        let text = NSMutableAttributedString(string: highlightTextKey.localized(), attributes: [.foregroundColor: StyleGuide.Colors.Primary.ghGreen, .font: StyleGuide.Fonts.Login.text])
        text.append(NSAttributedString(string: textKey.localized(), attributes: [.foregroundColor: StyleGuide.Colors.GreyTones.white, .font: StyleGuide.Fonts.Login.text]))
        textLabel.attributedText = text
    }
}

// MARK: - ConfigurableView -

extension LoginViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = StyleGuide.Colors.Secondary.purple
    }
    
    func configureSubviews() {
        let scale: CGFloat = 0.8
        exampleCardTopRight.contentView.update(for: LoginViewModel(color: StyleGuide.Colors.Secondary.pink, text: "example_card_text_1".localized()))
        exampleCardTopRight.alpha = 0.5
        exampleCardTopRight.transform = CGAffineTransform(rotationAngle: CGFloat.radians(degrees: -16)).scaledBy(x: scale, y: scale)
        view.addSubview(exampleCardTopRight)
        
        exampleCardBottomLeft.contentView.update(for: LoginViewModel(color: StyleGuide.Colors.Secondary.lightBlue, text: "example_card_text_2".localized()))
        exampleCardBottomLeft.alpha = 0.5
        exampleCardBottomLeft.transform = CGAffineTransform(rotationAngle: CGFloat.radians(degrees: 16)).scaledBy(x: scale, y: scale)
        view.addSubview(exampleCardBottomLeft)
        
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        setText()
        view.addSubview(textLabel)
        
        loginButton.addTarget(self, action: #selector(onLoginButtonTap), for: .touchUpInside)
        loginButton.setTitle("login_button".localized(), for: .normal)
        loginButton.titleLabel?.font = StyleGuide.Fonts.Login.button
        loginButton.backgroundColor = StyleGuide.Colors.Secondary.pink
        view.addSubview(loginButton)
    }
    
    func configureLayout() {
        
        textLabel.easy.layout(
            Leading(StyleGuide.Margins.default),
            Trailing(StyleGuide.Margins.default),
            CenterY()
        )
        
        loginButton.easy.layout(
            CenterX(),
            Bottom(90),
            Width(250)
        )
        
        let cardWidthRatio: CGFloat = 0.75
        let cardHeightRatio: CGFloat = 1.5
        exampleCardTopRight.easy.layout(
            Bottom().to(textLabel),
            Leading().to(view, .centerX),
            Width(*cardWidthRatio).like(view),
            Height(*cardHeightRatio).like(exampleCardTopRight, .width)
        )
        
        exampleCardBottomLeft.easy.layout(
            Top().to(textLabel),
            Trailing().to(view, .centerX),
            Width(*cardWidthRatio).like(view),
            Height(*cardHeightRatio).like(exampleCardBottomLeft, .width)
        )
    }
}

// MARK: - ScannerViewControllerDelegate -

extension LoginViewController: ScannerViewControllerDelegate {
    
    func scannerViewController(_ scannerViewController: ScannerViewController, didScan code: String) {
        interactor.handle(request: .scanned(secret: code))
    }
    
    func scannerViewController(_ scannerViewController: ScannerViewController, didFail error: ScannerError) {
        interactor.handle(request: .failedScanning(error: error))
    }
}

// MARK: - MaskExpandAnimatableContext -

extension LoginViewController: MaskExpandAnimatableContext {
    var startingMask: UIView? { loginButton }
}

// MARK: - MaskCollapseAnimatableContext -

extension LoginViewController: MaskCollapseAnimatableContext {
    var endingMask: UIView? { loginButton }
}
