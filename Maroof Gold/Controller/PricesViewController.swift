//
//  PricesViewController.swift
//  Maroof Gold
//
//  Created by Muhammet Taha Genç on 22.06.2021.
//

import UIKit
import FirebaseDatabase

class PricesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var namesArr = ["Bilezik", "Yeni Ceyrek", "Eski Ceyrek", "Yeni Yarim", "Eski Yarim", "Yeni Tam", "Eski Tam", "Ata Lirasi", "Gram (22)", "Gram (24)"]
    var alisMultipliers : [Double?] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var satisMultipliers : [Double?] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var priceData: PriceModel?
    @IBOutlet weak var tableView: UITableView!
    var ref : DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
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
    
    @objc func getData() {
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
                self.getFirebaseData()
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    
    func getFirebaseData () {
        //1. Change the database url because sometimes non US users can not fetch data from database
        ref = Database.database(url: "https://maroof-gold-default-rtdb.europe-west1.firebasedatabase.app").reference()
        
        //2. Observe the value within the child in the database
        ref.child("multipliers").observe(.value) {(snapshot) in
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
