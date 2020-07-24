import UIKit
import EasyPeasy

final class QuizCardContentView: UIView, CardContentView {
    
    private let tableView: UITableView = UITableView()
    private let submitView = QuizSubmitView()
    private var contentViewModels: [QuizCardContentViewPresentableItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: QuizCardContentViewPresentable) {
        contentViewModels = viewModel.content
        
        if viewModel.delaySubmit {
            let inset = UIEdgeInsets(top: 0, left: 0, bottom: submitView.intrinsicContentSize.height, right: 0)
            tableView.contentInset = inset
            tableView.scrollIndicatorInsets = inset
            
            submitView.isHidden = false
        } else {
            tableView.contentInset = .zero
            tableView.scrollIndicatorInsets = .zero
            
            submitView.isHidden = true
        }
        
        tableView.reloadData()
    }
}

//MARK: - ConfigurableView -

extension QuizCardContentView: ConfigurableView {
    
    func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.registerCell(QuizTitleTableViewCell.self)
        tableView.registerCell(QuizQuestionTableViewCell.self)
        tableView.registerCell(QuizAnswersTableViewCell.self)
        
        addSubview(tableView)
        
        addSubview(submitView)
    }
    
    func configureLayout() {
        tableView.easy.layout(
            Edges()
        )
        
        submitView.easy.layout(
            Leading(),
            Trailing(),
            Bottom()
        )
    }
}

//MARK: - UITableViewDataSource -

extension QuizCardContentView: UITableViewDataSource {
    
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
        case .question(let questionViewModel):
            let cell: QuizQuestionTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.update(for: questionViewModel)
            return cell
        case .answers(let answersViewModel):
            let cell: QuizAnswersTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.update(for: answersViewModel)
            return cell
        }
    }
}

//MARK: - UITableViewDelegate -

extension QuizCardContentView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let transparentView = UIView()
        transparentView.backgroundColor = .clear
        return transparentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
}
