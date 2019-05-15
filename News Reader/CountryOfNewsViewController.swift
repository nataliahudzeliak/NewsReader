//
//  CountryOfNewsViewController.swift
//  News Reader
//
//  Created by MacOS on 4/14/19.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit

class CountryOfNewsViewController:UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
    
    var selectedCountry = "ua"
    
    @IBOutlet weak var pickerOfNews: UIPickerView!
    let namesOfCountry = ["ua","us","pl","ae","it","lv","sk","se","lt"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return namesOfCountry[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return namesOfCountry.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = namesOfCountry[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerOfNews.delegate = self
    }
}
