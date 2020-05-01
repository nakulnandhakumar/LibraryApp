//
//  BookTableViewController.swift
//  TableProject
//
//  Created by Nakul Nandhakumar on 4/30/20.
//  Copyright © 2020 Nakul Nandhakumar. All rights reserved.
//

import UIKit
import CoreData

class BookTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //var myBooks = [["book":"Harry Potter","image":"nature1","author":"J.K. Rowling"],["book":"Percy Jackson","image":"nature2","author":"Rick Riordan"],["book":"The Comet's Curse","image":"nature3","author":"Dom Testa"],["book":"Sleeping Night","image":"nature4","author":"Carol Smith"]]
    
    var books = [Books]()
    
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
    }

    func loadData(){
        let bookRequest:NSFetchRequest<Books> = Books.fetchRequest()
        
        do {
            books = try managedObjectContext.fetch(bookRequest)
            self.tableView.reloadData()
        } catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BookTableViewCell

        let booksItem = books[indexPath.row]
        
        if let booksImage = UIImage(data: booksItem.image as! Data) {
            cell.backgroundImageView.image = booksImage
        }
        
        
        cell.bookLabel.text = booksItem.bookName
        cell.authorLabel.text = booksItem.author
        
        return cell
    }
    
    
    @IBAction func addBook(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.createBooksItem(with: image)
            })
        }
        
    }
    
    
    func createBooksItem (with image:UIImage) {
        let booksItem = Books(context: managedObjectContext)
        booksItem.image = image.jpegData(compressionQuality: 0.3)
        
        let inputAlert = UIAlertController(title: "New Book", message: "Enter a book and its author", preferredStyle: .alert)
        inputAlert.addTextField { (textfield:UITextField) in textfield.placeholder = "Book"}
        inputAlert.addTextField { (textfield:UITextField) in textfield.placeholder = "Author"}
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let bookTextField = inputAlert.textFields?.first
            let authorTextField = inputAlert.textFields?.last
            
            if bookTextField?.text != "" && authorTextField?.text != "" {
                booksItem.author = authorTextField?.text
                booksItem.bookName = bookTextField?.text
            }
            
            do {
                try self.managedObjectContext.save()
                self.loadData()
            } catch {
                print("Could not save data \(error.localizedDescription)")
            }
            
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
    }
}
