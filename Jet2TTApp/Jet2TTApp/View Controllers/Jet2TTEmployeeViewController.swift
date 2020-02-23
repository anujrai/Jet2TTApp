//
//  Jet2TTEmployeeViewController.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 22/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import UIKit

final class Jet2TTEmployeeViewController: UIViewController {
    
    private var deleteEmployeeIndexPath: NSIndexPath? = nil
    
    private lazy var sortBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showSortMenu))
        return barButtonItem
    }()
    
    // MARK: - Variables
    var members: [Member]? {
        didSet {
            self.employeeTableView.reloadData()
        }
    }
    
    var objJet2TTMemeberViewModel = Jet2TTEmployeeViewModel()
    lazy var spinnerView: SpinnerView = SpinnerView()
    lazy var noConnectionView: Jet2TTNoConnectionView = Jet2TTNoConnectionView { [weak self] in
        self?.retryMemberFetch()
    }
    
    // MARK: - View Life Cycle
    
    @IBOutlet var employeeTableView: UITableView! {
        didSet {
            self.employeeTableView.dataSource = self
            self.employeeTableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sortBarButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = self.sortBarButtonItem
        self.employeeTableView.estimatedRowHeight = UITableView.automaticDimension
        self.employeeTableView.rowHeight = 100.0
        self.title = "Employees"
        
        startMemberFetch(isFirstTime: true)
    }
    
    private func startMemberFetch(isFirstTime: Bool) {
        
        if !Reachability.isConnectedToNetwork() {
            noConnectionView.showNoConnectionView(onView: self.view)
        } else {
            noConnectionView.removeNoConnectionView()
            
            self.sortBarButtonItem.isEnabled = true
            
            if isFirstTime {
                spinnerView.showSpinner(onView: self.view)
            }
            
            objJet2TTMemeberViewModel.fetchMembers(onSuccess: {
                print(self.objJet2TTMemeberViewModel.memberResponse ?? "")
                self.members = self.objJet2TTMemeberViewModel.member
                if isFirstTime {
                    self.spinnerView.removeSpinner()
                }
            }, onFailure: {_ in
                if isFirstTime {
                    self.spinnerView.removeSpinner()
                }
            })
        }
    }
    
    private func retryMemberFetch() {
        startMemberFetch(isFirstTime: true)
    }
    
    @objc func showSortMenu() {
        
        let alertVC = UIAlertController(title: "Sort By:", message: "Pick a sorting criteria", preferredStyle: .actionSheet)
        let sortByLastNameAction = UIAlertAction(title: "Last Name", style: .default, handler: sortByLastName)
        let sortByAgeAction = UIAlertAction(title: "Age", style: .default, handler: sortByAge)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(sortByLastNameAction)
        alertVC.addAction(sortByAgeAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
}


extension Jet2TTEmployeeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell") as? Jet2TTEmployeeCell else {
            return UITableViewCell()
        }
        
        guard let members = self.members else { return cell }
        let member = members[indexPath.row]
        cell.nameLabel.text = member.fullName
        cell.genderLabel.text = member.gender
        cell.titleView.update(with: member.name?.title)
        
        if let urlString = member.profilePicture.thumbnail, let url = URL.init(string: urlString) {
            cell.thumbnailImageView.loadImage(at: url)
        }
        
        if (indexPath.row == members.count - 10 && members.count  < self.objJet2TTMemeberViewModel.totalCount ) {
            self.startMemberFetch(isFirstTime: false)
        }
        
        return cell
    }
}

extension Jet2TTEmployeeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let detailView = UIStoryboard.instantiateViewcontroller(ofType: Jet2TTEmployeeDetailViewController.self) as! Jet2TTEmployeeDetailViewController
        detailView.selectedMemeber = self.members?[indexPath.row]
        self.navigationController?.pushViewController(detailView, animated: true);
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteEmployeeIndexPath = indexPath as NSIndexPath
            guard let employee = members?[indexPath.row] else { return }
            confirmDelete(memeber: employee)
        }
    }
    
    private func confirmDelete(memeber: Member) {
        
        let alertVC = UIAlertController.init(title: "Delete Employee", message: "Are you sure you want to permanently delete \(memeber.fullName)?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteEmployee)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: handleCancelAction)
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        
        self.popoverPresentationController?.sourceView = self.view
        self.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.width / 2.0, y: self.view.bounds.height / 2.0, width: 1.0, height: 1.0)
        present(alertVC, animated: true, completion: nil)
    }
    
    private func handleDeleteEmployee(alertAction: UIAlertAction!) -> Void {
        
        if let indexPath = deleteEmployeeIndexPath {
            employeeTableView.beginUpdates()
            members?.remove(at: indexPath.row)
            employeeTableView.deleteRows(at: [(indexPath as IndexPath)], with: .automatic)
            deleteEmployeeIndexPath = nil
            employeeTableView.endUpdates()
        }
    }
    
    private func handleCancelAction(alertAction: UIAlertAction!) -> Void {
        self.deleteEmployeeIndexPath = nil
    }
    
}

extension Jet2TTEmployeeViewController {
    
    private func sortByLastName(alertAction: UIAlertAction!) {
        if let members = self.members {
            let sortedArray = members.sorted {
                let lastName0 = $0.name?.last ?? ""
                let lastName1 = $1.name?.last ?? ""
                return lastName0 < lastName1
            }
            self.members = sortedArray
        }
    }
    
    private func sortByAge(alertAction: UIAlertAction!) {
        if let members = self.members {
            let sortedArray = members.sorted {
                let age0 = $0.dob?.age ?? -1
                let age1 = $1.dob?.age ?? -1
                return age0 < age1
            }
            self.members = sortedArray
        }
    }
}

