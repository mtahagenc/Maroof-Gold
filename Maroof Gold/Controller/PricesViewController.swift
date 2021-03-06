//
//  PricesViewController.swift
//  Maroof Gold
//
//  Created by Muhammet Taha Genç on 22.06.2021.
//

import UIKit
import FirebaseDatabase

class PricesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placesDropDown: UITextField!
    let userDefault = UserDefaults.standard
    var namesArr = ["Bilezik", "Yeni Ceyrek", "Eski Ceyrek", "Yeni Yarim", "Eski Yarim", "Yeni Tam", "Eski Tam", "Ata Lirasi", "Gram (22)", "Gram (24)"]
    var alisMultipliers : [Double?] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var satisMultipliers : [Double?] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var places : [String?] = []
    var priceData: PriceModel?
    //1. Change the database url because sometimes non US users can not fetch data from database
    var ref = Database.database(url: "https://maroof-gold-default-rtdb.europe-west1.firebasedatabase.app").reference()
    var selectedPlace: String?
    @IBAction func goToSıgnInBtn(_ sender: UIButton) {
        if userDefault.bool(forKey: "userSignedIn") == true {
            performSegue(withIdentifier: "showMultipliers", sender: self)
        } else {
            performSegue(withIdentifier: "showSignIn", sender: self)
        }
    }
    

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        getURLData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        createPickerView()
        dismissPickerView()
        getPlaces()
        getFirebaseData(place: "Gop")
    }
    
    //MARK: UIPickerView Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return places.count //number of dropdown items
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return places[row] //dropdown item
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPlace = places[row] // selected item
        placesDropDown.text = selectedPlace ?? "Sultangazi"
        getFirebaseData(place: selectedPlace ?? "Sultangazi")
    }
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        placesDropDown.inputView = pickerView
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        placesDropDown.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
    }

    //MARK: TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.tableView.frame.height / CGFloat(namesArr.count)
        
        return height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PricesTableViewCell
        cell.name.layer.cornerRadius = 6
        cell.name.layer.masksToBounds = true
        cell.alis.layer.cornerRadius = 6
        cell.alis.layer.masksToBounds = true
        cell.satis.layer.cornerRadius = 6
        cell.satis.layer.masksToBounds = true
        
        let roundedAlis = Double(round(alisMultipliers[indexPath.row] ?? 0))
        let roundedSatis = Double(round(satisMultipliers[indexPath.row] ?? 0))
        
        cell.name.text = namesArr[indexPath.row]
        cell.alis.text = String(roundedAlis)
        cell.satis.text = String(roundedSatis)
        cell.backgroundColor = .white
        cell.alis.layer.cornerRadius = 5
        
        return cell
    }
    
    //MARK: - Functions
    @objc func getURLData() {
        //We are getting the base gold prices from a website to calculate the product's prices.
        
        let url = URL(string: "https://www.haremaltin.com/ajax/all_prices")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "X-Requested-With": "XMLHttpRequest"
        ]
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                self.priceData = try! JSONDecoder().decode(PriceModel.self, from: data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    func getPlaces() {
        ref.child("places").observe(.value) { (snapShot) in
            for child in snapShot.children{
                let data = child as! DataSnapshot
                self.places.append(data.key)
            }
        }
    }
    func getFirebaseData (place: String) {
        //2. Observe the value within the child in the database
        ref.child("places").child(place).child("multipliers").observe(.value) {(snapshot) in
            //3. Check if there is a snapshot
            if let snapshotValue = snapshot.value as? [String:Any] {
                //4. Remove all the multipliers
                self.alisMultipliers.removeAll()
                self.satisMultipliers.removeAll()
                //5. Change the data type from string to data
                let alis = (Double((self.priceData?.data?.ALTIN?.alis) ?? String(0))!)
                let satis = (Double((self.priceData?.data?.ALTIN?.satis) ?? String(0))!)
                //6. Append the multipliers arrays with new data that we created
                self.alisMultipliers.append((snapshotValue["bilezikAlis"] as! Double) * alis)
                self.satisMultipliers.append((snapshotValue["bilezikSatis"] as! Double) * satis)
                self.alisMultipliers.append((snapshotValue["yeniCeyrekAlis"] as! Double) * alis)
                self.satisMultipliers.append((snapshotValue["yeniCeyrekSatis"] as! Double) * satis)
                self.alisMultipliers.append((snapshotValue["eskiCeyrekAlis"] as! Double) * alis)
                self.satisMultipliers.append((snapshotValue["eskiCeyrekSatis"] as! Double) * satis)
                self.alisMultipliers.append((snapshotValue["yeniYarimAlis"] as! Double) * alis)
                self.satisMultipliers.append((snapshotValue["yeniYarimSatis"] as! Double) * satis)
                self.alisMultipliers.append((snapshotValue["eskiYarimAlis"] as! Double) * alis)
                self.satisMultipliers.append((snapshotValue["eskiYarimSatis"] as! Double) * satis)
                self.alisMultipliers.append((snapshotValue["yeniTamAlis"] as! Double) * alis)
                self.satisMultipliers.append((snapshotValue["yeniTamSatis"] as! Double) * satis)
                self.alisMultipliers.append((snapshotValue["eskiTamAlis"] as! Double) * alis)
                self.satisMultipliers.append((snapshotValue["eskiTamSatis"] as! Double) * satis)
                self.alisMultipliers.append((snapshotValue["ataAlis"] as! Double) * alis)
                self.satisMultipliers.append((snapshotValue["ataSatis"] as! Double) * satis)
                self.alisMultipliers.append((snapshotValue["22GramlikAlis"] as! Double) * alis)
                self.satisMultipliers.append((snapshotValue["22GramlikSatis"] as! Double) * satis)
                self.alisMultipliers.append((snapshotValue["24GramlikAlis"] as! Double) * alis)
                self.satisMultipliers.append((snapshotValue["24GramlikSatis"] as! Double) * satis)
                //7. Finally reload the table
                self.tableView.reloadData()

            } else {
                print("An error occured while assigning snapshotValue to userData")
            }
        }
    }
}
