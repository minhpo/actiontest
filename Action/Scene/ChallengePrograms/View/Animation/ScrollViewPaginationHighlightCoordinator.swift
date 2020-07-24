import UIKit

final class ScrollViewPaginationHighlightCoordinator {
    
    private let scrollView: UIScrollView
    private let pageView: UIView
    private let pageIndex: CGFloat
    private var observerToken: NSKeyValueObservation?
    
    private let tolerance: CGFloat
    private let translation: CGFloat
    
    init(scrollView: UIScrollView, pageView: UIView, pageIndex: CGFloat, translation: CGFloat, tolerance: CGFloat) {
        self.scrollView = scrollView
        self.pageView = pageView
        self.pageIndex = pageIndex
        
        self.translation = translation
        self.tolerance = tolerance
        
        updatePageViewAppearance()
        
        observerToken = scrollView.observe(\.contentOffset) { [weak self] (_, _) in
            self?.scrollViewDidScroll()
        }
    }
    
    deinit {
        observerToken?.invalidate()
    }
}

private extension ScrollViewPaginationHighlightCoordinator {
    
    func scrollViewDidScroll() {
        updatePageViewAppearance()
    }
    
    func updatePageViewAppearance() {
        let distance = abs(scrollView.contentOffset.x - (pageIndex * scrollView.frame.width))
        let sanetizedDistance = min(translation, max(0, distance - tolerance))
        
        let scaling = max(0.7, 1 - (sanetizedDistance / translation))
        pageView.transform = CGAffineTransform(scaleX: scaling, y: scaling)
        
        let alpha = max(0.2, 1 - (sanetizedDistance / translation))
        pageView.alpha = alpha
    }
}
