//
//  ViewController.swift
//  KBZ_NEWS
//
//  Created by Kyaw Ye Htun on 22/04/2022.
//

import UIKit
import NVActivityIndicatorView
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var NewsListModel  = NewsListViewModel()
    private var loadingView: NVActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "newsTableCell", bundle: nil), forCellReuseIdentifier: "newsTableCell")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.NewsListModel.getData(category: "technology")
        initViewModel()
        loadingView = view.addCenterLoadingView()
        loadingView.startAnimating()
    }
    
    func initViewModel(){
        NewsListModel.reloadTableView = {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
        NewsListModel.hideLoading = {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.loadingView.stopAnimating()
            }
        }
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.NewsListModel.getData(category: "technology")
        refreshControl.endRefreshing()
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsListModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableCell", for: indexPath) as? newsTableCell else {
           return UITableViewCell()
        }
        let cellVM = NewsListModel.getCellViewModel(at: indexPath)
        cell.lblAuthor.text = cellVM.author
        cell.lblTitle.text = cellVM.title
        cell.lblDate.text = Date.getFormattedDate(string: cellVM.publishedAt, formatter: "yyyy-MM-dd HH:mm:ss")
        if let urlimage = URL(string: cellVM.urlToImage) {
            cell.imgOfNews.af_setImage(withURL: urlimage)
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVM = NewsListModel.getCellViewModel( at: indexPath )
        let vc = UIStoryboard(name:"NewsDetailView", bundle: nil ).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        vc.newsTitle = cellVM.title
        vc.author = cellVM.author
        vc.newsDescription =  cellVM.description
        vc.url =  cellVM.url
        vc.urlToImage =  cellVM.urlToImage
        vc.publishedAt =  cellVM.publishedAt
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


