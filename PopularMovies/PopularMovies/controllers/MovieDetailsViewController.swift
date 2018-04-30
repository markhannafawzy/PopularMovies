//
//  MovieDetailsViewController.swift
//  PopularMovies
//
//  Created by Ahmed Mokhtar on 4/17/18.
//  Copyright © 2018 Ahmed Mokhtar. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import SDWebImage
class MovieDetailsViewController: UITableViewController {
    
    @IBOutlet weak var details_large_poster: UIImageView!
    @IBOutlet weak var details_small_poster: UIImageView!
    @IBOutlet weak var details_rating: UILabel!
    @IBOutlet weak var details_release_year: UILabel!
    @IBOutlet weak var details_movie_title: UILabel!
    @IBOutlet weak var details_movie_overview: UILabel!
    @IBOutlet weak var details_moview_reviews: UITextView!
    
    var movieIndex : Int!
    var arrResFromCoreData = [NSManagedObject]() //Array of ManagedObjects
    var arrTrailerRes = [[String:AnyObject]]()
    var arrReviewRes = [[String:AnyObject]]()
    var addMovieProtocol : AddMovieProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        do {
            try self.arrResFromCoreData = managedContext.fetch(request)
        } catch {
            print("error")
        }
        
        Alamofire.request(arrResFromCoreData[movieIndex].value(forKey: "reviewUrl") as! String).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.arrReviewRes = resData as! [[String:AnyObject]]
                    var authorFull : String = ""
                    var contentFull : String = ""
                    for i in 0..<self.arrReviewRes.count
                    {
                        var dictReview = self.arrReviewRes[i]
                        authorFull = authorFull + (dictReview["author"] as? String)! + "#"
                        contentFull = contentFull + (dictReview["content"] as? String)! + "#"
                    }
                    var authorArr = authorFull.split(separator: "#")
                    var contentArr = contentFull.split(separator: "#")
                    var fullReviews : String = ""
                    for i in 0..<authorArr.count
                    {
                        fullReviews = fullReviews + authorArr[i] + "\n\n" + contentArr[i] + "\n\n\n\n"
                    }
                    self.details_moview_reviews.text = fullReviews
                }
            }
        }
        
        
//        details_small_poster.image = UIImage(data: arrResFromCoreData[movieIndex].value(forKey: "posterPath2") as! Data)
        details_small_poster.sd_setImage(with: URL(string: arrResFromCoreData[movieIndex].value(forKey: "posterPath") as! String), placeholderImage: UIImage(named: "placeholder.png"))
//        details_large_poster.image = UIImage(data: arrResFromCoreData[movieIndex].value(forKey: "backdropPath2") as! Data)
        details_large_poster.sd_setImage(with: URL(string: arrResFromCoreData[movieIndex].value(forKey: "backdropPath") as! String), placeholderImage: UIImage(named: "placeholder.png"))

        details_movie_title.text = arrResFromCoreData[movieIndex].value(forKey: "originalTitle") as! String
        details_movie_overview.text = arrResFromCoreData[movieIndex].value(forKey: "overview") as! String
        details_release_year.text = arrResFromCoreData[movieIndex].value(forKey: "releaseDate") as! String
        details_rating.text = "\(arrResFromCoreData[movieIndex].value(forKey: "rating") as! NSNumber)"
        self.tabBarController?.tabBar.isHidden = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    @IBAction func addMovieToFavourites(_ sender: UIButton) {
//        var movie : NSManagedObject = NSManagedObject()
        var flag : Bool = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
        let predicate = NSPredicate(format: "id = '\(arrResFromCoreData[movieIndex].value(forKey: "id") as! Int)'")
        request.predicate = predicate
        do
        {
            let test = try managedContext.fetch(request)
            if test.count == 1
            {
                flag = true
                print("movie already exist")
            }
        }
        catch
        {
            print(error)
        }
        
        //save movie to core date here
//        var appDelegate = UIApplication.shared.delegate as! AppDelegate
//        var managedContext = appDelegate.persistentContainer.viewContext
        if flag == false
        {
            var entity = NSEntityDescription.entity(forEntityName: "FavoriteMovie" , in: managedContext)
            
            var newMovie = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            newMovie.setValue(arrResFromCoreData[movieIndex].value(forKey: "posterPath") as! String, forKey: "posterPath")
            
            newMovie.setValue(arrResFromCoreData[movieIndex].value(forKey: "backdropPath") as! String, forKey: "backdropPath")
            
            newMovie.setValue(arrResFromCoreData[movieIndex].value(forKey: "id") as! Int, forKey: "id")
            newMovie.setValue(arrResFromCoreData[movieIndex].value(forKey: "originalTitle") as! String, forKey: "originalTitle")
            newMovie.setValue(arrResFromCoreData[movieIndex].value(forKey: "overview") as! String, forKey: "overview")
            newMovie.setValue(arrResFromCoreData[movieIndex].value(forKey: "releaseDate") as! String, forKey: "releaseDate")
            
            var movieId  = arrResFromCoreData[movieIndex].value(forKey: "id") as! Int
            var reviewURL = "http://api.themoviedb.org/3/movie/\(movieId)/reviews?api_key=bd97fe04de1096c3c59c20c445de2b05"
            
            newMovie.setValue(reviewURL, forKey: "reviewUrl")
            
            newMovie.setValue(arrResFromCoreData[movieIndex].value(forKey: "rating") as! NSNumber, forKey: "rating")
            
            print ("Data added")
            do {
                try managedContext.save()
            } catch {
                print("error")
            }
//            if (self.addMovieProtocol != nil)
//            {
//                self.addMovieProtocol.addMovie(flag: true)
//            }
        }
    }
    
    @IBAction func displayTrailer(_ sender: UIButton) {
        var movieId = arrResFromCoreData[movieIndex].value(forKey: "id") as! Int
        Alamofire.request("http://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=bd97fe04de1096c3c59c20c445de2b05").responseJSON { (responseData) -> Void in
           if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)

                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.arrTrailerRes = resData as! [[String:AnyObject]]
                    var dict2 = self.arrTrailerRes[0]
                    //call youtube code
//                    var movieKey = arrResFromCoreData[movieIndex].value(forKey: "trailerKey") as! String
                    if let youtubeURL = URL(string: "youtube://\(dict2["key"] as! String)"),
                        UIApplication.shared.canOpenURL(youtubeURL) {
                        // redirect to app
                        UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
                    } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(dict2["key"] as! String)") {
                        // redirect through safari
                        UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
