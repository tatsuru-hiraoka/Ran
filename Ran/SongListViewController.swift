//
//  SongListViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/07/17.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit
import CoreData

class SongListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var labelstr:String?
    var imageUrl:URL?
    var artiststr:String?
    var imageurl:URL?
    //var managedObjectContext: NSManagedObjectContext? = nil
    var events:[Event] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songTitleLabel.text = labelstr
        if let artistUrl = imageUrl {
            print("detailItem")
            imageView.image = UIImage(contentsOfFile: artistUrl.path)
            
        }else{
            print("default")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
//        self.view.addConstraints([
//            NSLayoutConstraint(item: songTitleLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.85, constant: 0),
//
//            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.35, constant: 0)
//        ])
        songTitleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 240.0).isActive = true
        print("Width=",imageView.frame.size.width)
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return fetchedResultsController.sections?.count ?? 0
//    }
    //Table Viewのセルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let sectionInfo = fetchedResultsController.sections![section]
        return events.count//sectionInfo.numberOfObjects
    }
    //セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = events[indexPath.row]//
        cell.textLabel!.text = event.title
        return cell
    }
    
    func getData() {
        // データ保存時と同様にcontextを定義
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // CoreDataからデータをfetchしてeventsに格納
            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
            events = try context.fetch(fetchRequest)
        } catch {
            print("Fetching Failed.")
        }
    }
    
    @IBAction func add(_ sender: Any) {
        if artiststr != nil {
            // SubViewController へ遷移するために Segue を呼び出す
            performSegue(withIdentifier: "SongToEdit",sender: nil)
        }
    }
    //Cellが選択されたら
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        artiststr = event.artist
        imageurl = event.image
        print(artiststr!)
//        if artiststr != nil {
//            // SubViewController へ遷移するために Segue を呼び出す
//            performSegue(withIdentifier: "SongToDetail",sender: nil)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            // identifierが取れなかったら処理やめる
            print("identifierが取れなかったら処理やめる")
            return
        }
        if(identifier == "SongToEdit") {
            // segueから遷移先のNavigationControllerを取得
            let vc = segue.destination as! EditViewController
            // 次画面のテキスト表示用のStringに、本画面のテキストフィールドのテキストを入れる
            vc.labelstr = self.labelstr
            //nc.imageView.image = UIImage(contentsOfFile: (imageurl?.path)!)
            vc.imageUrl = self.imageUrl
        }
    }

    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func edit(_ sender: Any) {
    }
    /*var fetchedResultsController: NSFetchedResultsController<Event> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    //tebleViewを更新する
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func configureCell(_ cell: UITableViewCell, withEvent event: Event) {
        //cell.textLabel!.text = event.timestamp!.description
        print("configureCell")
    }*/
}
