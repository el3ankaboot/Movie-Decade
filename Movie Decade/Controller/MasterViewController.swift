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
    var moviesArray = [Movie]()
    var moviesSearched = [Movie]()
    var yearDict = [Int:[Movie]]()
    var searchBar : UISearchBar!
    var search = false


    //MARK:- Overriding swift funcs.
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movies"

        //Loading the data from json into moviesArray and yearDict
        loadData()
        //Creating a search bar and adding it to the view
        setupSearchBar()
        //Setting the view of the table
        setupTableView()

    }
    
    //MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = true
        super.viewWillAppear(animated)
        navigationItem.titleView?.tintColor = UIColor(red:0.50, green:0.00, blue:0.50, alpha:1.0)
    }
 
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let movie = (search) ? moviesSearched[indexPath.row] : moviesArray[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = movie
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }


}//Closing of class

    // MARK: - Table View
extension MasterViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(search){
            return moviesSearched.count
        }
        else {return moviesArray.count}
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let movie = (search) ? moviesSearched[indexPath.row] : moviesArray[indexPath.row]
        cell.textLabel!.text = movie.title
        cell.textLabel?.font = UIFont(name:"Nunito-Bold", size: 18)
        cell.textLabel?.textColor = UIColor(red:0.50, green:0.00, blue:0.50, alpha:1.0)
        return cell
    }
    
    //Setup table view
    func setupTableView(){
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        
    }
}


//MARK:- Search Bar
extension MasterViewController : UISearchBarDelegate {
    //MARK: Setting up the search bar
    func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        searchBar.placeholder = "Search for movie by year"
        searchBar.keyboardType = .numberPad
        addDoneButtonOnKeyboard()
        searchBar.barTintColor = UIColor(red:0.50, green:0.00, blue:0.50, alpha:1.0)
        var textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(red:0.50, green:0.00, blue:0.50, alpha:1.0)
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
        doneToolbar.tintColor = UIColor(red:0.50, green:0.00, blue:0.50, alpha:1.0)
        
        searchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        let stringToIntYear = Int(searchBar?.text ?? "0") ?? 0
        guard isValidYear(year: stringToIntYear) else {
            showAlert(title: "Invalid Year", message: "Please enter a valid year")
            return
        }
        handleSearch(stringToIntYear)
    }
    @objc func cancelButtonAction(){
        searchBar.resignFirstResponder()
    }
    
    //MARK: Perform Search
    func handleSearch(_ year:Int) {
        searchBar.resignFirstResponder()
        
        moviesSearched = yearDict[year] ?? []
        if (moviesSearched.count > 0){
            search = true
            tableView.reloadData()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show All Movies", style: .plain, target: self, action: #selector(showAllMovies))
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
    }
    
}
//MARK:- Function to load the json data
extension MasterViewController {
    func loadData() {
        if let path = Bundle.main.path(forResource: "movies", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                let response = try JSONDecoder().decode(Response.self, from: jsonData)
                //Add data to the movies Array and reload the tableview to show the data
                self.moviesArray = response.movies
                self.tableView.reloadData()
                //Add data to the dictionary to ease the search operation.
                for movie in moviesArray {
                    let year = movie.year
                    if(yearDict.keys.contains(year)) {
                        //Insert the movie sorted by its rating.
                        let yearsMovies = yearDict[year]
                        insertMovieSorted(movie: movie, array: yearsMovies ?? [], year: year)
                    }
                    else {
                        //Create a new key with the year and add the movie.
                        var yearsMovies = [Movie]()
                        yearsMovies.append(movie)
                        yearDict[year] = yearsMovies
                    }
                }
            } catch {
                print(error)
            }
        }//Closing of if let
    }//Closing of loadData func
    
    //Inserting sorted in Movies Array
    func insertMovieSorted(movie: Movie, array: [Movie] ,year:Int) {
        var start = 0
        var end = array.count - 1
        var myIndex = -1
        while start < end {
            let index = (start + end)/2
            if(array[index].rating < movie.rating) {
                start = index+1
            }
            else if (array[index].rating > movie.rating) {
                end = index - 1
            }
            else {
                myIndex = index
                break
            }
        }//Closing of while loop
        
        if (myIndex == -1){
            myIndex = start
        }
        var newArray = array
        newArray.insert(movie, at: myIndex)
        if(newArray.count > 5) {
            newArray.removeFirst()
        }
        yearDict[year] = newArray
    }//Closing of sorted insertion func
}//Closing of extension


