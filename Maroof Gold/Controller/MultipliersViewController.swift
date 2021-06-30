//
//  MultipliersViewController.swift
//  Maroof Gold
//
//  Created by Muhammet Taha Genç on 25.06.2021.
//

import UIKit

class MultipliersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var namesArr = ["Bilezik", "Yeni Ceyrek", "Eski Ceyrek", "Yeni Yarim", "Eski Yarim", "Yeni Tam", "Eski Tam", "Ata Lirasi", "22 Ayar Gramlik", "24 Ayar Gramlik"]
    var alisFloat : [Float] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var satisFloat : [Float] = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    let userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.tableView.frame.height / CGFloat(namesArr.count)
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PricesTableViewCell
        
        cell.name.layer.cornerRadius = 6
        cell.name.layer.masksToBounds = true
        cell.name.text = namesArr[indexPath.row]
        cell.alis.text = String(alisFloat[indexPath.row])
        cell.satis.text = String(satisFloat[indexPath.row])
        
        return cell
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        for i in 0..<namesArr.count {
            let indexPath = IndexPath(item: i, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! PricesTableViewCell
            if let newAlisFloat = Float(cell.alis.text!) {
                alisFloat[i] = newAlisFloat
            } else {
                print("An error has occured")
            }
            if let newSatisFloat = Float(cell.satis.text!) {
                satisFloat[i] = newSatisFloat
            } else {
                print("An error has occured")
            }
        }
        print(alisFloat)
        print(satisFloat)
    }
}
