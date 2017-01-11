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
    
    @IBOutlet weak var chooseAreaPickerView: UIPickerView!
    
    @IBOutlet weak var Background: UIImageView!
    
    private let chooseArea = ChooseAreaModel()
    
    override func viewDidLoad() {
        chooseAreaPickerView.delegate = self
        self.Background.image = UIImage(named: "ChooseAreaBackground")
        self.Background.contentMode = UIViewContentMode.scaleAspectFill
        self.navigationController?.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIPickerViewDelegate
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.area.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.area[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont(name: GLOBAL_appFont!, size: 20.0)
        label.textColor = UIColor.white
        
        label.text = self.area[row]
        
        return label
    }
    
}
