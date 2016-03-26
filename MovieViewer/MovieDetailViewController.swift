//
//  MovieDetailViewController.swift
//  MovieViewer
//
//  Created by Takashi Wickes on 1/19/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import AFNetworking
import YouTubePlayer

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!

    @IBOutlet weak var titleYearLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var trailerPreview: UIWebView!
    
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    
    @IBOutlet weak var posterView: UIImageView!
    
    var passedMovie: NSDictionary!
    
    var movieVideoID: String!
    
    @IBOutlet weak var scrollerView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var videoPlayer = YouTubePlayerView(frame: playerFrame)
        
//        scrollView = UIScrollView(frame: view.bounds)
//        scrollView.backgroundColor = UIColor.blackColor()
//        scrollView.contentSize = imageView.bounds.size
//        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        
        scrollerView.scrollEnabled = true
scrollerView.contentSize = CGSizeMake(320, 624);
        delay(2, closure: {
            self.networkRequest()
        })
        
        
        let backdropPath = passedMovie["backdrop_path"] as! String
        
       let posterPath = passedMovie["poster_path"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        
        let coverImageUrl = NSURL(string: baseUrl + backdropPath)
        
        let posterImageUrl = NSURL(string: baseUrl + posterPath)
        
        let title = passedMovie["title"] as! String
        var year = passedMovie["release_date"] as! String
        let range = year.startIndex.advancedBy(0)..<year.startIndex.advancedBy(4)
        year = year.substringWithRange(range)
        
        titleYearLabel.text = "\(title) (\(year))"
        
        overviewLabel.text = passedMovie["overview"] as! String
        
//        let rating = passedMovie["vote_average"] as! String
//        ratingsLabel.text = rating
//        
        posterView.setImageWithURL(posterImageUrl!)
    
        detailImageView.setImageWithURL(coverImageUrl!)
        
        // Do any additional setup after loading the view.
    }
    
    func networkRequest(){
        
        
        let movieID = passedMovie["id"]!
        print("movieID: \(movieID)")
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        //         let apiKey = "a07e22bc18f5cb106bfe4cc1f8s3ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)")
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
                            print("HHHHEHEHRHEHEHEHHHEHR: \(responseDictionary)")
                            
//                            self.movieVideoID = responseDictionary["results"]!["key"] as! String
                            var newDictionary = responseDictionary["results"] as! [[String : AnyObject]]
                            print(newDictionary[0]["key"])
                            self.movieVideoID = newDictionary[0]["key"] as! String
                            print("HEIRIERHIEHRIHER")

                            //                            self.tableView.reloadData()
                            print("HEYEER")
                            
//                            self.trailerPreview.allowsInlineMediaPlayback = true

                            print(self.movieVideoID!)
                            let embededHTML = "<!DOCTYPE html><html><head><style type=\"text/css\"> body { margin: 0; padding: 0; } body, html { height: 100%; width: 100%; } </style> </head> <body> <iframe id=\"player\" type=\"text/html\" width=\"100%\" height=\"100%\" src=\"http://www.youtube.com/embed/\(self.movieVideoID!)?enablejsapi=1&playsinline=1\" frameborder=\"0\"></iframe> <script> var tag = document.createElement('script'); tag.src = \"https://www.youtube.com/iframe_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubeIframeAPIReady() { player = new YT.Player('player', { events: { 'onReady': onPlayerReady } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body></html>"
//
//                               let embededHTML = "http://www.youtube.com/embed/\(self.movieVideoID!)\" width=\"360\" height=\"202\" type=\"application/x-shockwave-flash\" frameborder=\"0\"</iframe></body></html>"
                            print(embededHTML)
//                            let myURL : NSURL = NSURL(string: "https://www.youtube.com/embed/\(self.movieVideoID!)")!
                    
                            
                            self.trailerPreview.loadHTMLString(embededHTML, baseURL: NSBundle.mainBundle().bundleURL)
//                            let myURLRequest : NSURLRequest = NSURLRequest(URL: myURL)
//                            self.trailerPreview.loadRequest(myURLRequest)
                            
                            
                            
                            
                    }
                }
                else {
//                    self.networkErrorView.hidden = false
                    print("FAILURES!!")
                    
                }
        });
        task.resume()
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
