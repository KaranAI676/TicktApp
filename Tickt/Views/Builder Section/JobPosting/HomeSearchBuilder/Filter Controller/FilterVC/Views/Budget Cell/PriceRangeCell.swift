//
//  PriceRangeCell.swift
//  Tickt
//
//  Created by Vijay's Macbook on 10/09/21.
//

import UIKit

class PriceRangeCell: UITableViewCell {
        
    private var minValue: Float = 0.0001
    private var maxValue: Float = 1
    private let rangeSlider = RangeSlider(frame: CGRect.zero)
    var didChangeSliderValue: ((_ minValue: Float, _ maxValue: Float) -> Void)? = nil
    
    var payTypeButtonAction: ((_ type: PayType)->())?
    @IBOutlet weak var perhourButton: UIButton!
    @IBOutlet weak var fixedPriceButton: UIButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var sliderContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        configureCell(minValue: 1, maxValue: 10000)
        titleLabel.text = "$" + Int(1).description + " - " + "$" + Int(10000).description
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case perhourButton:
            payTypeButtonAction?(.perHour)
            perhourButton.isSelected = true
            fixedPriceButton.isSelected = false
        default:
            payTypeButtonAction?(.fixedPrice)
            perhourButton.isSelected = false
            fixedPriceButton.isSelected = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rangeSlider.frame = sliderContainerView.bounds
    }
            
    private func configureUI() {
        rangeSlider.frame = sliderContainerView.bounds
        sliderContainerView.addSubview(rangeSlider)
        rangeSlider.thumbTintColor = UIColor(hex: "#0B41A8")
        rangeSlider.trackTintColor = AppColors.appGrey
        rangeSlider.trackHighlightTintColor = UIColor(hex: "#0B41A8")        
        rangeSlider.lowerValue = Double(minValue)
        rangeSlider.upperValue = Double(maxValue)
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
    }
    
     func setPrice() {
        titleLabel.text = "$" + Int(minValue * 10000).description + "-" + "$" + Int(maxValue * 10000).description
    }
    
    func configureCell(minValue: Float, maxValue: Float) {
        print("SliderValues: ", minValue, maxValue)
        self.minValue = minValue
        self.maxValue = maxValue
        rangeSlider.lowerValue = Double(minValue)
        rangeSlider.upperValue = Double(maxValue)
    }
    
    func setPrefilledData(payType: PayType) {
        switch payType {
        case .perHour:
            perhourButton.isSelected = true
            fixedPriceButton.isSelected = false
        default:
            perhourButton.isSelected = false
            fixedPriceButton.isSelected = true
        }
    }
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        minValue = Float(rangeSlider.lowerValue)
        maxValue = Float(rangeSlider.upperValue)
        print("Values: ", minValue, maxValue)
        setPrice()
        didChangeSliderValue?(minValue * 10000, maxValue * 10000)
    }
}

