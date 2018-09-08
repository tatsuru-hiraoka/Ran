
//
//  MasterViewController.swift
//  Ran
//
//  Created by 平岡 建 on 2018/06/24.
//  Copyright © 2018年 平岡 建. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var artiststr:String?
    var imageurl:URL?
    //var Artists:[Artist] = []
    var artist:Artist!
    var artists:[String] = []
    //var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        // データ保存時と同様にcontextを定義
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var strArray:[String] = []
        for Artist in getData() {
            if !strArray.contains(Artist.artistName!) {
                strArray.append(Artist.artistName!)
            }
        }
        artists = strArray
        tableView.reloadData()
        print(#function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getData() -> [Artist] {
        print(#function)
        var artists:[Artist] = []
        do {
            // CoreDataからデータをfetchしてArtistsに格納
            let fetchRequest: NSFetchRequest<Artist> = Artist.fetchRequest()
            artists = (try managedObjectContext?.fetch(fetchRequest))!
        } catch {
            print("Fetching Failed.")
        }
        return artists
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print(#function)
        return fetchedResultsController.sections?.count ?? 0
        //        print(artists.count)
        //        return artists.count
    }
    //Table Viewのセルの数を指定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        let sectionInfo = fetchedResultsController.sections![section]
        //                return sectionInfo.numberOfObjects
        print(sectionInfo.numberOfObjects)
        print(artists.count)
        return artists.count
    }
    //セルに値を設定するデータソースメソッド（必須）
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print(artists)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let Artist = fetchedResultsController.object(at: indexPath)//Artists[indexPath.row]//
        let titleLabel:UILabel = cell.viewWithTag(2) as! UILabel
        titleLabel.text = artists[indexPath.row]
        //フェッチリクエストのインスタンスを生成する。
        //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
        let fetchRequest: NSFetchRequest<Artist> = Artist.fetchRequest()
        //フェッチリクエストに条件を追加する。
        fetchRequest.predicate = NSPredicate(format: "artistName = %@",artists[indexPath.row])
        
        //フェッチリクエストを実行してをオブジェクトを取得する。
        if artists.count == 0 {
            return cell
        }
        if let data = artist.photo?.image {
            photoImageView.image = UIImage(data:  data)
        }
//        do {
//            let artistarray = try managedObjectContext?.fetch(fetchRequest)
//            if let artistImage = UIImage(contentsOfFile: (artistarray![0].image?.path)!) {
//                print("detailItem")
//                let titleImage:UIImageView = cell.viewWithTag(1) as! UIImageView
//                titleImage.image = artistImage
//
//            }else{
//                print("default")
//            }
//        } catch {
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
        print(#function)
        return cell
    }
    
    //Cellが選択されたら
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let Artist = fetchedResultsController.object(at: indexPath)
        //        artiststr = Artist.artist
        //        imageurl = Artist.image
        //        print(artiststr!)
        artiststr = artists[indexPath.row]
        if artiststr != nil {
            // SubViewController へ遷移するために Segue を呼び出す
            performSegue(withIdentifier: "MasterToSongList",sender: nil)
        }
        print(#function)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            // identifierが取れなかったら処理やめる
            return
        }
        if(identifier == "MasterToSongList") {
            // segueから遷移先のNavigationControllerを取得
            let nc = segue.destination as! SongListViewController
            // 次画面のテキスト表示用のStringに、本画面のテキストフィールドのテキストを入れる
            nc.labelstr = artiststr!
            //nc.imageView.image = UIImage(contentsOfFile: (imageurl?.path)!)
            //nc.imageUrl = imageurl
        }
        print(#function)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print(#function)
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        print(#function)
    }
    
    // Cell の高さを120にする
    override func tableView(_ table: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Artist> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        print(#function)
        let fetchRequest: NSFetchRequest<Artist> = Artist.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        //        var strArray:[String] = []
        //        for Artist in getData() {
        //            if !strArray.contains(Artist.artist!) {
        //                strArray.append(Artist.artist!)
        //            }
        //        }
        //        artists = strArray
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "artistName", ascending: false)
        
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
    var _fetchedResultsController: NSFetchedResultsController<Artist>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        var strArray:[String] = []
        for Artist in getData() {
            if !strArray.contains(Artist.artistName!) {
                strArray.append(Artist.artistName!)
            }
        }
        artists = strArray
        tableView.beginUpdates()
        print(#function)
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
        print(#function)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print(#function)
        switch type {
        case .insert:
            print("insert")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        //artists.append((newIndexPath?.description)!)
        case .delete:
            print("delete")
            
            let fetchRequest: NSFetchRequest<Artist> = Artist.fetchRequest()
            //フェッチリクエストに条件を追加する。
            print("artists.count",artists.count)
            //print(indexPath?.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath!)
            fetchRequest.predicate = NSPredicate(format: "artistName = %@",(cell.textLabel?.text)!)
            // データを格納する空の配列を用意
            var results:[Artist] = []
            // 読み込み実行
            do {
                results = (try managedObjectContext?.fetch(fetchRequest))!
            }catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            for result in results {
                managedObjectContext?.delete(result)
            }
            // 保存
            do{
                try managedObjectContext?.save()
            }catch{
                
            }
            print("artists.count",artists.count)
            tableView.deleteRows(at: [indexPath!], with: .fade)
        //tableView.reloadData()
        case .update:
            print("update")
            //configureCell(tableView.cellForRow(at: indexPath!)!, withArtist: anObject as! Artist)
        case .move:
            print("move")
            configureCell(tableView.cellForRow(at: indexPath!)!, withArtist: anObject as! Artist)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func configureCell(_ cell: UITableViewCell, withArtist Artist: Artist) {
        //cell.textLabel!.text = Artist.timestamp!.description
        print(#function)
    }
    //tebleViewを更新する
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        print(#function)
    }
    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     */
    //    func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //         // In the simplest, most efficient, case, reload the table view.
    //         tableView.reloadData()
    //     }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal,
                                            title:  "編集",
                                            handler: { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
                                                success(true)
        })
        editAction.image = UIImage(named: "edit")
        editAction.backgroundColor = .blue
        
        let copyAction = UIContextualAction(style: .normal,
                                            title: "コピー",
                                            handler: { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
                                                success(true)
        })
        copyAction.image = UIImage(named: "copy")
        
        return UISwipeActionsConfiguration(actions: [editAction, copyAction])
    }
    
    ///右から左へスワイプ
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let moveAction = UIContextualAction(style: .normal,
                                            title:  "編集",
                                            handler: { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
                                                success(true)
        })
        moveAction.image = UIImage(named: "edit")
        moveAction.backgroundColor = .green
        
        let removeAction = UIContextualAction(style: .normal,
                                              title: "削除",
                                              handler: { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
                                                success(true)
        })
        removeAction.image = UIImage(named: "trash")
        removeAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [removeAction, moveAction])
    }
}


