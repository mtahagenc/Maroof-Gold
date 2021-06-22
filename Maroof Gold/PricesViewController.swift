//
//  PricesViewController.swift
//  Maroof Gold
//
//  Created by Muhammet Taha Genç on 22.06.2021.
//

import UIKit
import RHSideButtons

class PricesViewController: UIViewController {

    var sideButtonsView: RHSideButtons?
    var buttonsArr = [RHButtonView]()
    let triggerButton = RHTriggerButtonView(pressedImage: UIImage(named: "exit_icon")!) {
        $0.image = UIImage(named: "trigger_img")
        $0.hasShadow = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSideButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sideButtonsView?.setTriggerButtonPosition(CGPoint(x: self.view.frame.width - 85, y: self.view.frame.height - 85))
    }
    
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
}

extension PricesViewController: RHSideButtonsDataSource {

    func sideButtonsNumberOfButtons(_ sideButtons: RHSideButtons) -> Int {
        return buttonsArr.count
    }

    func sideButtons(_ sideButtons: RHSideButtons, buttonAtIndex index: Int) -> RHButtonView {
        return buttonsArr[index]
    }
}

extension PricesViewController: RHSideButtonsDelegate {

    func sideButtons(_ sideButtons: RHSideButtons, didSelectButtonAtIndex index: Int) {
        print("🍭 button index tapped: \(index)")
    }

    func sideButtons(_ sideButtons: RHSideButtons, didTriggerButtonChangeStateTo state: RHButtonState) {
        print("🍭 Trigger button")
    }
}
