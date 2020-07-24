import UIKit
import EasyPeasy

final class SemiTransparentLoadingIndicatorView: UIView {
    
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        addSubview(spinner)
        spinner.easy.layout(
            Center()
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ActivityIndicator communication -

extension SemiTransparentLoadingIndicatorView {
    
    func startAnimating() {
        spinner.startAnimating()
    }
    
    func stopAnimating() {
        spinner.stopAnimating()
    }
}
