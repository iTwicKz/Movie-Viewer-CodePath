//
//  MovieDetailViewController.swift
//  MovieViewer
//
//  Created by Takashi Wickes on 1/19/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!

    var passedMovie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let posterPath = passedMovie["poster_path"] as! String

        print(posterPath)
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"

        
        let imageUrl = NSURL(string: baseUrl + posterPath)
    
    detailImageView.setImageWithURL(imageUrl!)
        
        // Do any additional setup after loading the view.
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
