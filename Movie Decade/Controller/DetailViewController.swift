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
    
    //MARK:- Instance Variables
    var movie: Movie?
    var movieGenres : [String]?
    var movieCast : [String]?
    var headerView: ImagesTopCollectionReusableView!
    var heightOfGenreCast = CGFloat(50.0)

    
    //MARK:- Overriding swift methods
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
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
        let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: heightOfGenreCast))
        horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 0, miniMarginBetweenItems: 2, miniAppearWidthOfLastItem: 20)
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
            toAdd.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 18)
            toAdd.titleLabel?.adjustsFontSizeToFitWidth = true
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
        view.addSubview(horizontalScrollView)
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: heightOfGenreCast))
        view.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
    }
        
}
////MARK:- Table View
//extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
//    //MARK: Configure TableViews
//    func configureTableViews() {
//        genresTableView.delegate = self
//        genresTableView.dataSource = self
//        genresTableView.tableFooterView = UIView()
//        genresTableView.separatorColor = UIColor(white: 0.0, alpha: 0.0)
//
//        castTableView.tableFooterView = UIView()
//        castTableView.separatorColor = UIColor(white: 0.0, alpha: 0.0)
//
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {   //1 row containing the ASHorizontalScrollView
//        return 1
//    }
//
//
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        if (tableView == genresTableView) {
//            return genresTableViewCellForRowAt(tableView, cellForRowAt: indexPath)
//        }
//        else {
//            return castTableViewCellForRowAt(tableView, cellForRowAt: indexPath)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//       return heightOfTablesCell
//    }
//
//
//    //MARK: Genres Table View Cell For Row At
//    func genresTableViewCellForRowAt(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let CellIdentifierPortrait = "CellPortrait";
//        let CellIdentifierLandscape = "CellLandscape";
//        let indentifier = self.view.frame.width > self.view.frame.height ? CellIdentifierLandscape : CellIdentifierPortrait
//        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)
//
//        if (cell == nil) {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: indentifier)
//            cell?.selectionStyle = .none
//            let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: heightOfTablesCell))
//            horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 0, miniMarginBetweenItems: 2, miniAppearWidthOfLastItem: 20)
//
//            if indexPath.row == 0 {
//                horizontalScrollView.uniformItemSize = CGSize(width: 100, height: heightOfTablesCell)
//                horizontalScrollView.setItemsMarginOnce()
//                //Displaying genres
//                let genres = movieGenres ?? []
//                for movieGenre in genres{
//                    let genre = UIButton(frame: CGRect.zero)
//                    genre.backgroundColor = UIColor(red:0.50, green:0.0, blue:0.50, alpha:1.0)
//                    genre.layer.cornerRadius = 8
//                    genre.setTitle(movieGenre, for: .normal)
//                    genre.setTitleColor(UIColor.white, for: .normal)
//                    genre.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 18)
//                    genre.titleLabel?.adjustsFontSizeToFitWidth = true
//                    horizontalScrollView.addItem(genre)
//                }
//                //If no genres
//                if genres.count == 0 {
//                    let genre = UIButton(frame: CGRect.zero)
//                    genre.backgroundColor = UIColor(red:0.50, green:0.0, blue:0.50, alpha:1.0)
//                    genre.layer.cornerRadius = 8
//                    genre.setTitle("Unknown", for: .normal)
//                    genre.setTitleColor(UIColor.white, for: .normal)
//                    genre.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 18)
//                    genre.titleLabel?.adjustsFontSizeToFitWidth = true
//                    horizontalScrollView.addItem(genre)
//                }
//            }
//            cell?.contentView.addSubview(horizontalScrollView)
//            horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
//            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
//            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0))
//            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: heightOfTablesCell))
//            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
//        }
//        else if let horizontalScrollView = cell?.contentView.subviews.first(where: { (view) -> Bool in
//            return view is ASHorizontalScrollView
//        }) as? ASHorizontalScrollView {
//            horizontalScrollView.refreshSubView() //refresh view incase orientation changes
//        }
//        return cell!
//    }
//
//    //MARK: Cast Table View Cell For Row At
//    func castTableViewCellForRowAt(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let CellIdentifierPortrait = "CellPortrait";
//        let CellIdentifierLandscape = "CellLandscape";
//        let indentifier = self.view.frame.width > self.view.frame.height ? CellIdentifierLandscape : CellIdentifierPortrait
//        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)
//
//        if (cell == nil) {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: indentifier)
//            cell?.selectionStyle = .none
//            let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: heightOfTablesCell))
//
//            horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 0, miniMarginBetweenItems: 5 , miniAppearWidthOfLastItem: 20)
//
//            if indexPath.row == 0 {
//                horizontalScrollView.uniformItemSize = CGSize(width: 100, height: heightOfTablesCell)
//                horizontalScrollView.setItemsMarginOnce()
//
//                //Displaying cast
//                let theCast = movieCast ?? []
//                for cast in theCast{
//                    let castCell = UIButton(frame: CGRect.zero)
//                    castCell.backgroundColor = UIColor(red:0.50, green:0.0, blue:0.50, alpha:1.0)
//                    castCell.layer.cornerRadius = 8
//                    castCell.setTitle(cast, for: .normal)
//                    castCell.setTitleColor(UIColor.white, for: .normal)
//                    castCell.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 18)
//                    castCell.titleLabel?.adjustsFontSizeToFitWidth = true
//                    horizontalScrollView.addItem(castCell)
//                }
//                //If no cast
//                if theCast.count == 0 {
//                    let castCell = UIButton(frame: CGRect.zero)
//                    castCell.backgroundColor = UIColor(red:0.50, green:0.0, blue:0.50, alpha:1.0)
//                    castCell.layer.cornerRadius = 8
//                    castCell.setTitle("Unknown", for: .normal)
//                    castCell.setTitleColor(UIColor.white, for: .normal)
//                    castCell.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 18)
//                    castCell.titleLabel?.adjustsFontSizeToFitWidth = true
//                    horizontalScrollView.addItem(castCell)
//                }
//            }
//            cell?.contentView.addSubview(horizontalScrollView)
//            horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
//            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
//            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0))
//            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: heightOfTablesCell))
//            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
//        }
//        else if let horizontalScrollView = cell?.contentView.subviews.first(where: { (view) -> Bool in
//            return view is ASHorizontalScrollView
//        }) as? ASHorizontalScrollView {
//            horizontalScrollView.refreshSubView() //refresh view incase orientation changes
//        }
//        return cell!
//    }
//}//Closing of extension(for tableview)


//MARK:- CollectionView
extension DetailViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        cell.backgroundColor = UIColor.black
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        let size = Int((collectionView.bounds.width - 25) / CGFloat(noOfCellsInRow))
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
            self.headerView = headerView
            configureView()
            configureGenresCast()
            return headerView
        default: print("Not Valid")
        }
        return UICollectionReusableView()
    }
    
    
} //Closing of extension for collection view.

