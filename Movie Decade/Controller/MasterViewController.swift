//
//  MasterViewController.swift
//  Movie Decade
//
//  Created by Gamal Gamaleldin on 10/11/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    typealias Movie = Response.Movie
    
    var detailViewController: DetailViewController? = nil
    var moviesArray = [Movie]()


    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

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


}

extension MasterViewController {
    func loadData() {
        if let path = Bundle.main.path(forResource: "movies", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                let response = try JSONDecoder().decode(Response.self, from: jsonData)
                self.moviesArray = response.movies
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}
