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
    var context:NSManagedObjectContext?
    var titles:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songTitleLabel.text = labelstr
        if let artistUrl = imageUrl {
            print("detailItem")
            imageView.image = UIImage(contentsOfFile: artistUrl.path)
            
        }else{
            print("default")
        }
        // データ保存時と同様にcontextを定義
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var strArray:[String] = []
        for song in getData().song! {
            if ((song as! Song).title != nil){
               // if !strArray.contains(Artist.title!) {
                strArray.append((song as! Song).title!)
                //}
            }
        }
        titles = strArray
        //print(titles.count)
        tableView.reloadData()
        print(#function,titles.count)
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
        //print("Width=",imageView.frame.size.width)
    }
    
    func getData() -> Artist {
        var artists:[Artist] = []
        do {
            // CoreDataからデータをfetchしてArtistsに格納
            let fetchRequest: NSFetchRequest<Artist> = Artist.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "artistName = %@", labelstr!)
            artists = (try context?.fetch(fetchRequest))!
        } catch {
            print("Fetching Failed.")
        }
        print(#function)
        return artists[0]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(#function)
        return fetchedResultsController.sections?.count ?? 0
    }
    //Table Viewのセルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let sectionInfo = fetchedResultsController.sections![section]
        print("titles.count",titles.count)
        print(#function)
        return titles.count//sectionInfo.numberOfObjects
    }
    //セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let Artist = titles[indexPath.row]//
        cell.textLabel!.text = titles[indexPath.row]
        print(titles[indexPath.row])
        print(#function)
        return cell
    }
    
    @IBAction func add(_ sender: Any) {
        if artiststr != nil {
            // SubViewController へ遷移するために Segue を呼び出す
            performSegue(withIdentifier: "SongToEdit",sender: nil)
        }
    }
    //Cellが選択されたら
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let Artist = Artists[indexPath.row]
//        artiststr = Artist.artist
//        imageurl = Artist.image
//        print(artiststr!)
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

    
//    @IBAction func cancel(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        print(#function)
    }
    var fetchedResultsController: NSFetchedResultsController<Song> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        print(#function)
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context!, sectionNameKeyPath: nil, cacheName: "Master")
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
    var _fetchedResultsController: NSFetchedResultsController<Song>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
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
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            break
            //configureCell(tableView.cellForRow(at: indexPath!)!, withArtist: anObject as! Song)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withArtist: anObject as! Song)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
        print(#function)
    }
    //tebleViewを更新する
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        print(#function)
    }
    
    func configureCell(_ cell: UITableViewCell, withArtist Artist: Song) {
        //cell.textLabel!.text = Artist.timestamp!.description
        print(#function)
    }
}
