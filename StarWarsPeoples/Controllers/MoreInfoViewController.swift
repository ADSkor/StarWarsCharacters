//
//  MoreInfoViewController.swift
//  StarWarsPeoples
//
//  Created by Aleksandr Skorotkin on 28/05/2019.
//  Copyright © 2019 Aleksandr Skorotkin. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import RxSwift //По сути использовал только для проверки наличия данных с подходящем именем персонажа в БД. Общее понимание как пользоваться получил. Если потребуется углубление, займусь в кротчашие сроки.

class MoreInfoViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var skinLabel: UILabel!
    @IBOutlet weak var eyeLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var hairLabel: UILabel!
    
    var name : String?
    var gender : String?
    var skin : String?
    var eye : String?
    var mass : String?
    var height : String?
    var birth : String?
    var hair : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        genderLabel.text = gender
        skinLabel.text = skin
        eyeLabel.text = eye
        massLabel.text = mass
        heightLabel.text = height
        birthLabel.text = birth
        hairLabel.text = hair
        
        checkDataRx(name: name!)
    }
    
    //Upload Data to Realm by async, чтоб пользователь не ощущал загрузки(если бы было больше данных).
    func UploadData() {
        DispatchQueue.main.async {
            let item = StarObject()
            item.birth_year = self.birth ?? "N/A"
            item.eye_color = self.eye ?? "N/A"
            item.gender = self.gender ?? "N/A"
            item.hair_color = self.hair ?? "N/A"
            item.skin_color = self.skin ?? "N/A"
            item.height = self.height ?? "N/A"
            item.mass = self.mass ?? "N/A"
            item.name = self.name ?? "N/A"
            
            try! self.realm.write {
                self.realm.add(item)
            }
        }
    }
    
    //Check Data in Realm Storage with Observe
    func checkDataRx(name: String) {
        
        let items = realm.objects(StarObject.self)
        
        var tempValue = false
        
        if items.count > 0 {
            
            for i in 0...items.count - 1 {
                
                let seq = Observable.of(items[i].name)
                
                seq.subscribe(onNext: { (nameInRealm) in
                    if nameInRealm == name {
                        tempValue = true
                        print("Already presisting")
                    }
                }, onError: { (error) in
                    print("checkDataRx Error: \(error)")
                })
                
            }
            
            if tempValue == false {
                UploadData()
                print("New upload")
            }
        } else {
            UploadData()
            print("First upload")
        }
    }
}
