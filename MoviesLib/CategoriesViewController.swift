//
//  CategoriesViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 17/03/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var dataSource:[Category] = []
    
    var movie: Movie!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        // Do any additional setup after loading the view.
    }
    
    func loadCategories(){
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        do{
           dataSource = try context.fetch(fetchRequest)
            table.reloadData()
        }catch{
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func add(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Adicionar Categoria", message: nil, preferredStyle: .alert)
        
        alertController.addTextField{(textField:UITextField) in
            textField.placeholder = "Nome da Categoria"
        }
        
        alertController.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: {(action: UIAlertAction) in
            let category = Category(context: self.context)
            category.name = alertController.textFields?.first?.text
            
            do {
                try self.context.save()
                self.loadCategories()
            }catch{
                print(error.localizedDescription)
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }

}

extension CategoriesViewController: UITableViewDelegate{
    
}

extension CategoriesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row].name
        
        return cell
    }
}
