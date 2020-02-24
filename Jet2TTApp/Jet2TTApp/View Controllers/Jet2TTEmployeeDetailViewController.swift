//
//  Jet2TTEmployeeDetailViewController.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import UIKit

final class Jet2TTEmployeeDetailViewController: UIViewController {
    
    // MARK: - Variables

    var selectedMemeber: Member?
    
    // MARK: - View Life Cycle

    @IBOutlet var employeeDetailTableView: UITableView! {
        didSet {
            self.employeeDetailTableView.dataSource = self
            self.employeeDetailTableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.employeeDetailTableView.estimatedRowHeight = UITableView.automaticDimension
        self.title = "Employees"
        guard let selectedMemeber = self.selectedMemeber, let headerView = Jet2TTEmployeeDetailHeaderView().instantiateHeaderView(with: selectedMemeber) else { return }
        self.employeeDetailTableView.tableHeaderView = headerView
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }

    func sizeHeaderToFit() {
        let headerView = self.employeeDetailTableView.tableHeaderView!
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        self.employeeDetailTableView.tableHeaderView = headerView
    }
    
}

extension Jet2TTEmployeeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HeaderType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Jet2TTEmployeeDetailCell.cellIdentifier) as? Jet2TTEmployeeDetailCell else {
            return UITableViewCell()
        }
        if let selectedMember = self.selectedMemeber {
            cell.configureCell(with: selectedMember, andHeaderType: HeaderType.allCases[indexPath.row])
        }
        return cell
    }
}
