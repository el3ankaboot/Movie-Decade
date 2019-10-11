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
    var yearDict = [Int:[Movie]]()


    //MARK:- Overriding swift funcs.
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Loading the data from json into moviesArray and yearDict
        loadData()
    }
    
    //MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = true
        super.viewWillAppear(animated)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let movie = moviesArray[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = movie
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let movie = moviesArray[indexPath.row]
        cell.textLabel!.text = movie.title
        return cell
    }


}//Closing of class

extension MasterViewController {
    //MARK:- Function to load the json data
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
