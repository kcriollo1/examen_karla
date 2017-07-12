//
//  ViewController.swift
//  MyRestClient
//
//  Created by Eliseo_Martinez on 7/8/17.
//  Copyright © 2017 berufs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    let textCellIndicator = "countryCell"
    
    @IBOutlet weak var countryTableView: UITableView!
    
    //declaring my variables
    var fetchedCountry = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryTableView.dataSource = self
        
        ParseData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //- START
    //data table methods starts here
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fetchedCountry.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = countryTableView.dequeueReusableCell(withIdentifier: textCellIndicator)
        
        cell?.textLabel?.text = fetchedCountry[indexPath.row].country
        cell?.detailTextLabel?.text = fetchedCountry[indexPath.row].capital
        
        return cell!
    }
    
    //- END
    //Data table methods ends here

    func ParseData(){
        
        fetchedCountry = []
        
        //setting my url point
        let url = "https://restcountries.eu/rest/v1/all"
        
        //creating request variable
        var request = URLRequest(url: URL(string: url)!)
        
        //settingg my request method
        request.httpMethod = "GET"
        
        //building my default configuration
        let configuration = URLSessionConfiguration.default
        let sesion = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        //getting my session data by a task method
        let task = sesion.dataTask(with: request) {
            (data, response, error) in
            if error != nil{
                print("error")
            }
            else
            {
                do
                {
                    //saving all my json object in a local variable
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    
                    print("-------")
                    print("------ getting data ---------")
                    print("-------")
                    
                    print(fetchedData)
                    
                    print("-------")
                    print("------ Ending data ---------")
                    print("-------")
                    
                    //adding to country array
                    for eachFetchedCountry in fetchedData{
                        let eachCountry = eachFetchedCountry as! [String: Any]
                        
                        let country = eachCountry["region"] as! String
                        let capital = eachCountry["subregion"] as! String
                        
                        self.fetchedCountry.append(Country(country: country, capital: capital))
                    }
                    
                    
                    //printing object
                    
                    print("-------")
                    print("------ getting new data ---------")
                    print("-------")
                    
                    print(self.fetchedCountry)
                    
                    print("-------")
                    print("------ Ending new data ---------")
                    print("-------")
                    
                    self.countryTableView.reloadData()
                }
                catch
                {
                    print("Error 2")
                }
            }
        }
        
        task.resume()
    }
}


//creation country class
class Country{
    var country : String
    var capital : String
    
    init(country : String, capital: String) {
        self.country = country
        self.capital = capital
    }
}

