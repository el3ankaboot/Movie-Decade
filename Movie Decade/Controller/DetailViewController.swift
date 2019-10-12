//
//  DetailViewController.swift
//  Movie Decade
//
//  Created by Gamal Gamaleldin on 10/11/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import UIKit
import Cosmos

class DetailViewController: UIViewController {
    //Typealiasing Reponse.Movie as Movie
    typealias Movie = Response.Movie
    
    //MARK:- Outlets
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: CosmosView!
    @IBOutlet weak var movieYear: UILabel!
    
    //MARK:- Instance Variables
    var movie: Movie?
    
    //MARK:- Overriding swift methods
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        movieRating.isUserInteractionEnabled = false
        configureView()
    }

    //MARK:- Configuring the view
    func configureView() {
        movieTitle.font = UIFont(name:"Nunito-Black", size: 18)
        movieTitle.adjustsFontSizeToFitWidth = true
        movieYear.font = UIFont(name:"Nunito-Bold", size: 16)
        movieYear.textColor = UIColor(red:0.50, green:0.00, blue:0.50, alpha:1.0)
        if let movie = movie {
            movieTitle.text = movie.title
            movieRating.rating = Double(movie.rating)
            movieYear.text = String(movie.year)
        }
    }




}

