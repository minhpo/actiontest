import UIKit
import EasyPeasy

protocol ChallengeReflectionDisplayLogic: AnyObject {
    func display(viewModel: ChallengeReflectionViewModel)
}

final class ChallengeReflectionViewController: UIViewController {
    
    // MARK: Internal properties
    let tableView = UITableView()
    
    // MARK: Private properties
    private let interactor: ChallengeReflectionInteractorDelegate
    private var viewModel = ChallengeReflectionViewModel(items: [])
    
    // MARK: Lifecycle
    required init(interactor: ChallengeReflectionInteractorDelegate) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        interactor.handle(request: .initialize)
    }
}

// MARK: - ChallengeReflectionDisplayLogic -

extension ChallengeReflectionViewController: ChallengeReflectionDisplayLogic {
    
    func display(viewModel: ChallengeReflectionViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource -

extension ChallengeReflectionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.items[indexPath.section] {
        case .metadata(let viewModel):
            let cell: ChallengeReflectionMetadataTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.update(for: viewModel)
            return cell
        case .questions(let viewModel):
            let cell: ChallengeReflectionQuestionTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.update(for: viewModel)
            return cell
        case .buttons(let viewModel):
            let cell: ChallengeReflectionButtonsTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.delegate = self
            cell.update(for: viewModel)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate -

extension ChallengeReflectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let transparentView = UIView()
        transparentView.backgroundColor = .clear
        return transparentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (viewModel.items[section], section) {
        case (.buttons, _):
            return 24
        case (_, 0):
            return 0
        default:
            return 16
        }
    }
}

// MARK: - ChallengeReflectionDisplayLogic -

extension ChallengeReflectionViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = StyleGuide.Colors.GreyTones.white
    }
    
    func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        
        let oldContentInset = tableView.contentInset
        let newContentInset = UIEdgeInsets(top: oldContentInset.top, left: oldContentInset.left, bottom: oldContentInset.bottom + 32, right: oldContentInset.right)
        tableView.contentInset = newContentInset
        
        tableView.registerCell(ChallengeReflectionMetadataTableViewCell.self)
        tableView.registerCell(ChallengeReflectionQuestionTableViewCell.self)
        tableView.registerCell(ChallengeReflectionButtonsTableViewCell.self)
        
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.easy.layout(
            Edges()
        )
    }
}

// MARK: - ChallengeReflectionButtonsTableViewDelegate -
extension ChallengeReflectionViewController: ChallengeReflectionButtonsTableViewDelegate {
    
    func buttonsCellDidSubmit(_ cell: ChallengeReflectionButtonsTableViewCell) {
        interactor.handle(request: .buttonTap(type: .submit))
    }
    
    func buttonsCellDidCancel(_ cell: ChallengeReflectionButtonsTableViewCell) {
        interactor.handle(request: .buttonTap(type: .cancel))
    }
}

// MARK: - Private methods -
private extension ChallengeReflectionViewController { }
