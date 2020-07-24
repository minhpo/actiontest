import UIKit
import EasyPeasy

protocol ChallengeDisplayLogic: AnyObject {
    func display(viewModel: ChallengeDetailsViewModel)
}

final class ChallengeViewController: UIViewController {
    
    // MARK: Internal properties
    let tableView = UITableView()
    
    // MARK: Private properties
    private let interactor: ChallengeInteractorDelegate
    private var viewModel = ChallengeDetailsViewModel(content: [])
    
    // MARK: Lifecycle
    required init(interactor: ChallengeInteractorDelegate) {
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

// MARK: - ChallengeDisplayLogic -

extension ChallengeViewController: ChallengeDisplayLogic {
    
    func display(viewModel: ChallengeDetailsViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

// MARK: - ConfigurableView -

extension ChallengeViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = StyleGuide.Colors.GreyTones.white
    }
    
    func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        if #available(iOS 13, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        
        let oldContentInset = tableView.contentInset
        let newContentInset = UIEdgeInsets(top: oldContentInset.top, left: oldContentInset.left, bottom: oldContentInset.bottom + 32, right: oldContentInset.right)
        tableView.contentInset = newContentInset
        
        tableView.registerCell(ChallengeBannerTableViewCell.self)
        tableView.registerCell(ChallengeInfoTableViewCell.self)
        tableView.registerCell(ChallengeButtonsTableViewCell.self)
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.easy.layout(
            Edges()
        )
    }
}

// MARK: - UITableViewDataSource -

extension ChallengeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.content.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.content[indexPath.section] {
        case .banner(let viewModel):
            let cell: ChallengeBannerTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.update(for: viewModel)
            return cell
        case .info(let viewModel):
            let cell: ChallengeInfoTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.update(for: viewModel)
            return cell
        case .buttons(let buttonTypes):
            let cell: ChallengeButtonsTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.update(for: buttonTypes)
            cell.delegate = self
            return cell

        }
    }
}

// MARK: - UITableViewDelegate -

extension ChallengeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let transparentView = UIView()
        transparentView.backgroundColor = .clear
        return transparentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? 24 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .banner = viewModel.content[indexPath.section] else { return }
        interactor.handle(request: .banner)
    }
}

// MARK: - ChallengeButtonsTableViewCellDelegate -

extension ChallengeViewController: ChallengeButtonsTableViewCellDelegate {
    
    func challengeButtonsTableViewCell(_ cell: ChallengeButtonsTableViewCell, didTapButton: ChallengeDetailsViewModel.ButtonType) {
        switch didTapButton {
        case .snooze:
            interactor.handle(request: .buttonTap(type: .snooze))
        case .finish:
            interactor.handle(request: .buttonTap(type: .finish))
        }
    }
}

// MARK: Private setup methods
private extension ChallengeViewController { }
