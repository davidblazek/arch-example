//
//  ServerListViewController.swift
//  AppCore
//

import UIKit

protocol ServerListViewDelegate: AnyObject {
    func setLoading(isLoading: Bool)
    func setServers(items: [VPNProfileModel])
    func setIsPremium(isPremium: Bool)
}

class ServerListTableViewDataSource: BaseTableViewDataSource<VPNProfileModel> {

    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath, type item: VPNProfileModel) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ServerListTableViewCell.cellIdentifier, for: indexPath) as? ServerListTableViewCell {
            cell.configure(data: item)
            return cell
        }
        return UITableViewCell()
    }
}

class ServerListViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let viewModel: ServerListViewModel

    private var dataSource = ServerListTableViewDataSource(items: [])
    
    init(viewModel: ServerListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: R.nib.serverListViewController.name, bundle: R.nib.serverListViewController.bundle)
    }
    
    required public init?(coder argument: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.items[indexPath.row]
        viewModel.serverSelected(item: item)
    }

    @IBAction func closeAction(_ sender: Any) {
        viewModel.closeAction()
    }
    
    @IBAction func premiumAction(_ sender: Any) {
        viewModel.premiumAction()
    }
    
    private func setupViews() {
        tableView.delegate = self
        tableView.register(ServerListTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        
        titleLabel.font = Font.init(type: .bold, size: .large).font
        titleLabel.text = Localizable.serverListTitle()

        premiumButton.isHidden = true
        premiumButton.backgroundColor = .clear
        premiumButton.setTitle(Localizable.serverListPurchase(), for: .normal)
    }
}

extension ServerListViewController: ServerListViewDelegate {
    
    func setLoading(isLoading: Bool) {
        spinner.isHidden = !isLoading
    }
    
    func setServers(items: [VPNProfileModel]) {
        dataSource = ServerListTableViewDataSource(items: items)
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    func setIsPremium(isPremium: Bool) {
        premiumButton.isHidden = isPremium
    }
}
