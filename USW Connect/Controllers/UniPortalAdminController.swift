//
//  UniPortalAdminController.swift
//  USW Connect
//
//  Created by ekincare on 15/03/24.
//

import UIKit

class UniPortalAdminController: UIViewController {
    
    var viewModal = UniPortalAdminViewModal()
    
    let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)

    @IBOutlet weak var syncButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        syncButton.layer.cornerRadius = 6.0
        registerTableViewCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reuseForCreateArray()
    }
    
    @IBAction func syncClicked(_ sender: Any) {
        reuseForCreateArray()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addFormClicked(_ sender: Any) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "UniPortalController") as! UniPortalController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func registerTableViewCells() {
        tableView.register(UINib(nibName: "UniPortalAdminCell", bundle: nil), forCellReuseIdentifier: "UniPortalAdminCell")
        tableView.register(UINib(nibName: "UniPortalHeader", bundle: nil), forCellReuseIdentifier: "UniPortalHeader")
    }
    
    func reuseForCreateArray() {
        viewModal.createDataArray {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

extension UniPortalAdminController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if viewModal.checkInternetWhileSubmit(controller: self) {
                tableView.beginUpdates()
                ServiceHelper.deleteDataFromDatabase(id: viewModal.dataArray[indexPath.row].data["id"] as! Int) { done in
                    self.reuseForCreateArray()
                }
                tableView.endUpdates()
            }
        }
    }
}

extension UniPortalAdminController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModal.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = viewModal.dataArray[indexPath.row]
        switch rowData.cellType {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UniPortalHeader", for: indexPath) as! UniPortalHeader
            cell.headerLabel.text = rowData.header
            return cell
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UniPortalAdminCell", for: indexPath) as! UniPortalAdminCell
            cell.setData(data: rowData.data)
            return cell
        default :
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
}
