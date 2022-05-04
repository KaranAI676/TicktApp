//
//  HourVC+PickerViwe.swift
//  Tickt
//
//  Created by Vijay's Macbook on 15/05/21.
//

extension HourVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 && (pickerValues[0].count - 1 == row) {
            var array = [String]()
            for i in (pickerValues[0].count - 1)..<(pickerValues[0].count - 1) + 10 {
                array.append("\(i+1)")
            }
            pickerValues[0].append(contentsOf: array)
            pickerView.reloadAllComponents()
        }
        return pickerValues[component][row]
    }
}
