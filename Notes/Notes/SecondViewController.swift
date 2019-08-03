//
//  SecondViewController.swift
//  Notes
//
//  Created by MacStudent on 2018-08-01.
//  Copyright © 2018 Nirav Bavishi. All rights reserved.
//

import UIKit
import CoreData
class SecondViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate  {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var managedObjectContext: NSManagedObjectContext!
    var entries: [NSManagedObject]!
    
    
    
    var subjectEntry : String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = "Notes List"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        setUpSearchBar()
        print("Var------------------------------------")
        print(subjectEntry)
        print("Var------------------------------------")
       
   
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        fetchRequest()
        
      
        tableView.reloadData()
    }
    
    
    
    
    
    // Fetch core data request
    
    func fetchRequest()
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
        
        do{
            let entryObjects = try managedObjectContext.fetch(fetchRequest)
            self.entries = entryObjects
            filter()
           
        }catch let error as NSError{
            print("Note not fetched\(error.userInfo)")
        }
        
   
        
        self.tableView.reloadData()
    }
    
    // Date time function
    
    func dateTime(dates: NSDate)-> String
    {
        let date = DateFormatter()
        date.dateFormat = "MM/dd/yy/ h:mm a"
        let dateSaved = date.string(from: dates as Date)
        return dateSaved
    }
    
    
    @IBAction func addNotes(_ sender: Any) {
       self.performSegue(withIdentifier: "NoteVC", sender: nil)
        
    }
    
    
    // MARK: - Table view data source
    
   func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        print("Entries Row Count")
        print(self.entries.count)
        print("Entries Row Count")
        
        return self.entries.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("IndexPath .............................")
    print(indexPath.row)
    print(entries)
    print("IndexPath .............................")
        let notes = entries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Entry", for:indexPath) as! NoteTableViewCell
 
      cell.titleLbl.text = notes.value(forKeyPath: "body") as? String
        
    let entryDate = notes.value(forKey: "date") as? NSDate
    if(entryDate != nil)
    {
    cell.createdLbl.text = dateTime(dates: ((entryDate))!)
    }
    else{
        print("date found nil")
    }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        let entry = self.entries[indexPath.row]
        self.performSegue(withIdentifier: "NoteVC", sender: entry)
        print("start")
        print(entry)
        print("ends")
        
    }
    
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let entry = self.entries[indexPath.row]
            self.managedObjectContext.delete(entry)
            self.entries.remove(at: indexPath.row)
            //self.tableView.reloadData()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            do{
                try self.managedObjectContext.save()
            }catch let error as NSError{
                print("Cannot delete")
            }
            
        }
    }
    private func setUpSearchBar(){
        
        searchBar.delegate = self
        
        
    }
    // Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchText != ""
        {
            var predicate: NSPredicate = NSPredicate()
            var predicate1: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "body contains[c] '\(searchText)'")
           // predicate1 = NSPredicate(format: "subject contains[c] '\(subjectEntry)'")
           // let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate1])
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            fetchRequest.predicate = predicate
            do{
                 //predicate1 = NSPredicate(format: "subject contains[c] '\(subjectEntry)'")
                entries = try context.fetch(fetchRequest) as! [NSManagedObject]
                filter()
            }
            catch{
                print("Don't get searched data")
            }
        }
        else{
            fetchRequest()
        }
        tableView.reloadData()
        
        
    }
    // Segue for giving entry to Note VC
    override func prepare(for segue:UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "NoteVC"{
            let notesViewController = segue.destination as! NotesViewController
            notesViewController.entry = sender as? NSManagedObject
            notesViewController.subjectEntry = self.subjectEntry
            
        }
    }
    
    // filter fun
    
    func filter()
    {
    // filter
    
    var i : Int!
    i = 0
    for entry in entries{
    print("one -------------------------------")
    print(entry.value(forKey: "subject"))
    
    print("I = \(i)")
    
    let subName = entry.value(forKey: "subject") as? String
    
    if(subName != subjectEntry){
    
    entries.remove(at: i)
    print(entries.count)
    i = i - 1
    }
    
    i = i + 1
    
    }
    
    //filter over
    }

}
