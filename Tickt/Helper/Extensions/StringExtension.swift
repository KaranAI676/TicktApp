//
//  StringExtention.swift
//  Tickt
//
//  Created by Admin on 01/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import Foundation
import UIKit

extension String {
    
    static func getString(_ message: Any?) -> String {
        guard let string = message else { return "" }

        if let strMessage = string as? String { return strMessage }

        if let doubleValue = string as? Double { return String(format: "%.2f", doubleValue) }

        if let intValue = string as? Int { return String(intValue) }

        if let value = string as? Float { return String(format: "%.2f", value) }

        if let int64Value = string as? Int64 { return String(int64Value) }
        if let int32Value = string as? Int32 { return String(int32Value) }
        if let int16Value = string as? Int16 { return String(int16Value) }

        if string is CGFloat { return "\(string)" }

        return ""
    }
    
    var trim: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
	subscript(_ range: CountableRange<Int>) -> String {
		let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
		let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
		return String(self[idx1..<idx2])
	}
	
    ///Removes all spaces from the string
    var removeSpaces:String{
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var isNumberString: Bool {
        let spaceSet = CharacterSet.decimalDigits.inverted
        return (self.rangeOfCharacter(from: spaceSet) == nil)
    }
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }

    ///Removes all HTML Tags from the string
    var removeHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    ///Returns a localized string
//    var localized:String {
//        switch AppUserDefaults.value(forKey: .selectedLanguage){
//        case "fr":
//             return self.localizedString(lang: "fr")
//        case "de":
//            return self.localizedString(lang: "de")
//        case "ar":
//            return self.localizedString(lang: "ar")
//        default:
//            return self.localizedString(lang: "en")
//        }
//    }
	
	var decodedUnicode : String {
		if let charAsInt = Int(self, radix: 16),
			let uScalar = UnicodeScalar(charAsInt) {
			return "\(uScalar)"
		}
		return ""
	}
    
    ///Returns a localized string
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func removeCharacters(char: String) -> String{
        return self.replacingOccurrences(of: char, with: "")
    }
    
    func localizedString(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    ///Removes leading and trailing white spaces from the string
    var byRemovingLeadingTrailingWhiteSpaces:String {
        
        let spaceSet = CharacterSet.whitespaces
        return self.trimmingCharacters(in: spaceSet)
    }
    
    public func trimTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
    ///Returns 'true' if the string is any (file, directory or remote etc) url otherwise returns 'false'
    var isAnyUrl:Bool{
        return (URL(string:self) != nil)
    }
    
    ///Returns the json object if the string can be converted into it, otherwise returns 'nil'
    var jsonObject:Any? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
    
    ///Returns the base64Encoded string
    var base64Encoded:String {
        
        return Data(self.utf8).base64EncodedString()
    }
    
    ///Returns the string decoded from base64Encoded string
    var base64Decoded:String? {
        
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func heightOfText(_ width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func widthOfText(_ height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    ///Returns 'true' if string contains the substring, otherwise returns 'false'
    func contains(s: String) -> Bool
    {
        return self.range(of: s) != nil ? true : false
    }
    
    ///Replaces occurances of a string with the given another string
    func replace(string: String, withString: String) -> String {
        return self.replacingOccurrences(of: string, with: withString, options: String.CompareOptions.literal, range: nil)
    }

    func toDateText(inputDateFormat: String, outputDateFormat: String, timeZone: TimeZone = TimeZone.current) -> String{
        if let date = self.toDate(dateFormat: inputDateFormat, timeZone: timeZone) {
            return date.toString(dateFormat: outputDateFormat, timeZone: timeZone)
        } else {
            return ""
        }
    }

    func checkIfValid(_ validityExression : ValidityExression) -> Bool {
        
        let regEx = validityExression.rawValue
        
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return test.evaluate(with: self)
    }
    
    func checkIfInvalid(_ validityExression : ValidityExression) -> Bool {
        
        return !self.checkIfValid(validityExression)
    }
    
    ///Capitalize the very first letter of the sentence.
    var capitalizedFirst: String {
        guard !isEmpty else { return self }
        var result = self
        let substr1 = String(self[startIndex]).uppercased()
        result.replaceSubrange(...startIndex, with: substr1)
        return result
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    var bytes : [UInt8]? {
        let length = self.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = self.startIndex
        for _ in 0..<length/2 {
            let nextIndex = self.index(index, offsetBy: 2)
            if let b = UInt8(self[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
    
    func underLinedString(color: UIColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)) -> NSAttributedString {
        return NSAttributedString(string: self, attributes:
                                    [.underlineStyle: NSUnderlineStyle.single.rawValue,
                                     NSAttributedString.Key.underlineColor: color])
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension String {
    
//    var html2AttributedString: NSAttributedString? {
//        return Data(utf8).html2AttributedString
//    }
//    var html2String: String {
//        return html2AttributedString?.string ?? self.removeHTMLTags
//    }
    
    public var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    public func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
    
    public func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
}

enum ValidityExression : String {
    
//    case userName = "^[a-zA-z]{1,}+[a-zA-z0-9!@#$%&*]{2,15}"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z\\.]{1,}"
    case mobileNumber = "^[0-9]{10,10}$"
    case userName = "^[a-zA-Z0-9]{3,50}$"
//    case password = "[A-Za-z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{8,40}"
//    case password = "("^(?=.*[0-9])"+ "(?=.*[a-z])(?=.*[A-Z])"+ "(?=.*[@#$%^&+=])"+ "(?=\\S+$).{8,40}$")"
//    case password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{8,40}"
//    Minimum 8 and Maximum 40 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
    case passRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,40}"
//    case password = "^(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,40}"
//    case name = "^[a-zA-Z0-9\\s]{1,}"
    case name = "^[a-zA-Z\\s]{1,}"
    case webUrl = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
}

extension String {
    
    var intValue: Int {
        return Int(self) ?? 0
    }
    
    var doubleValue: Double {
        let text = self.replace(string: "$", withString: "")
        return Double(text) ?? 0.0
    }
    
    var decimalValue: Decimal {
        let text = self.replace(string: "$", withString: "")
        return Decimal(string: text) ?? 0.0
    }
}

extension String {
    
//    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.amSymbol = "am"
//        dateFormatter.pmSymbol = "pm"
//        dateFormatter.dateFormat = incomingFormat
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//        let dt = dateFormatter.date(from: self)
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = outGoingFormat
//
//        return dateFormatter.string(from: dt ?? Date())
//    }
    
    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat//"yyyy-MM-dd'T'HH:mm:ss.SSSZ" //"2021-02-17T16:30:11.000Z"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: self)// create   date from string
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = outGoingFormat//"h:mm a, EEE MMM d, yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: date ?? Date())
    }
    
//    func convertToLocalStringDate() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //"2021-02-17T16:30:11.000Z"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//        let date = dateFormatter.date(from: self)// create   date from string
//        // change to a readable time format and change to local time zone
//        dateFormatter.dateFormat = "h:mm a, EEE MMM d, yyyy"
//        dateFormatter.timeZone = NSTimeZone.local
//        return dateFormatter.string(from: date ?? Date())
//    }
    
    func textSize(withFont font: UIFont, boundingSize size: CGSize) -> CGSize {
        let mutableParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: mutableParagraphStyle]
        let tempStr = NSString(string: self)
        
        let rect: CGRect = tempStr.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = ceilf(Float(rect.size.height))
        let width = ceilf(Float(rect.size.width))
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    func containsEmoji() -> Bool {
        for scalar in unicodeScalars {
            if !scalar.properties.isEmoji { continue }
            return true
        }
        return false
    }
    
    func convertToDate(dateFormat: String = Date.DateFormat.yyyyMMddTHHmmssSSSZ.rawValue) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let localDate = formatter.date(from: self)
        return localDate ?? Date()
    }
    
    func convertToDateAllowsNil(dateFormat: String = Date.DateFormat.yyyyMMddTHHmmssSSSZ.rawValue) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let localDate = formatter.date(from: self)
        return localDate
    }
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
    
    func isPasswordValid() -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    func isValidName() -> Bool {
        let nameRegEx = "^[A-Za-z][A-Za-z0-9_.]*$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    var isValidPrice: Bool {
        get {
            let regEx = "^\\d{0,6}(\\.\\d{1,2})?$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
            return predicate.evaluate(with: self)
        }
    }
    
    func isValidUrl(_ string: String?) -> Bool {
        guard let urlString = string,
            let url = URL(string: urlString)
            else { return false }

        if !UIApplication.shared.canOpenURL(url) { return false }

        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
        
    func isValidABN() ->  Bool {
        let array = compactMap{ $0.wholeNumberValue }
        let weighting = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
        if (count == 11) {
            var checksum = 0
            for index in 0..<count {
                var posValue = array[index]
                if (index == 0) {
                    posValue -= 1
                }
                checksum += posValue * weighting[index]
            }
            return checksum % 89 == 0
        }
        return false
    }
    
    func isValidPhoneNumber() -> Bool {
        let nameRegEx = "^[- +()]*[0-9][- +()0-9]*"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool { //  "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isContactNumberValid() -> Bool {
        if(self.count >= 8 && self.count <= 16){
            return true
        }
        else {
            return false
        }
    }
    
    func isLengthValid(minLength: Int , maxLength: Int) -> Bool {
        return self.count >= minLength && self.count <= maxLength
    }

    func isValidPassword() -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    func toDate(dateFormat: String, timeZone: TimeZone = .current) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = dateFormat
        return formatter.date(from: self)
    }
    
    func getFormattedPrice() -> String {
        let purePriceString = self.replace(string: ",", withString: CommonStrings.emptyString)
        let price = Double(purePriceString) ?? 0.0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        var formattedPrice = CommonStrings.dollar
        formattedPrice += String(numberFormatter.string(from: NSNumber(value: price)) ?? "")
        formattedPrice += (self.last == "." ? "." : "")
        formattedPrice += ((self.contains(s: ".0") && self.last == "0") ? ".0" : "")
        formattedPrice += ((self.contains(s: ".00") && self.last == "0") ? "0" : "")
        return formattedPrice
    }
    
    func geFormattedAccountNo(_ completeNo: Bool = false) -> String {
        return self.isEmpty ? "" : (completeNo ? "XXXX XXXX XXXX \(self)" : "XXXX \(self)")
    }
    
    func getFormattedCardName() -> String {
        let name = self.lowercased().replace(string: "card", withString: "").byRemovingLeadingTrailingWhiteSpaces
        return "\(name) Card".capitalized
    }
    
    func getFormattedReview() -> NSAttributedString {
        let textFont = self.isEmpty ? UIFont.systemFont(ofSize: 14).italics() : UIFont.systemFont(ofSize: 14)
        var text = self
        if self.isEmpty {
            text = "No comment"
        }
        return NSAttributedString(string: text, attributes: [ NSAttributedString.Key.font: textFont])
    }
    
    func setLineSpacing(_ lineSpacing: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
}

extension String {
    func getViewController() -> UIViewController? {
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            print("CFBundleName - \(appName)")
            if let viewControllerType = NSClassFromString("\(appName).\(self)") as? UIViewController.Type {
                return viewControllerType.init()
            }
        }
        return nil
    }
}


struct CommonStrings {
    let rawValue: String
    
    static var dot: String  { return "." }
    static var middleDotWithSpace: String {"  •  "}
    static var middleDotWithOneSpace: String {"  •  "}
    static var middleDot: String {"•"}
    static var emptyString: String  { return "" }
    static var whiteSpace: String  { return " " }
    static var whiteSpacex2: String  { return "  " }
    static var whiteSpacex4: String  { return "    " }
    static var percentage: String  { return "%" }
    static var nextLine: String  { return "\n" }
    static var nextLinex2: String  { return "\n\n" }
    static var forwdSlash: String { return "/" }
    static var dollar: String { return "$" }
    static var prePostSpaceWithDash: String { return " - " }
    static var dash: String { return "-" }
    static var dashx2: String { return "--" }
    static var questionMark: String { return "?" }
    static var andPercent: String { return "&" }
    static var equalsTo: String { return "=" }
    static var percent20: String { return "%20" }
    static var plusSymbol: String { return "+" }
    static var na: String { return "N/A" }
    static var comma: String { return "," }
    static var semiColon: String { return ":" }
    static var titleTextColor: String { return "titleTextColor" }
    static var attributedTitle: String { return "attributedTitle" }
    static var apostroph_s: String { return "'s" }
    static var urlHttps: String { return "http://" }
    static var urlHttp: String { return "https://" }
    static var locationName: String { return "Mellbourne" }
    static var australia: String { return "australia" }
    static var all: String { return "All" }
    static var more: String { return "More" }
    static var maxSpeclCount: Int { return 3 }
}


extension Double {
    static func getDouble(_ value: Any?) -> Double {
        guard let doubleValue = value as? Double else {
            let strDouble = String.getString(value)
            guard let doubleValueOfString = Double(strDouble) else {
                return 0.0
            }
            return doubleValueOfString
        }
        return doubleValue
    }
    
    var stringValue: String {
        return "\(self)"
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Int {
    static func getInt(_ value: Any?) -> Int {
        guard let intValue = value as? Int else {
            guard let doubleValue = value as? Double else {
                let strInt = String.getString(value)
                guard let intValueOfString = Int(strInt) else {
                    return 0
                }
                return intValueOfString
            }
            return Int(doubleValue)
        }
        return intValue
    }
}


extension String {
    // formatting text for currency textField
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$"
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
    
    func commaSeprated() -> String {
        if let value = Double(self) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            guard let formattedNumber = numberFormatter.string(from: NSNumber(value: value)) else { return "$0.0"}
            return "$" + formattedNumber
        }
        return "$0.0"
    }
    
    func numberFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.groupingSeparator = ","
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
}
