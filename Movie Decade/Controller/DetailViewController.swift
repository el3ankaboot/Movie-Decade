//
//  DetailViewController.swift
//  Movie Decade
//
//  Created by Gamal Gamaleldin on 10/11/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import UIKit
import Cosmos
import ASHorizontalScrollView

class DetailViewController: UIViewController {
    //Typealiasing Reponse.Movie as Movie
    typealias Movie = Response.Movie
    
    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    //MARK:- Instance Variables
    var movie: Movie?
    var movieGenres : [String]?
    var movieCast : [String]?
    var headerView: ImagesTopCollectionReusableView!
    var imagesURLs : [ImageUrl]?
    var load = true
    var heightOfGenreCast = CGFloat(50.0)

    
    //MARK:- Overriding swift methods
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimating(activity)
        configureCollectionView()
        getImagesURLS()
    }

    //MARK:- Configuring the view
    func configureView() {
        headerView.movieRating.isUserInteractionEnabled = false
        headerView.movieTitle.font = UIFont(name:"Nunito-Black", size: 18)
        headerView.movieTitle.adjustsFontSizeToFitWidth = true
        headerView.movieYear.font = UIFont(name:"Nunito-Bold", size: 16)
        headerView.movieYear.textColor = UIColor(red:0.50, green:0.00, blue:0.50, alpha:1.0)
        if let movie = movie {
            headerView.movieTitle.text = movie.title
            headerView.movieRating.rating = Double(movie.rating)
            headerView.movieYear.text = String(movie.year)
            movieGenres = movie.genres

            self.movieCast = movie.cast
        }
    }
    
    //MARK:- Getting The Images URLs
    func getImagesURLS() {
        FlickrClient.getImagesURLs(movieTitle: movie!.title) { (urls, err) in
            guard let urls = urls else {
                self.showAlert(title: "Failed To Retrieve Images", message: "")
                return
            }
            self.imagesURLs = urls
            self.stopAnimating(self.activity)
            self.collectionView.reloadData()
        }
    }
}//Closing of class

    //MARK:- Genres and Cast Horizontal Scroll
extension DetailViewController {
    func configureGenresCast(){
        configureGenres()
        configureCast()
    }
    func configureGenres(){
        headerView.genresViewHeight.constant = heightOfGenreCast
        configure(view: headerView.genresView, source: movieGenres)
        
    }
    func configureCast(){
        headerView.castViewHeight.constant = heightOfGenreCast
        configure(view: headerView.castView, source: movieCast)
    }
    
    func configure(view: UIView , source: [String]?){
        //Setting size of the horizontal scroll view
        let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: heightOfGenreCast))
        horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 0, miniMarginBetweenItems: 10, miniAppearWidthOfLastItem: 50)
        horizontalScrollView.uniformItemSize = CGSize(width: 100, height: heightOfGenreCast)
        horizontalScrollView.setItemsMarginOnce()
        
        //Displaying genres
        let elements = source ?? []
        for element in elements{
            let toAdd = UIButton(frame: CGRect.zero)
            toAdd.backgroundColor = UIColor(red:0.50, green:0.0, blue:0.50, alpha:1.0)
            toAdd.layer.cornerRadius = 8
            toAdd.setTitle(element, for: .normal)
            toAdd.setTitleColor(UIColor.white, for: .normal)
            toAdd.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 14)
            toAdd.titleLabel?.adjustsFontSizeToFitWidth = true
            toAdd.titleLabel?.minimumScaleFactor = 0.5
            toAdd.titleLabel?.numberOfLines = 2
            toAdd.titleLabel?.lineBreakMode = .byWordWrapping
            horizontalScrollView.addItem(toAdd)
        }
        //If no genres
        if elements.count == 0 {
            let unknown = UIButton(frame: CGRect.zero)
            unknown.backgroundColor = UIColor(red:0.50, green:0.0, blue:0.50, alpha:1.0)
            unknown.layer.cornerRadius = 8
            unknown.setTitle("Unknown", for: .normal)
            unknown.setTitleColor(UIColor.white, for: .normal)
            unknown.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 18)
            unknown.titleLabel?.adjustsFontSizeToFitWidth = true
            horizontalScrollView.addItem(unknown)
        }
        //Adding the horizonal scroll view to the view and setting constraints
        view.addSubview(horizontalScrollView)
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: heightOfGenreCast))
        view.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
    }
        
}

//MARK:- CollectionView
extension DetailViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImagesCell
        let imageUrl = imagesURLs?[indexPath.row]
        cell.imageView.image = nil
        cell.shimmer.isShimmering = true
        FlickrClient.images(imageUrlString: imageUrl, cell: cell)
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
    //Displaying 2 cells in a row.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        var size = Int((collectionView.bounds.width - 25) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        // 1
        switch kind {
        // 2
        case UICollectionView.elementKindSectionHeader:
            // 3
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "headerView",
                    for: indexPath) as? ImagesTopCollectionReusableView
                else {
                    fatalError("Invalid view type")
            }
            if(load){
                self.headerView = headerView
                configureView()
                configureGenresCast()
                load = false
            }
            return headerView
        default: print("Not Valid")
        }
        return UICollectionReusableView()
    }
    
    
} //Closing of extension for collection view.

