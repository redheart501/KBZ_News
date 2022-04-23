//
//  NewsListViewModel.swift
//  KBZ_NEWS
//
//  Created by Kyaw Ye Htun on 23/04/2022.
//

import Foundation
import UIKit

class NewsListViewModel{
    var reloadTableView: (()->())?
    var reloadCollectionView: (()->())?
    var showError: (()->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?

    private var cellViewModels: [DataListCellViewModel] = [DataListCellViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    func getData(category : String){
        showLoading?()
        ApiClient.getDataFromServer(category) { (success, data) in
            self.hideLoading?()
            if success {
                self.createCell(datas: data!)
                self.reloadTableView?()
            } else {
                self.showError?()
            }
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> DataListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCell(datas: NewsListModel){
        var vms = [DataListCellViewModel]()
        for data in datas.articles! {
            vms.append(DataListCellViewModel(title: data.title ?? "", author: data.author ?? "" , description: data.description ?? "" , url : data.url ?? "" ,urlToImage: data.urlToImage ?? "" , publishedAt: data.publishedAt ?? ""))
        }
        cellViewModels = vms
    }
}

struct DataListCellViewModel {
    let title: String
    let author: String
    let description: String
    let url: String
    let urlToImage : String
    let publishedAt : String
}
