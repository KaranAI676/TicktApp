//
//  IDVerficationToolTipVC.swift
//  Tickt
//
//  Created by Admin on 29/09/21.
//

import UIKit

class IDVerficationToolTipVC: BaseVC {
    
    //MARK:- IBOUTLETS
    //================
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var textMsg: UILabel!
    @IBOutlet weak var bulletText: UILabel!
    
    //MARK:- PROPERTIES
    //=================
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        initailSetUp()
    }
    
    
    //MARK:- PRIVATE FUNCTIONS
    //=======================
    private func initailSetUp(){
        textSetUP()
        
    }
    
}

//MARK:- ATTIBUTED TEXT
//=======================
extension IDVerficationToolTipVC{
    func textSetUP(){
        //textMsg.frame = CGRect(x: 0, y: 0, width: 328, height: 540)

        textMsg.backgroundColor = .white
        bulletText.backgroundColor = .white



        textMsg.textColor = UIColor(red: 0.192, green: 0.239, blue: 0.282, alpha: 1)

        textMsg.font = AppFonts.NeueHaasDisplayLight.withSize(14)

        textMsg.numberOfLines = 0
        bulletText.numberOfLines = 0
        bulletText.lineBreakMode = .byWordWrapping
        textMsg.lineBreakMode = .byWordWrapping

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineHeightMultiple = 1.17

        textMsg.attributedText = NSMutableAttributedString(string: "ID verification is required as part of Stripe ID verification process.\n\nBelow is a listing of documents that can accept as proof of identity, address, and entity.\n", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let arrayString = [
            "Passport.",
            "Driver Licence (Driver's license) - scans of front and back are required.",
            "Tasmanian Government Personal Information Card - scans of front and back are required.",
            "ImmiCard - scans of front and back are required.",
            "Proof of Age card - scans of front and back are required",
            "Australian Defence Force (ADF) identification card (Military ID) - scans of front and back are required"
        ]
        bulletText.attributedText = add(stringList: arrayString, font: AppFonts.NeueHaasDisplayLight.withSize(14), bullet: "•")
    }
    
    func add(stringList: [String],
             font: UIFont,
             bullet: String = "\u{2022}",
             indentation: CGFloat = 20,
             lineSpacing: CGFloat = 2,
             paragraphSpacing: CGFloat = 5,
             textColor: UIColor = UIColor(red: 0.192, green: 0.239, blue: 0.282, alpha: 1),
             bulletColor: UIColor = UIColor(red: 0.192, green: 0.239, blue: 0.282, alpha: 1)) -> NSAttributedString {

        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]

        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation

        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n\n"
            let attributedString = NSMutableAttributedString(string: formattedString)

            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))

            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))

            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        print(bulletList)
        return bulletList

  }
}
//MARK:- IBACTIONS
//=================
extension IDVerficationToolTipVC{
    @IBAction func backTap(_ sender: UIButton) {
        self.pop()
    }
}


/*
 //   textMsg.attributedText = NSMutableAttributedString(string: "ID verification is required as part of Stripe ID verification process.\n\nBelow is a listing of documents that can accept as proof of identity, address, and entity.\n\n•  Passport\n\n•  Driver Licence (Driver's license) - scans of front and back are required\n\n•  Photo Card - scans of front and back are required\n\n•  New South Wales Driving Instructor Licence - scans of front and back are required\n\n•  Tasmanian Government Personal Information Card - scans of front and back are required\n\n•  ImmiCard - scans of front and back are required\n\n•  Proof of Age card - scans of front and back are required\n\n•  Australian Defence Force (ADF) identification card (Military ID) - scans of front and back are required\n", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    
 */
