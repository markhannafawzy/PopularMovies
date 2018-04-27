//
//  MovieDetailsViewController.swift
//  PopularMovies
//
//  Created by Ahmed Mokhtar on 4/17/18.
//  Copyright © 2018 Ahmed Mokhtar. All rights reserved.
//

import UIKit
import CoreData
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
        details_small_poster.image = UIImage(data: arrResFromCoreData[movieIndex].value(forKey: "posterPath2") as! Data)
        details_large_poster.image = UIImage(data: arrResFromCoreData[movieIndex].value(forKey: "backdropPath2") as! Data)
        details_movie_title.text = arrResFromCoreData[movieIndex].value(forKey: "originalTitle") as! String
        details_movie_overview.text = arrResFromCoreData[movieIndex].value(forKey: "overview") as! String
        details_moview_reviews.text = arrResFromCoreData[movieIndex].value(forKey: "reviewContent") as! String
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
        //save movie to core date here
    }
    
    @IBAction func displayTrailer(_ sender: UIButton) {
        //call youtube code
        var movieKey = arrResFromCoreData[movieIndex].value(forKey: "trailerKey") as! String
        if let youtubeURL = URL(string: "youtube://\(movieKey)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(movieKey)") {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
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
