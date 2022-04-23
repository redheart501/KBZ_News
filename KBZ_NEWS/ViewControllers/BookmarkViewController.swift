//
//  BookmarkViewController.swift
//  KBZ_NEWS
//
//  Created by Kyaw Ye Htun on 23/04/2022.
//

import Foundation
import UIKit
import CoreData

class BookmarkViewController : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var result = [NSManagedObject](){
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        NSPersistentContainer(name: "bookMarkDataModel")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "newsTableCell", bundle: nil), forCellReuseIdentifier: "newsTableCell")
        
        persistentContainer.loadPersistentStores { [weak self] persistentStoreDescription, error in
            if let error = error {
                print("Unable to Add Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self?.fetchBookmark()
            }
        }
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave,
                                               object: persistentContainer.viewContext,
                                               queue: .main) { [weak self] _ in
            self?.fetchBookmark()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchBookmark()
        self.tableView.reloadData()
    }
    
    private func fetchBookmark() {
        print(persistentContainer.viewContext)
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        
        // Perform Fetch Request
        persistentContainer.viewContext.perform {
            do {
                self.result = try self.persistentContainer.viewContext.fetch(fetchRequest)
             
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
  
}
extension BookmarkViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableCell", for: indexPath) as? newsTableCell else {
           return UITableViewCell()
        }
        let data = self.result[indexPath.row]
        cell.lblAuthor.text = data.value(forKey: "author") as? String ?? ""
        cell.lblTitle.text = data.value(forKey: "title") as? String ?? ""
        cell.lblDate.text = Date.getFormattedDate(string: data.value(forKey: "publishedAt") as? String ?? "", formatter: "yyyy-MM-dd HH:mm:ss")
        DispatchQueue.main.async {
            if let urlimage = URL(string: data.value(forKey: "image") as? String ?? "") {
                cell.imgOfNews.af_setImage(withURL: urlimage)
            }
        }
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name:"NewsDetailView", bundle: nil ).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        let data = self.result[indexPath.row]
        vc.newsTitle = data.value(forKey: "title") as? String ?? ""
        vc.author = data.value(forKey: "author") as? String ?? ""
        vc.newsDescription =  data.value(forKey: "desc") as? String ?? ""
        vc.urlToImage =  data.value(forKey: "image") as? String ?? ""
        vc.publishedAt = data.value(forKey: "publishedAt") as? String ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

    }
