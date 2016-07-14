//
//  ChooseAreaViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class ChooseAreaViewController: UIViewController,UIPickerViewDelegate{
    
    let area = ["西乡塘区","兴宁区","青秀区","江南区","邕宁区","良庆区","武鸣区","横县","隆安县","马山县","上林县","宾阳县"]//count:12
    
    var delegate:dataExchangeBetweenViewsDelegate?
    
    @IBOutlet weak var chooseAreaPickerView: UIPickerView!
    
    let chooseArea = ChooseAreaModel()
    
    override func viewDidLoad() {
        chooseAreaPickerView.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func conFirmButton(sender: AnyObject?) {
        let index = chooseAreaPickerView.selectedRowInComponent(0)
        let chosenArea = chooseArea.getAreaString(index)
        delegate?.changeTitleArea(chosenArea!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.area.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.area[row]
    }
    
    
}
