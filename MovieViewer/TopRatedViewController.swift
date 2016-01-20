//
//  TopRatedViewController.swift
//  MovieViewer
//
//  Created by Takashi Wickes on 1/19/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var networkErrorView: UIView!
    
    var movies: [NSDictionary]?
    
    var filteredData: [NSDictionary]?
    
    var refreshControl: UIRefreshControl!
    
    
    
    var myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkErrorView.hidden = true
        
        collectionView.dataSource = self
        searchBar.delegate = self
        
        myActivityIndicator.color = UIColor.blackColor()
        
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        delay(2, closure: {
            self.networkRequest()
        })
        
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func networkRequest() {
        
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        //         let apiKey = "a07e22bc18f5cb106bfe4cc1f8s3ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)")
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
                else {
                    self.networkErrorView.hidden = false
                    
                }
        });
        task.resume()
        
        myActivityIndicator.stopAnimating()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Pull to Refresh
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
            self.networkRequest()
        })
    }
    
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var vc = segue.destinationViewController as! MovieDetailViewController
        var indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)
        
        
        let passMovie = movies![indexPath!.row]
        
        vc.passedMovie = passMovie
        
        
        //         Get the new view controller using segue.destinationViewController.
        //         Pass the selected object to the new view controller.
    }

}
