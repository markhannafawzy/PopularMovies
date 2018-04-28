//
//  HomePageCollectionView.swift
//  PopularMovies
//
//  Created by Ahmed Mokhtar on 4/15/18.
//  Copyright © 2018 Ahmed Mokhtar. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON
import CoreData
private let reuseIdentifier = "homeCollectionCell"

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var poster_image_view: UIImageView!
    @IBOutlet weak var movie_name: UILabel!
    
}

class HomePageCollectionView: UICollectionViewController {
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    var arrTrailerRes = [[String:AnyObject]]()
    var arrReviewRes = [[String:AnyObject]]()
    var arrResFromCoreData = [NSManagedObject]() //Array of ManagedObjects
    var flag : Bool = true
    var tempImg : UIImage!
    var tempImgView : UIImageView!
    var rowIndex : Int!
    var destinationVC : MovieDetailsViewController!
    var imgData : Data!
    var imgData2 : Data!
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempImg = UIImage()
        tempImgView = UIImageView(image: tempImg)
        Alamofire.request("http://api.themoviedb.org/3/discover/movie?api_key=bd97fe04de1096c3c59c20c445de2b05").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    //print(self.arrRes)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let request = NSFetchRequest<NSManagedObject>(entityName: "Movie")
                    do {
                        try self.arrResFromCoreData = managedContext.fetch(request)
                    } catch {
                        print("error")
                    }
                    for i in 0..<self.arrResFromCoreData.count
                    {
                        managedContext.delete(self.arrResFromCoreData[i])
                    }
                    do {
                        try managedContext.save()
                    } catch {
                        print("error")
                    }
                }
                else{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let request = NSFetchRequest<NSManagedObject>(entityName: "Movie")
                    do {
                        try self.arrResFromCoreData = managedContext.fetch(request)
                    } catch {
                        print("error")
                    }
                    self.flag = false
                    self.collectionView?.reloadData()
                }
                if self.arrRes.count > 0 {
                    self.collectionView?.reloadData()
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return arrRes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionCell
        if flag
        {
            var dict = arrRes[indexPath.row]
            
            var imgUrl = dict["poster_path"] as? String
            var fullUrl = "http://image.tmdb.org/t/p/w185/"+imgUrl!
            
            cell.poster_image_view.sd_setImage(with: URL(string: fullUrl), placeholderImage: UIImage(named: "placeholder.png"))
//            cell.poster_image_view.sd_setImage(with: URL(string: fullUrl)) { (image, error, cache, url) in
//                // Your code inside completion block
//                self.imgData = UIImageJPEGRepresentation(cell.poster_image_view.image!, 1)
//            }

            //cell.poster_image_view.image = UIImage(named: "star_wars.jpg")
            cell.movie_name.text = dict["title"] as? String
            
            var img2Url = dict["backdrop_path"] as? String
            var full2Url = "http://image.tmdb.org/t/p/w185/"+img2Url!
            //tempImgView.sd_setImage(with: URL(string: full2Url), placeholderImage: UIImage(named: "placeholder.png"))
            //tempImgView.image = UIImage(named: "star_wars.jpg")
            
            var appDelegate = UIApplication.shared.delegate as! AppDelegate
            var managedContext = appDelegate.persistentContainer.viewContext
            
            var entity = NSEntityDescription.entity(forEntityName: "Movie" , in: managedContext)
            
            var newMovie = NSManagedObject(entity: entity!, insertInto: managedContext)
            
//            var imgData = UIImageJPEGRepresentation(cell.poster_image_view.image!, 1)
            newMovie.setValue(fullUrl, forKey: "posterPath")
            
            //var img2Data = UIImageJPEGRepresentation((tempImgView.image)!, 1)
            newMovie.setValue(fullUrl, forKey: "backdropPath")
            
            newMovie.setValue(dict["id"]as? Int, forKey: "id")
            newMovie.setValue(dict["title"] as? String, forKey: "originalTitle")
            newMovie.setValue(dict["overview"]as? String, forKey: "overview")
            newMovie.setValue(dict["release_date"]as? String, forKey: "releaseDate")
            
            var movieId  = dict["id"] as! Int
            var reviewURL = "http://api.themoviedb.org/3/movie/\(movieId)/reviews?api_key=bd97fe04de1096c3c59c20c445de2b05"
            
            newMovie.setValue(reviewURL, forKey: "reviewUrl")
            
            newMovie.setValue(dict["vote_average"] as? Float, forKey: "rating")
            
            print ("Data added")
            do {
                try managedContext.save()
            } catch {
                print("error")
            }
        }
        else
        {
            cell.poster_image_view.sd_setImage(with: URL(string: arrResFromCoreData[indexPath.row].value(forKey: "posterPath") as! String), placeholderImage: UIImage(named: "placeholder.png"))
            
            cell.movie_name.text = arrResFromCoreData[indexPath.row].value(forKey: "originalTitle") as! String
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.destinationVC = segue.destination as! MovieDetailsViewController
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
