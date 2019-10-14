//
//  MasterViewController.swift
//  Movie Decade
//
//  Created by Gamal Gamaleldin on 10/11/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    //Aliasing Reponse.Movie to Movie
    typealias Movie = Response.Movie

    //MARK:- Instance Variables
    var detailViewController: DetailViewController? = nil
    var data : MoviesData!
    var searchBar : UISearchBar!
    var search = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate



    //MARK:- Overriding swift funcs.
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movies"
        
        //Loading the data from json into moviesArray and yearDict
        data = MoviesData(resourceName: "movies")
        //Creating a search bar and adding it to the view
        setupSearchBar()
        //Setting the view of the table
        setupTableView()
        addBottomButton()

    }
    
    //MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = true
        super.viewWillAppear(animated)
        navigationItem.titleView?.tintColor = UIColor(red:0.0, green:0.00, blue:0.27, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: appDelegate.themeColor]
    }
 
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let movie = (search) ? data.moviesSearched[indexPath.row] : data.moviesArray[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.movie = movie
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    func addBottomButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Bottom", style: .plain, target: self, action: #selector(scrollToBottom))
    }

}//Closing of class

    // MARK: - Table View
extension MasterViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(search){
            return data.moviesSearched.count
        }
        else {return data.moviesArray.count}
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let movie = (search) ? data.moviesSearched[indexPath.row] : data.moviesArray[indexPath.row]
        cell.textLabel!.text = movie.title
        cell.textLabel?.font = UIFont(name:"Nunito-Bold", size: 18)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        if(indexPath.row % 2 == 0 ){
            cell.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
            cell.textLabel?.textColor = appDelegate.themeColor
        }
        else {
            cell.backgroundColor = appDelegate.themeColor.withAlphaComponent(0.7)
            cell.textLabel?.textColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    //Setup table view
    func setupTableView(){
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
    }
    
    //Scroll to bottom of the table
    @objc func scrollToBottom(){
            let indexPath = IndexPath(row: data.moviesArray.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}


//MARK:- Search Bar
extension MasterViewController : UISearchBarDelegate {
    //MARK: Setting up the search bar
    func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        searchBar.keyboardType = .numberPad
        addDoneButtonOnKeyboard()
        searchBar.barTintColor = appDelegate.themeColor
        var textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = appDelegate.themeColor
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string:  "Search for movie by year",attributes: [NSAttributedString.Key.foregroundColor: appDelegate.themeColor.withAlphaComponent(0.5)])
    }
    
    //MARK: Adding toolbar with "Search" and "Cancel" to the numberpad to search.
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelButtonAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let search: UIBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [cancel, flexSpace, search]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        doneToolbar.tintColor = appDelegate.themeColor
        
        searchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        let stringToIntYear = Int(searchBar?.text ?? "0") ?? 0
        guard isValidYear(year: stringToIntYear) else {
            showAlert(title: "Invalid Year", message: "Please enter a year from 2009 till 2018 ")
            return
        }
        handleSearch(stringToIntYear)
    }
    @objc func cancelButtonAction(){
        searchBar.resignFirstResponder()
    }
    
    //Handle Search
    func handleSearch(_ year:Int) {
        searchBar.resignFirstResponder()
        data.handleSearch(year)
        if (data.moviesSearched.count > 0){
            search = true
            tableView.reloadData()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show All Movies", style: .plain, target: self, action: #selector(showAllMovies))
            navigationItem.leftBarButtonItem = nil
        }
        else {
            showAlert(title: "No movies found.", message: "No movies found for the year \(year)")
        }
    }
    
    //Checking if the year is a valid year
    func isValidYear(year:Int)->Bool {
        if (year >= 2009 && year < 2019) {return true}
        else{return false}
    }
    //Show All movies
    @objc func showAllMovies(){
        search = false
        tableView.reloadData()
        searchBar.text = ""
        navigationItem.rightBarButtonItem = nil
        addBottomButton()
    }
    
}



