//
//  MoviesData.swift
//  Movie Decade
//
//  Created by Gamal Gamaleldin on 10/13/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation

class MoviesData {
    //Aliasing Reponse.Movie to Movie
    typealias Movie = Response.Movie
    
    //MARK:- Instance Variables
    var moviesArray = [Movie]()
    var moviesSearched = [Movie]()
    var yearDict = [Int:[Movie]]()
    
    //MARK:- Loading data
    init(resourceName: String) {
        if let path = Bundle.main.path(forResource: resourceName, ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                let response = try JSONDecoder().decode(Response.self, from: jsonData)
                //Add data to the movies Array
                self.moviesArray = response.movies
                //Add data to the dictionary to ease the search operation.
                for movie in moviesArray {
                    let year = movie.year
                    if(yearDict.keys.contains(year)) {
                        //Insert the movie sorted by its rating.
                        let yearsMovies = yearDict[year]
                        insertMovieSorted(movie: movie, array: yearsMovies ?? [])
                    }
                    else {
                        //Create a new key with the year and add the movie.
                        var yearsMovies : [Movie] = []
                        yearsMovies.append(movie)
                        yearDict[year] = yearsMovies
                    }
                }
            } catch {
                print(error)
            }
        }//Closing of if let
    }//Closing of loadData func
    
    //MARK:- Inserting sorted in Movies Array
    func insertMovieSorted(movie: Movie, array: [Movie]) {
        if(array.count == 5 && movie.rating<array[0].rating){return}
        let year = movie.year
        var start = 0
        var end = array.count - 1
        var myIndex = -1
        while start <= end {
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
    
    
    //MARK: Perform Search
    func handleSearch(_ year:Int) {
        moviesSearched = yearDict[year] ?? []
    }
    
}
