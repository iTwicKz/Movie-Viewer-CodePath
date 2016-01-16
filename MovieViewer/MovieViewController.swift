//
//  MovieViewController.swift
//  MovieViewer
//
//  Created by Takashi Wickes on 1/4/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import AFNetworking

class MovieViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [NSDictionary]?
    
    var filteredData: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
//        collectionView.delegate = self
        searchBar.delegate = self

//        tableView.dataSource = self
//        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
//                            self.tableView.reloadData()
                            self.filteredData = self.movies
                            self.collectionView.reloadData()
                    }
                }
        });
        task.resume()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let movies = movies {
//            return movies.count
//        }
//        else {
//            return 0
//        }
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
//        
//        let movie = movies![indexPath.row]
//        let title = movie["title"] as! String
//        let overview = movie["overview"] as!String
//        let posterPath = movie["poster_path"] as! String
//        
//        let baseUrl = "http://image.tmdb.org/t/p/w500"
//        
//        let imageUrl = NSURL(string: baseUrl + posterPath)
//                
//        cell.titleLabel.text = title
//        cell.overviewLabel.text = overview
//        cell.posterView.setImageWithURL(imageUrl!)
//        
//        
//        
//        
//        print("row\(indexPath.row)")
//        return cell
//    }

    
    @IBOutlet weak var lhslfgas: UIImageView!
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieViewCell", forIndexPath: indexPath) as! MovieViewCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as!String
        let posterPath = movie["poster_path"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWithURL(imageUrl!)
        
        
        
        
        print("row\(indexPath.row)")
        return cell
    
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredData = filteredData {
            return filteredData.count
        }
        else {
            return 0
        }
    }

    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String) {
            print("Changed")
            if searchText.isEmpty {
                filteredData = movies
            } else {
                filteredData = movies?.filter({(movie : NSDictionary) -> Bool in
            if let title = movie["title"] as? String {
                if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    
                    return  true
                } else {
                    return false
                }
            }
            return false
            })
            }
            
            collectionView.reloadData()

    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
