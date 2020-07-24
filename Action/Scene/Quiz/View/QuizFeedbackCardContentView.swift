import UIKit
import EasyPeasy

final class QuizFeedbackCardContentView: UIView, CardContentView {
    
    private let nextButton = GHButton()
    private let tableView: UITableView = UITableView()
    
    private var contentViewModels: [QuizFeedbackContentViewPresentableItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: QuizFeedbackContentViewPresentable) {
        contentViewModels = viewModel.content
        tableView.reloadData()
    }
}

// MARK: - ConfigurableView -

extension QuizFeedbackCardContentView: ConfigurableView {
    
    func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.registerCell(QuizTitleTableViewCell.self)
        tableView.registerCell(QuizFeedbackTableViewCell.self)
        tableView.registerCell(QuizExplanationTableViewCell.self)
        tableView.registerCell(QuizMoreInfoTableViewCell.self)
        
        addSubview(tableView)
        
        nextButton.backgroundColor = StyleGuide.Colors.Primary.ghPurple
        nextButton.setTitle("quiz_next_button".localized(), for: .normal)
        addSubview(nextButton)
    }
    
    func configureLayout() {
        tableView.easy.layout(
            Leading(),
            Trailing(),
            Top()
        )
        
        let margin = StyleGuide.Margins.default
        nextButton.easy.layout(
            Leading(),
            Trailing(),
            Top(margin).to(tableView),
            Bottom(margin)
        )
    }
}

// MARK: - UITableViewDataSource -

extension QuizFeedbackCardContentView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch contentViewModels[indexPath.section] {
        case .title(let titleViewModel):
            let cell: QuizTitleTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.update(for: titleViewModel)
            return cell
        case .feedback(let feedbackViewModel):
            let cell: QuizFeedbackTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.update(for: feedbackViewModel)
            return cell
        case .explanation(let explanationViewModel):
            let cell: QuizExplanationTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.update(for: explanationViewModel)
            return cell
        case .moreInfo:
            let cell: QuizMoreInfoTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate -

extension QuizFeedbackCardContentView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let transparentView = UIView()
        transparentView.backgroundColor = .clear
        return transparentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
}
