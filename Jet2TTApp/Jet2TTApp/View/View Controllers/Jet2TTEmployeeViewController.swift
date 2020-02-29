//
//  Jet2TTEmployeeViewController.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 22/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import UIKit

final class Jet2TTEmployeeViewController: UIViewController {
    
    // MARK: UIStateForDataFetching Enum
    
    private enum UIStateForDataFetching: String {
        case notConnected
        case fetching
        case done
        case failed
    }
    
    // MARK: Constants Enum
    private enum Constants {
        static let sortTitle = "Sort"
        static let sortByTitle = "Sort By:"
        static let pickSortingCriteria = "Pick a sorting criteria"
        static let sortByLastName = "Last Name"
        static let sortByAge = "Age"
        static let cancel = "Cancel"
        static let ok = "Ok"
        static let delete = "Delete"
        static let deleteTitle = "Delete Employee"
        static let deleteMmessage = "Are you sure you want to permanently delete"
        static let appIsonlineTitle = "Application is Online"
        static let onlineMessage = "Do you want to switch back to online mode?"
        static let noRecordsTitle = "No Records"
        static let noRecordsMessage = "No record / records found."

        static let tableAutomaticRowHeight = 100.0
        static let gatewatFetcherCountForTable = 10
        static let totalEmployeeDetilsCount = 1000
        static let cellIdentifier = "employeeCell"
        
        
    }

    
    // MARK: Variables
    var coreDataStack: Jet2TTCoreDataStack?
    private var deleteEmployeeIndexPath: NSIndexPath? = nil
    var members: [Member]? {
           didSet {
               self.employeeTableView.reloadData()
           }
       }
    private lazy var spinnerView: SpinnerView = SpinnerView()
    private lazy var networkFetcher: GatewayFetcher = GatewayFetcher()
    private lazy var sortBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: Constants.sortTitle, style: .plain, target: self, action: #selector(showSortMenu))
        return barButtonItem
    }()
    
    private lazy var coreDataManager: Jet2TTCoreDataManager? = {
        guard let coreDataStack = self.coreDataStack else { return nil }
        return Jet2TTCoreDataManager(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }()
    

    private var viewModel: Jet2TTEmployeeViewModel? {
        if ReachabilityManager.applicationConnectionMode == .online {
            return Jet2TTEmployeeViewModel(networkFetcher)
        } else {
            guard let coreDataManager = self.coreDataManager else { return nil }
            return Jet2TTEmployeeViewModel(coreDataManager)
        }
    }
        
    private lazy var noConnectionView: Jet2TTNoConnectionView = Jet2TTNoConnectionView { [weak self] in
        self?.retryMemberFetch()
    }
    
    // MARK: - View Life Cycle
    @IBOutlet var employeeTableView: UITableView! {
        didSet {
            self.employeeTableView.dataSource = self
            self.employeeTableView.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ReachabilityManager.updateApplicationConnectionStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sortBarButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = self.sortBarButtonItem
        self.employeeTableView.estimatedRowHeight = UITableView.automaticDimension
        self.employeeTableView.rowHeight = CGFloat(Constants.tableAutomaticRowHeight)
        self.title = "Employees"
        
        startMemberFetch()
    }
    
    // MARK: Private and Public functions
    private func startMemberFetch() {
        
        ReachabilityManager.updateApplicationConnectionStatus()
        
        if ReachabilityManager.applicationConnectionMode == .online {
            updateUIForDataFetchingStatus(.fetching)
            getMembers()
        } else {
            updateUIForDataFetchingStatus(.notConnected)
            setReachabilityNotifier()
        }
    }
    
    private func retryMemberFetch() {
        updateUIForDataFetchingStatus(.fetching)
        getMembers()
    }
    
    private func getMembers() {
        
        viewModel?.getMembers({ [weak self] (members) in
            self?.members = members
            self?.updateUIForDataFetchingStatus(.done)
            
            }, { [weak self] (error) in
                
                self?.updateUIForDataFetchingStatus(.failed)
                if let error = error as? Jet2TTError, error == Jet2TTError.noRecords {
                    self?.showNoRecordsPrompt()
                }
        })
    }
    
    @objc private func switchBackToOnlineMode(alertAction: UIAlertAction?) {
        startMemberFetch()
    }
    
    private func setReachabilityNotifier () {
        ReachabilityManager.registerToMonitorNetworkChange { reachability in
            ReachabilityManager.deregisterToMonitorNetworkChange()
            self.showSwitchToOnlineMode()
        }
    }
    
    private func updateUIForDataFetchingStatus(_ status: UIStateForDataFetching) {
        
        switch status {
        case .notConnected:
            noConnectionView.showNoConnectionView(onView: self.view)
        case .fetching:
            noConnectionView.removeNoConnectionView()
            if self.members == nil {
                spinnerView.showSpinner(onView: self.view)
            }
        case .done:
            if self.members != nil {
                self.sortBarButtonItem.isEnabled = true
                self.spinnerView.removeSpinner()
            }
        case .failed:
            if self.members == nil {
                self.spinnerView.removeSpinner()
            }
        }
    }
    
    private func sortByLastName(alertAction: UIAlertAction!) {
          if let members = self.members {
              self.members = self.viewModel?.sortEmployee(by: .lastName, members: members)
          }
      }
      
      private func sortByAge(alertAction: UIAlertAction!) {
          if let members = self.members {
              self.members = self.viewModel?.sortEmployee(by: .age, members: members)
          }
      }
    
}


extension Jet2TTEmployeeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? Jet2TTEmployeeCell else {
            return UITableViewCell()
        }
        
        guard let members = self.members else { return cell }
        let member = members[indexPath.row] as Member
        cell.configure(withMember: member)
        
        if (indexPath.row == members.count - Constants.gatewatFetcherCountForTable && members.count  < Constants.totalEmployeeDetilsCount &&
            ReachabilityManager.applicationConnectionMode == .online) {
            startMemberFetch()
        }
        
        return cell
    }
}

extension Jet2TTEmployeeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let detailView = UIStoryboard.instantiateViewcontroller(ofType: Jet2TTEmployeeDetailViewController.self) as! Jet2TTEmployeeDetailViewController
        
        detailView.coreDataManager = self.coreDataManager
        
        if var selectedMemeber =  self.members?[indexPath.row] {
            if ReachabilityManager.applicationConnectionMode == .online {
                if let cell = tableView.cellForRow(at: indexPath) as? Jet2TTEmployeeCell {
                    selectedMemeber.picture?.thumbnailData = cell.thumbnailImageView.image?.pngData()
                }
            }
            detailView.selectedMemeber = selectedMemeber
        }
        
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
}

// MARK: Aler Controller

extension Jet2TTEmployeeViewController {
    
    @objc func showSortMenu() {
        
        let sortByLastNameAction = UIAlertAction(title: Constants.sortByLastName, style: .default, handler: sortByLastName)
        let sortByAgeAction = UIAlertAction(title: Constants.sortByAge, style: .default, handler: sortByAge)
        let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil)
        
        UIAlertController.showAlert(inParent: self,
                                    preferredStyle: .actionSheet,
                                    withTitle: Constants.sortByTitle,
                                    alertMessage: Constants.pickSortingCriteria,
                                    andAlertActions: [sortByLastNameAction, sortByAgeAction, cancelAction])
    }
    
    func showSwitchToOnlineMode() {
        
        let switchBackToOnlineModeAction = UIAlertAction(title: Constants.ok, style: .default, handler: switchBackToOnlineMode)
        let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil)
        
        UIAlertController.showAlert(inParent: self,
                                    preferredStyle: .alert,
                                    withTitle: Constants.appIsonlineTitle,
                                    alertMessage: Constants.onlineMessage,
                                    andAlertActions: [switchBackToOnlineModeAction, cancelAction])
    }
    
    func showNoRecordsPrompt() {
        let switchBackToOnlineModeAction = UIAlertAction(title: Constants.ok, style: .default, handler: nil)
        
        UIAlertController.showAlert(inParent: self,
                                    preferredStyle: .alert,
                                    withTitle: Constants.noRecordsTitle,
                                    alertMessage: Constants.noRecordsMessage,
                                    andAlertActions: [switchBackToOnlineModeAction])
    }
    
    private func confirmDelete(memeber: Member) {
        
        let message = "\(Constants.deleteMmessage) \(memeber.fullName)?"
        let deleteAction = UIAlertAction(title: Constants.delete, style: .destructive, handler: handleDeleteEmployee)
        let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel, handler: handleCancelAction)
        
        UIAlertController.showAlert(inParent: self,
                                    preferredStyle: .actionSheet,
                                    withTitle: Constants.deleteTitle,
                                    alertMessage: message,
                                    andAlertActions: [deleteAction, cancelAction])
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

