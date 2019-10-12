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
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: CosmosView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var genresTableView: UITableView!
    @IBOutlet weak var castTableView: UITableView!
    
    //MARK:- Instance Variables
    var movie: Movie?
    var movieGenres : [String]?
    var movieCast : [String]?
    var heightOfTablesCell = CGFloat(50.0)

    
    //MARK:- Overriding swift methods
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        movieRating.isUserInteractionEnabled = false
        configureTableViews()
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
            self.movieGenres = movie.genres
            self.genresTableView.reloadData()
            self.movieCast = movie.cast
            
        }
    }
}//Closing of class

//MARK:- Table View
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: Configure TableViews
    func configureTableViews() {
        genresTableView.delegate = self
        genresTableView.dataSource = self
        genresTableView.tableFooterView = UIView()
        genresTableView.separatorColor = UIColor(white: 0.0, alpha: 0.0)
        
        castTableView.tableFooterView = UIView()
        castTableView.separatorColor = UIColor(white: 0.0, alpha: 0.0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {   //1 row containing the ASHorizontalScrollView
        return 1
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (tableView == genresTableView) {
            return genresTableViewCellForRowAt(tableView, cellForRowAt: indexPath)
        }
        else {
            return castTableViewCellForRowAt(tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return heightOfTablesCell
    }
    
    
    //MARK: Genres Table View Cell For Row At
    func genresTableViewCellForRowAt(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifierPortrait = "CellPortrait";
        let CellIdentifierLandscape = "CellLandscape";
        let indentifier = self.view.frame.width > self.view.frame.height ? CellIdentifierLandscape : CellIdentifierPortrait
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: indentifier)
            cell?.selectionStyle = .none
            let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: heightOfTablesCell))
            horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 0, miniMarginBetweenItems: 2, miniAppearWidthOfLastItem: 20)
            
            if indexPath.row == 0 {
                horizontalScrollView.uniformItemSize = CGSize(width: 100, height: heightOfTablesCell)
                horizontalScrollView.setItemsMarginOnce()
                //Displaying genres
                let genres = movieGenres ?? []
                for movieGenre in genres{
                    let genre = UIButton(frame: CGRect.zero)
                    genre.backgroundColor = UIColor(red:0.50, green:0.0, blue:0.50, alpha:1.0)
                    genre.layer.cornerRadius = 8
                    genre.setTitle(movieGenre, for: .normal)
                    genre.setTitleColor(UIColor.white, for: .normal)
                    genre.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 18)
                    genre.titleLabel?.adjustsFontSizeToFitWidth = true
                    horizontalScrollView.addItem(genre)
                }
                //If no genres
                if genres.count == 0 {
                    let genre = UIButton(frame: CGRect.zero)
                    genre.backgroundColor = UIColor(red:0.50, green:0.0, blue:0.50, alpha:1.0)
                    genre.layer.cornerRadius = 8
                    genre.setTitle("Unknown", for: .normal)
                    genre.setTitleColor(UIColor.white, for: .normal)
                    genre.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 18)
                    genre.titleLabel?.adjustsFontSizeToFitWidth = true
                    horizontalScrollView.addItem(genre)
                }
            }
            cell?.contentView.addSubview(horizontalScrollView)
            horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: heightOfTablesCell))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
        }
        else if let horizontalScrollView = cell?.contentView.subviews.first(where: { (view) -> Bool in
            return view is ASHorizontalScrollView
        }) as? ASHorizontalScrollView {
            horizontalScrollView.refreshSubView() //refresh view incase orientation changes
        }
        return cell!
    }

    //MARK: Cast Table View Cell For Row At
    func castTableViewCellForRowAt(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifierPortrait = "CellPortrait";
        let CellIdentifierLandscape = "CellLandscape";
        let indentifier = self.view.frame.width > self.view.frame.height ? CellIdentifierLandscape : CellIdentifierPortrait
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: indentifier)
            cell?.selectionStyle = .none
            let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: heightOfTablesCell))
  
            horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 0, miniMarginBetweenItems: 5 , miniAppearWidthOfLastItem: 20)
            
            if indexPath.row == 0 {
                horizontalScrollView.uniformItemSize = CGSize(width: 100, height: heightOfTablesCell)
                horizontalScrollView.setItemsMarginOnce()
                
                //Displaying cast
                let theCast = movieCast ?? []
                for cast in theCast{
                    let castCell = UIButton(frame: CGRect.zero)
                    castCell.backgroundColor = UIColor(red:0.50, green:0.0, blue:0.50, alpha:1.0)
                    castCell.layer.cornerRadius = 8
                    castCell.setTitle(cast, for: .normal)
                    castCell.setTitleColor(UIColor.white, for: .normal)
                    castCell.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 18)
                    castCell.titleLabel?.adjustsFontSizeToFitWidth = true
                    horizontalScrollView.addItem(castCell)
                }
                //If no cast
                if theCast.count == 0 {
                    let castCell = UIButton(frame: CGRect.zero)
                    castCell.backgroundColor = UIColor(red:0.50, green:0.0, blue:0.50, alpha:1.0)
                    castCell.layer.cornerRadius = 8
                    castCell.setTitle("Unknown", for: .normal)
                    castCell.setTitleColor(UIColor.white, for: .normal)
                    castCell.titleLabel?.font =  UIFont(name: "Nunito-SemiBold" , size: 18)
                    castCell.titleLabel?.adjustsFontSizeToFitWidth = true
                    horizontalScrollView.addItem(castCell)
                }
            }
            cell?.contentView.addSubview(horizontalScrollView)
            horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: heightOfTablesCell))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell!.contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
        }
        else if let horizontalScrollView = cell?.contentView.subviews.first(where: { (view) -> Bool in
            return view is ASHorizontalScrollView
        }) as? ASHorizontalScrollView {
            horizontalScrollView.refreshSubView() //refresh view incase orientation changes
        }
        return cell!
    }
}//Closing of extension(for tableview)

