//
//  ViewController.swift
//  Reverse Calorie
//
//  Created by STAR on 8/4/15.
//  Copyright (c) 2015 STAR. All rights reserved.
//




import UIKit



class ViewController: UIViewController, NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate

{


    @IBOutlet weak var calorieTXT: UITextField!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var names: [String] = []
    var calories: [String] = []
    var location:[String] = []
    var rowNum:String = (String)()
     var searchResults = [String]()
    

    lazy var data = NSMutableData()
    var items = []


 //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected name : "+names[indexPath.row])
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        cell?.textLabel?.text=self.names[indexPath.row]
        cell?.detailTextLabel?.text = "Location: "+self.location[indexPath.row]
    

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
//        let cell = UITableViewCell()
//        return cell
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        if !(cell != nil) {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text=searchResults[indexPath.row]
        cell?.detailTextLabel?.text = "Calories: "+self.calories[indexPath.row]+" "+"Location: "+self.location[indexPath.row]
        
        return cell!
    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purpleColor();
        
       

    }
    func myfun(){
        let url=NSURL(string:"http://ec2-54-148-45-182.us-west-2.compute.amazonaws.com/getinfo1.php")
        let allContactsData=NSData(contentsOfURL:url!)
        
        var allContacts: AnyObject!
        do {
            allContacts = try NSJSONSerialization.JSONObjectWithData(allContactsData!, options: NSJSONReadingOptions(rawValue: 0))
        } catch _ {
            allContacts = nil
        }
        
        
        if let json = allContacts as? Array<AnyObject> {
            
            //            print(json)
            for index in 0...json.count-1 {
                
                let contact : AnyObject? = json[index]
                //                print(contact)
                
                let collection = contact! as! Dictionary<String, AnyObject>
                //                print(collection)
                //                print(collection["food_name"])
                let name : AnyObject? = collection["food_name"]
                let calorie : AnyObject? = collection["calories"]
                let locations : AnyObject? = collection["location"]
                location.append(locations as! String)
                names.append(name as! String)
                calories.append(calorie as! String)
                
            }
            
        }
        print(names)
        print(calories)
        print(location)
    
    
    
}

    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        
        print("search button clicked!")
        if (searchBar.text!.isEmpty){
            return
        }
        doSearch(searchBar.text!)
        

    }
    
    func doSearch(query:String){
        
//        mySearchBar.resignFirstResponder()
        let calorieText: String = calorieTXT.text!
        let myUrl = NSURL(string: "http:ec2-54-148-45-182.us-west-2.compute.amazonaws.com/search2.php")
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(URL: myUrl!, cachePolicy: cachePolicy, timeoutInterval: 1.0)
        request.HTTPMethod = "POST";
        // Compose a query string
        let postString = "query=\(query)";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                return
            }
            //
            //            println("response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //            println("responseString = \(responseString)")
            
            //Let’s convert response sent from a server side script to a NSDictionary object:
            
            var err: NSError?
            var myJSON: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
            self.searchResults.removeAll(keepCapacity: false)
            self.names.removeAll(keepCapacity: false)
            self.calories.removeAll(keepCapacity: false)
            self.location.removeAll(keepCapacity: false)
            if let parseJSON = myJSON as? Array<AnyObject> {
                
                
                for index in 0...parseJSON.count-1{
                    
                    
                    let contact: AnyObject? = parseJSON[index]
                    let collection = contact! as! Dictionary<String, AnyObject>
                    //                print(collection)
                    //                print(collection["food_name"])
                    let name : AnyObject? = collection["food_name"]
                    let calorie : AnyObject? = collection["calories"]
                    let locations : AnyObject? = collection["location"]
                    
                    self.searchResults.append(name as! String)
                    self.location.append(locations as! String)
                    self.names.append(name as! String)
                    self.calories.append(calorie as! String)
                }
                if (count(calorieText) > 1){
                
                    let indexCal = self.calories.indexOf(calorieText)
                
                
                
                }
            
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
               
                
                
                
            
               print(self.names)
               print(self.calories)
               print(self.searchResults.count)
                

                
                // Now we can access value of First Name by its key
                //                var firstNameValue = parseJSON["food_name"] as? String
                //                println("firstNameValue: \(firstNameValue)")
            }
            
        }


        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}