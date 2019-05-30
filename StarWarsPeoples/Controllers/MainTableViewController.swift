//
//  ViewController.swift
//  StarWarsPeoples
//
//  Created by Aleksandr Skorotkin on 28/05/2019.
//  Copyright © 2019 Aleksandr Skorotkin. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Alamofire
import SwiftyJSON
import SVProgressHUD

class MainTableViewController: UITableViewController {
    
    //Allias
    var searchName = "Star Wars"
    var arrays = Arrays()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = searchName
    }
    
    // MARK: - Buttons action
    //Search Button
    @IBAction func SearchButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: title, message: "Кого ищем?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Введите имя"
            textField.textColor = .blue
        }
        
        alert.addAction (UIAlertAction(title: "Искать", style: .default) { (alertAction) in
            let textField = alert.textFields![0]
            self.getDataFromSwapi(stringFromSearchButton: textField.text!)
            self.clearArrays()
            SVProgressHUD.show()
            if textField.text == "" {
                self.navigationItem.title = self.searchName
            } else {
                self.navigationItem.title = "SW: \(textField.text!)"
            }
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { (alertAction) in })
        
        self.present(alert, animated:true, completion: nil)
        
    }
    
    //History Button
    @IBAction func historyButtonPressed(_ sender: UIBarButtonItem) {
        
        clearArrays()
        let items = realm.objects(StarObject.self)
        
        if items.count > 0 {
            for i in 0...items.count - 1 {
                
                arrays.arrayOfBirths.append(items[i].birth_year)
                arrays.arrayOfEyes.append(items[i].eye_color)
                arrays.arrayOfGenders.append(items[i].gender)
                arrays.arrayOfHairs.append(items[i].hair_color)
                arrays.arrayOfNames.append(items[i].name)
                arrays.arrayOfSkins.append(items[i].skin_color)
                arrays.arrayOfMasses.append(items[i].mass)
                arrays.arrayOfHeights.append(items[i].height)
                
                tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrays.arrayOfNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfTabbleView", for: indexPath)
        cell.textLabel?.text = arrays.arrayOfNames[indexPath.row]
        
        return cell
    }
    
    func updateTableView(json: JSON) {
        
        for i in 0...json["results"].count - 1 {
            arrays.arrayOfNames.append(json["results"][i]["name"].stringValue)
            arrays.arrayOfEyes.append(json["results"][i]["eye_color"].stringValue)
            arrays.arrayOfHairs.append(json["results"][i]["hair_color"].stringValue)
            arrays.arrayOfSkins.append(json["results"][i]["skin_color"].stringValue)
            arrays.arrayOfBirths.append(json["results"][i]["birth_year"].stringValue)
            arrays.arrayOfMasses.append(json["results"][i]["mass"].stringValue)
            arrays.arrayOfGenders.append(json["results"][i]["gender"].stringValue)
            arrays.arrayOfHeights.append(json["results"][i]["height"].stringValue)
        }
        SVProgressHUD.dismiss()
        print(arrays.arrayOfNames)
    }
    
    // MARK: - Navigation
    
    //GoToMoreInfo View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMoreInfo" {
            
            let destinationVC = segue.destination as! MoreInfoViewController
            
            var indexPath = self.tableView.indexPathForSelectedRow
            
            destinationVC.name = arrays.arrayOfNames[((indexPath?.row)!)]
            destinationVC.birth = arrays.arrayOfBirths[((indexPath?.row)!)]
            destinationVC.eye = arrays.arrayOfEyes[((indexPath?.row)!)]
            destinationVC.hair = arrays.arrayOfHairs[((indexPath?.row)!)]
            destinationVC.gender = arrays.arrayOfGenders[((indexPath?.row)!)]
            destinationVC.height = arrays.arrayOfHeights[((indexPath?.row)!)]
            destinationVC.mass = arrays.arrayOfMasses[((indexPath?.row)!)]
            destinationVC.skin = arrays.arrayOfSkins[((indexPath?.row)!)]
            
        }
    }
    
    //MARK: - Networking
    
    func getDataFromSwapi(stringFromSearchButton: String) {
        
        let swapi = "https://swapi.co/api/people/?search="
        let allSwapiRequest = swapi + stringFromSearchButton
        
        Alamofire.request(allSwapiRequest, method: .get).responseJSON { response in
            if response.result.isSuccess {
                
                let dataJSON : JSON = JSON(response.result.value!)
                self.updateTableView(json: dataJSON)
                self.tableView.reloadData()
                
            } else {
                print("Error: \(String(describing: response.result.error))")
                SVProgressHUD.dismiss()
                self.alertWithProblems(message: "Приложение не может подключиться к серверу")
            }
            
        }
        
        
    }
    
    // MARK: - Others
    //Алерт нотификация при ошибках
    func alertWithProblems(message: String) {
        
        let alert = UIAlertController(title: title, message: "Возникли проблемы: \(message)!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default) { (alertAction) in })
        self.present(alert, animated:true, completion: nil)
        
    }
    
    //Remove all from arrays
    func clearArrays() {
        arrays.arrayOfBirths.removeAll()
        arrays.arrayOfEyes.removeAll()
        arrays.arrayOfGenders.removeAll()
        arrays.arrayOfHairs.removeAll()
        arrays.arrayOfNames.removeAll()
        arrays.arrayOfSkins.removeAll()
        arrays.arrayOfMasses.removeAll()
        arrays.arrayOfHeights.removeAll()
    }
}
