import Foundation

protocol ConfigurableView {
    func configureView()
    func configureViewProperties()
    func configureSubviews()
    func configureLayout()
}

extension ConfigurableView {
    
    func configureView() {
        configureViewProperties()
        configureSubviews()
        configureLayout()
    }
    
    func configureViewProperties() { }
    func configureSubviews() { }
    func configureLayout() { }
}
