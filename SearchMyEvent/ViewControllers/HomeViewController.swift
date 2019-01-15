//
//  ViewController.swift
//  SearchMyEvent
//

//

import UIKit

let eventCellID = "EventsTableViewCell"
class HomeViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    var searchController = UISearchController(searchResultsController: nil)
    var eventsList = [EventModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Home"
        configureSearchController()
        self.mainTableView.register(UINib.init(nibName: eventCellID, bundle: nil), forCellReuseIdentifier: eventCellID)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureSearchController() {
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Tickets"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()        
        self.mainTableView.tableHeaderView = searchController.searchBar
    }
    
    func getSearchData(_ text:String){
        weak var weakSelf = self
        NetworkManager.sharedInstance.getEventsBy(Name: text, success: {list in
            weakSelf?.eventsList = [EventModel]()
            weakSelf?.eventsList = list
            weakSelf?.mainTableView.reloadData()
        }, error: {error in
            
        })
    }


}

extension HomeViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.eventsList = [EventModel]()
            self.mainTableView.reloadData()
            return
        }
        self.getSearchData(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
}

extension HomeViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCellID, for: indexPath) as! EventsTableViewCell
        cell.configView(model: eventsList[indexPath.row])
        return cell
    }
}

extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
            vc.model = eventsList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

