//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ViewController: UIViewController {

    var movie: Movie!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // exerciseOne()
        // exerciseTwo()
        // exerciseThree()
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // make movie data into an array of JSON objects
                    let allMoviesData = json["feed"]["entry"].arrayValue
                    
                    // turn array of JSON objects into array of Movie structs
                    var allMovies: [Movie] = []
                    for movieData in allMoviesData {
                        let movieToAdd = Movie(json: movieData)
                        allMovies.append(movieToAdd)
                    }
                    
                    // pick a random number to display a random movie
                    let rand = Int(arc4random_uniform(24))
                    self.movie = allMovies[rand]

                    // update fields of the selected movie
                    self.loadPoster(urlString: self.movie.poster)
                    self.movieTitleLabel.text = self.movie.name
                    self.rightsOwnerLabel.text = self.movie.rightsOwner
                    self.releaseDateLabel.text = self.movie.releaseDate
                    self.priceLabel.text = String(self.movie.price)
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImage(withURL: URL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(_ sender: AnyObject) {
        // connect itunes link
        let itunesLink = self.movie.link
        UIApplication.shared.openURL(URL(string: itunesLink)!)
        
    }
    
}

