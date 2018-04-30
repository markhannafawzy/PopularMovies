//
//  FavouritesCollectionViewController.swift
//  PopularMovies
//
//  Created by Ahmed Mokhtar on 4/22/18.
//  Copyright © 2018 Ahmed Mokhtar. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
import SwiftyJSON
private let reuseIdentifier = "favouritesCollectionCell"
class FavoriteMovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var poster_image_view: UIImageView!
    @IBOutlet weak var movie_name: UILabel!
}
class FavouritesCollectionViewController: UICollectionViewController , AddMovieProtocol{

    var arrResFromCoreData = [NSManagedObject]() //Array of ManagedObjects
    var rowIndex : Int!
    var destinationVC : MovieDetailsViewController!
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
        do {
            try self.arrResFromCoreData = managedContext.fetch(request)
        } catch {
            print("error")
        }
        
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
        do {
            try self.arrResFromCoreData = managedContext.fetch(request)
        } catch {
            print("error")
        }
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addMovie(flag: Bool) {
        if flag == true
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
            do {
                try self.arrResFromCoreData = managedContext.fetch(request)
            } catch {
                print("error")
            }
            
            self.collectionView?.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrResFromCoreData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoriteMovieCollectionCell
    
        // Configure the cell
        var fullUrl = arrResFromCoreData[indexPath.row].value(forKey: "posterPath") as! String
        
        cell.poster_image_view.sd_setImage(with: URL(string: fullUrl), placeholderImage: UIImage(named: "placeholder.png"))
        cell.movie_name.text = arrResFromCoreData[indexPath.row].value(forKey: "originalTitle") as! String
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.destinationVC = segue.destination as! MovieDetailsViewController
        self.destinationVC?.addMovieProtocol = self
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.rowIndex = indexPath.row
        destinationVC.movieIndex = self.rowIndex
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
