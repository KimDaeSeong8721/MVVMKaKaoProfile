//
//  ViewController.swift
//  KakaoProfile
//
//  Created by DaeSeong on 2022/07/09.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa


class FirstViewController: BaseViewController, ViewModelBindableType {
    // MARK: - Properties


    var viewModel: FirstViewModel!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.identifier)
        return tableView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func render() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // 뷰 구성
    override func configUI() {
        super.configUI()
        configureNavBar()
    }

    func bind() {
        let input = FirstViewModel.Input(
            tableItemsSelected: tableView.rx.itemSelected,
            tableModelSelected:tableView.rx.modelSelected(Information.self)
            )

        let output = viewModel.transform(input: input)

        output.InfoList
            .bind(to: tableView.rx.items) { tableView, row, info -> UITableViewCell in
                if row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier, for: IndexPath.init(row: row, section: 0))
                        as! PersonTableViewCell
                    cell.configure(info: info)
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: IndexPath.init(row: row, section: 0))
                        as! FriendTableViewCell
                    cell.configure(info: info)
                    return cell
                }
            }
            .disposed(by: viewModel.disposeBag)


        output.tappedProfile
            .subscribe(onNext: { indexPath, info in
                self.tableView.deselectRow(at: indexPath, animated: true)
                if indexPath.row == 0 {
                    var vc = ProfileViewController()
                    vc.bindViewModel(ProfileViewModel(info: info))
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                }
            })
        .disposed(by: viewModel.disposeBag)
    }

    
    // MARK: - Funcs

    private func configureNavBar(){
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.text = "친구"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
}
