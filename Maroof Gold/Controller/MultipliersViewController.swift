//
//  MultipliersViewController.swift
//  Maroof Gold
//
//  Created by Muhammet Taha Genç on 21.08.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MultipliersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Variables and Constants
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placesTextField: UITextField!
    var namesArr = ["Bilezik", "Yeni Ceyrek", "Eski Ceyrek", "Yeni Yarim", "Eski Yarim", "Yeni Tam", "Eski Tam", "Ata Lirasi", "Gram (22)", "Gram (24)"]
    var ref : DatabaseReference!
    var alisMultipliers : [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var satisMultipliers : [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    let firNames = ["bilezikAlis","bilezikSatis","yeniCeyrekAlis","yeniCeyrekSatis","eskiCeyrekAlis","eskiCeyrekSatis","yeniYarimAlis","yeniYarimSatis","eskiYarimAlis","eskiYarimSatis","yeniTamAlis","yeniTamSatis","eskiTamAlis","eskiTamSatis","ataAlis","ataSatis","22GramlikAlis","22GramlikSatis","24GramlikAlis","24GramlikSatis"]
    let userDefault = UserDefaults.standard
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
//        getFirebaseData()   
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.addKeyboardObserver()
        
    }

     override func viewWillDisappear(_ animated: Bool) {
         self.removeKeyboardObserver()
     }
    
    //MARK: - TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "multiplierCell", for: indexPath) as! MultipliersTableViewCell
        cell.name.text = namesArr[indexPath.row]
        cell.alis.text = String(alisMultipliers[indexPath.row] )
        cell.satis.text = String(satisMultipliers[indexPath.row] )
        cell.name.layer.cornerRadius = 6
        cell.name.layer.masksToBounds = true
        cell.alis.layer.cornerRadius = 6
        cell.alis.layer.masksToBounds = true
        cell.satis.layer.cornerRadius = 6
        cell.satis.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.tableView.frame.height / CGFloat(namesArr.count)
        return height
    }
    
    //MARK: - Functions
    func getFirebaseData() {
        //1. Change the database url because sometimes non US users can not fetch data from database
        ref = Database.database(url: "https://maroof-gold-default-rtdb.europe-west1.firebasedatabase.app").reference()
        
        //2. Observe the value within the child in the database
        ref.child("multipliers").observe(.value) {(snapshot) in
            //3. Check if there is a snapshot
            if let snapshotValue = snapshot.value as? [String:Any] {
                //4. Remove all the multipliers
                print(snapshotValue.values)
                self.alisMultipliers.removeAll()
                self.satisMultipliers.removeAll()
                //5. Change the data type from string to data
                //6. Append the multipliers arrays with firebase data
                self.alisMultipliers.append(snapshotValue["bilezikAlis"] as! Double)
                self.satisMultipliers.append(snapshotValue["bilezikSatis"] as! Double)
                self.alisMultipliers.append(snapshotValue["yeniCeyrekAlis"] as! Double)
                self.satisMultipliers.append(snapshotValue["yeniCeyrekSatis"] as! Double)
                self.alisMultipliers.append(snapshotValue["eskiCeyrekAlis"] as! Double)
                self.satisMultipliers.append(snapshotValue["eskiCeyrekSatis"] as! Double)
                self.alisMultipliers.append(snapshotValue["yeniYarimAlis"] as! Double)
                self.satisMultipliers.append(snapshotValue["yeniYarimSatis"] as! Double)
                self.alisMultipliers.append(snapshotValue["eskiYarimAlis"] as! Double)
                self.satisMultipliers.append(snapshotValue["eskiYarimSatis"] as! Double)
                self.alisMultipliers.append(snapshotValue["yeniTamAlis"] as! Double)
                self.satisMultipliers.append(snapshotValue["yeniTamSatis"] as! Double)
                self.alisMultipliers.append(snapshotValue["eskiTamAlis"] as! Double)
                self.satisMultipliers.append(snapshotValue["eskiTamSatis"] as! Double)
                self.alisMultipliers.append(snapshotValue["ataAlis"] as! Double)
                self.satisMultipliers.append(snapshotValue["ataSatis"] as! Double)
                self.alisMultipliers.append(snapshotValue["22GramlikAlis"] as! Double)
                self.satisMultipliers.append(snapshotValue["22GramlikSatis"] as! Double)
                self.alisMultipliers.append(snapshotValue["24GramlikAlis"] as! Double)
                self.satisMultipliers.append(snapshotValue["24GramlikSatis"] as! Double)
                //7. Finally reload the table
                self.tableView.reloadData()
                
            } else {
                print("An error occured while assigning snapshotValue to userData")
            }
        }
    }
    
    func saveDataToFirebase() {
        ref = Database.database(url: "https://maroof-gold-default-rtdb.europe-west1.firebasedatabase.app").reference()
        
        DispatchQueue.main.async {
            for i in 0..<10{
                self.ref.child("multipliers").child(self.firNames[2 * i]).setValue([self.alisMultipliers[i * 2]])
                self.ref.child("multipliers").child(self.firNames[2 * i + 1]).setValue([self.alisMultipliers[i * 2]])
            }
        }
    }

    @IBAction func doneBtn(_ sender: Any) {
        alisMultipliers.removeAll()
        satisMultipliers.removeAll()
        ref = Database.database(url: "https://maroof-gold-default-rtdb.europe-west1.firebasedatabase.app").reference()
        
        for i in 0..<namesArr.count {
            let indexPath = IndexPath(item: i, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! MultipliersTableViewCell
            
            if let newAlis = Double(cell.alis.text!) {
                alisMultipliers.append(newAlis)
                ref.child("multipliers").child(firNames[2 * i]).setValue(newAlis)
            } else {
                print("An error has occured")
            }
            if let newSatis = Double(cell.satis.text!) {
                satisMultipliers.append(newSatis)
                ref.child("multipliers").child(firNames[(2 * i) + 1]).setValue(newSatis)
            } else {
                print("An error has occured")
            }
        }
        print(alisMultipliers)
        print(satisMultipliers)
        performSegue(withIdentifier: "showPrices", sender: self)
    }
    
    @IBAction func exitBtnPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.userDefault.setValue(false, forKey: "userSignedIn")
            self.dismiss(animated: true, completion: nil)
        } catch let error {
            print(error)
        }
    }
}
