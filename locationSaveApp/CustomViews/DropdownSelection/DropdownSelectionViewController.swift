//
//  DropdownSelection.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 21.08.2024.
//

import Foundation
import UIKit

protocol DropdownSelectionViewControllerDelegate {
    func setSelected(item: DropdownControllerModel, searchViewModel: DropdownModel)
}

class DropdownSelectionViewController: UIViewController {
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var dropdownSelectionViewControllerDelegate: DropdownSelectionViewControllerDelegate?
    var searchViewModel: DropdownModel?
    var timer: Timer?
    
    var filterData: [DropdownControllerModel] = []
    var pageData: [DropdownControllerModel] = [] {
        didSet {
            filterData = pageData
            categoryTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let pageType = searchViewModel {
            getData(pageType: pageType)
        }
    }
    
    private func setupUI() {
        definesPresentationContext = true
        titleLabel.font = BaseFont.adjustFontSize(of: titleLabel.font, to: 18)
//        closeIcon.isUserInteractionEnabled = true
//        categoryTableView.showsVerticalScrollIndicator = false
        
        titleLabel.text = searchViewModel?.selectionText
        categoryTableView.register(UINib.init(nibName: "DropdownTableViewCell", bundle: nil), forCellReuseIdentifier: "dropdownTableViewCell")
    }
    
    func getData(pageType: DropdownModel) {
        switch pageType {
        case DropdownModel.Category:
            checkCategories()
        }
    }
    
    func checkCategories() {
        var data: [DropdownControllerModel] = []
        for item in categories {
            data.append(DropdownControllerModel(name: item.name, imageName: item.imageName))
        }
        self.pageData = data
    }
 
    @IBAction func closeIconClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension DropdownSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownTableViewCell") as! DropdownTableViewCell
        cell.configure(item: filterData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropdownSelectionViewControllerDelegate?.setSelected(item: filterData[indexPath.row], searchViewModel: searchViewModel!)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
