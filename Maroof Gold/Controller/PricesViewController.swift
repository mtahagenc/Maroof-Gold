//
//  PricesViewController.swift
//  Maroof Gold
//
//  Created by Muhammet Taha Genç on 22.06.2021.
//

import UIKit
import RHSideButtons

class PricesViewController: UIViewController {

    var timer  = Timer()
    var sideButtonsView: RHSideButtons?
    var buttonsArr = [RHButtonView]()
    let triggerButton = RHTriggerButtonView(pressedImage: UIImage(named: "exit_icon")!) {
        $0.image = UIImage(named: "trigger_img")
        $0.hasShadow = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSideButton()
        getData()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(getData), userInfo: nil, repeats: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sideButtonsView?.setTriggerButtonPosition(CGPoint(x: self.view.frame.width - 85, y: self.view.frame.height - 85))
    }
    
    @objc func getData() {
        let url = URL(string: "https://www.haremaltin.com/ajax/all_prices")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "X-Requested-With": "XMLHttpRequest"
        ]
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let priceData: PriceModel = try! JSONDecoder().decode(PriceModel.self, from: data)
                print(priceData.data?.ALTIN?.satis ?? "")
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    
}

extension PricesViewController: RHSideButtonsDataSource, RHSideButtonsDelegate {

    func addSideButton(){
        sideButtonsView = RHSideButtons(parentView: view, triggerButton: triggerButton)
        sideButtonsView?.delegate = self
        sideButtonsView?.dataSource = self
        //Finally you should create array of buttons which will feed our dataSource and Delegate methods :) e.g.:
        let button_1 = RHButtonView {
            $0.image = UIImage(named: "icon_1")
            $0.hasShadow = true
        }

        let button_2 = RHButtonView {
            $0.image = UIImage(named: "icon_2")
            $0.hasShadow = true
        }

        let button_3 = RHButtonView {
            $0.image = UIImage(named: "icon_3")
            $0.hasShadow = true
        }

        buttonsArr.append(button_1)
        buttonsArr.append(button_2)
        buttonsArr.append(button_3)

        //Similar as it is in TableView, now you should reload buttons with new values
        sideButtonsView?.reloadButtons()
    }
    
    func sideButtonsNumberOfButtons(_ sideButtons: RHSideButtons) -> Int {
        return buttonsArr.count
    }

    func sideButtons(_ sideButtons: RHSideButtons, buttonAtIndex index: Int) -> RHButtonView {
        return buttonsArr[index]
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, didSelectButtonAtIndex index: Int) {
        print("🍭 button index tapped: \(index)")
    }

    func sideButtons(_ sideButtons: RHSideButtons, didTriggerButtonChangeStateTo state: RHButtonState) {
        print("🍭 Trigger button")
    }
}
