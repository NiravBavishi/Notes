//
//  ViewController.swift
//  Notes
//
//  Created by Nirav Bavishi on 2018-07-29.
//  Copyright © 2018 Nirav Bavishi. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addSubjectBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var subjectEntry : String!
    
    var titleArray = [NSManagedObject]()
     @NSManaged var folderDetail: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      self.title = "Subjects"
        fetchSubjects()
        setUpSearchBar()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    private func setUpSearchBar(){
        
        searchBar.delegate = self
        
        
    }
    
    // Core Data Implementation
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // Inserting in Core Data
    func storeSubjects(_ subjectName: String) {
        let context = getContext()
        let entitySubject = NSEntityDescription.entity(forEntityName: "Subjects", in: context)
        let subject = NSManagedObject(entity: entitySubject!, insertInto: context)
        
        let entityNotes = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        let note = NSManagedObject(entity: entityNotes!, insertInto: context)
        
        subject.setValue(subjectName, forKey: "subject")
        
        do {
            try context.save()
            titleArray.append(subject)
        } catch let error as NSError {
            let errorDialog = UIAlertController(title: "Error!", message: "Failed to save! \(error): \(error.userInfo)", preferredStyle: .alert)
            errorDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(errorDialog, animated: true)
        }
    }
    
    // Get values in Core Data
    func fetchSubjects() {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Subjects")
        
        do {
            titleArray = try context.fetch(fetchRequest)
        } catch let error as NSError {
            let errorDialog = UIAlertController(title: "Error!", message: "Failed to save! \(error): \(error.userInfo)", preferredStyle: .alert)
            errorDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(errorDialog, animated: true)
        }
    }
    
    // Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
       
        if searchText != ""
        {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "subject contains[c] '\(searchText)'")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subjects")
            fetchRequest.predicate = predicate
            do{
                titleArray = try context.fetch(fetchRequest) as! [NSManagedObject]
            }
            catch{
                print("Don't get searched data")
            }
        }
        else{
            fetchSubjects()
        }
        tableView.reloadData()
        

    }
    
    // Table view controller
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let subjects = titleArray[indexPath.row]
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as! MainTableCell
        cell.titileLabel.text = subjects.value(forKeyPath: "subject") as? String
        return cell
    }
    
    // Swipe to delete
    
    func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(self.titleArray[indexPath.row])
            do{
                try context.save()
                self.titleArray.removeAll()
                self.fetchSubjects()
                self.tableView.reloadData()
            }
            catch{
                print("Error while deleting")
            }
        }
    }
    
    // Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        let entry = self.titleArray[indexPath.row]
        
        print("start")
        print(entry.value(forKey: "subject") as! String)
        subjectEntry = entry.value(forKey: "subject") as! String
        print("ends")
        
        self.performSegue(withIdentifier: "subjectVC", sender: entry)
        
    }
    
    // Segue for giving entry to Note VC
    override func prepare(for segue:UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "subjectVC"{
            let ViewController = segue.destination as! SecondViewController
           // ViewController.entries = sender as? [NSManagedObject]
            //let targetController = ViewController.topViewController as! SecondViewController
            ViewController.subjectEntry = subjectEntry
            
        }
    }



    
    // Add Button action
    
    
    @IBAction func addSubjectTapped(_ sender: UIBarButtonItem) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Subject", message: "Enter Subject Name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (action) -> Void in
           // let textField = alert?.textFields![0] as! UITextField
            //print("Text field: \(textField.text)")
            let contactName = alert?.textFields?.first?.text
            self.storeSubjects(contactName!)
               // self.tableView.reloadData()
            
                self.tableView.reloadData()
            
        }))
       // alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
}



