//
//  NewsDetailViewController.swift
//  KBZ_NEWS
//
//  Created by Kyaw Ye Htun on 23/04/2022.
//

import Foundation
import UIKit
import AlamofireImage
import CoreData

class NewsDetailViewController : UIViewController{
    
    @IBOutlet weak var imgOfNews: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnBookMark: UIButton!
    
    var newsTitle: String = ""
    var author: String = ""
    var newsDescription: String = ""
    var url: String = ""
    var urlToImage : String = ""
    var publishedAt : String = ""
    var isBookMark : Bool! = false
    
    
    private lazy var persistentContainer: NSPersistentContainer = {
        NSPersistentContainer(name: "bookMarkDataModel")
    }()
    
    
    
    override func viewDidLoad() {
        if let urlimage = URL(string: urlToImage) {
            imgOfNews.af_setImage(withURL: urlimage)
        }
        lblAuthor.text = author
        lblTitle.text = newsTitle
        lblDesc.text = newsDescription
        lblDate.text = Date.getFormattedDate(string: publishedAt, formatter: "yyyy-MM-dd HH:mm:ss")
        self.btnBookMark.setBackgroundImage(UIImage(systemName: isBookMark ? "bookmark.fill": "bookmark"), for: .normal)
        
        
        
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
    
    @IBAction func clickBookmark(_ sender: Any) {
        isBookMark.toggle()
        self.btnBookMark.setBackgroundImage(UIImage(systemName: isBookMark ? "bookmark.fill": "bookmark"), for: .normal)
        let managedObjectContext = persistentContainer.viewContext
      
  
    
       do {
           // Save Book to Persistent Store
           if isBookMark{
               let news = News(context: managedObjectContext)
               news.title = newsTitle
               news.desc = newsDescription
               news.image =  urlToImage
               news.author  = author
               news.publishedAt = publishedAt
            
           }else{
               let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
               fetchRequest.predicate = NSPredicate(format: "title == %@",  newsTitle)
               let objects = try managedObjectContext.fetch(fetchRequest)
                     
               for object in objects as [NSManagedObject]{
                   managedObjectContext.delete(object)
               }
                   
                   
           }
           try managedObjectContext.save()

       } catch {
           print("Unable to Save receipe, \(error)")
       }
    }
    
    private func fetchBookmark() {
        print(persistentContainer.viewContext)
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        
        // Perform Fetch Request
        persistentContainer.viewContext.perform {
            do {
                // Execute Fetch Request
//                let result = try fetchRequest.execute()
//                print(result,result.count)
                let result = try self.persistentContainer.viewContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "title") as? String ?? "")
                    let name = data.value(forKey: "title") as? String ?? ""
                    if  name == self.newsTitle {
                        self.isBookMark = true
                        self.btnBookMark.setBackgroundImage(UIImage(systemName: self.isBookMark ? "bookmark.fill": "bookmark"), for: .normal)
                    }
                  
                }
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    
}
