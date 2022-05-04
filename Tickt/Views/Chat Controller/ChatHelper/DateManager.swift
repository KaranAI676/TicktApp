//
//  DateManager.swift
//  Tickt
//
//  Created by Appinventiv on 13/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

let dateManager = DateManager.shared

class DateManager {
    
    private let dateFormatter: DateFormatter
    static let shared = DateManager()
    
    init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeZone = TimeZone.current
    }
    
    func string(from timestamp: Double, dateFormat: String = "hh:mm a", inMilliSeconds: Bool = true)->String{
        
        self.dateFormatter.dateFormat = dateFormat
        
        if inMilliSeconds{
            return self.dateFormatter.string(from: Date(timeIntervalSince1970: timestamp/1000))
        } else {
            return self.dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
        }
    }
    
    func stringFrom(date: Date, dateFormat: String = "dd/MM/yyyy")->String{
        self.dateFormatter.dateFormat = dateFormat
        return self.dateFormatter.string(from: date)
    }
    
    func elapsedTime(from timestamp: Double, inMilliSeconds: Bool = true)->String{
        
        if inMilliSeconds{
            return Date(timeIntervalSince1970: timestamp/1000).elapsedTime
        }else{
            return Date(timeIntervalSince1970: timestamp).elapsedTime
        }
    }
    
    /**
     returns today, yesterday and the date in string
     */
    func getNotationFor(timestamp: Double, inMilliSeconds: Bool = true, dateFormat: String = "dd/MM/yyyy")->String{
        
        var timeInterval: Double!
        
        if inMilliSeconds{
            timeInterval = timestamp/1000
        }else{
            timeInterval = timestamp
        }
        
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let numberOfdays = Date().daysFrom(date)
        
        if numberOfdays == 0{
            return "Today"
        }else if numberOfdays == 1{
            return "Yesterday"
        }else{
            return self.stringFrom(date: date)
        }
    }
    
    func getMonthName(year: Int, month: Int)->String?{
        
        let dateStr = "01-\(month)-\(year)"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let date = dateFormatter.date(from: dateStr) else {
            return nil
        }
        dateFormatter.dateFormat = "MMMM, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func stringFrom(day: Int,month: Int, year: Int, dateFormat: String = "MMM dd")->String?{
        
        self.dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.date(from: "\(day)-\(month)-\(year)"){
            self.dateFormatter.dateFormat = dateFormat
            
            return self.dateFormatter.string(from: date)
        }else{
            return nil
        }
    }
    
    func weekDay(from string: String, format: String = "yyyy-MM-dd")->String?{
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: string){
            let curDay = Calendar.current.component(.weekday, from: date)
            return dateFormatter.shortWeekdaySymbols[curDay - 1]
        }else{
            return nil
        }
    }
    
    func date(from string: String, dateformat: String)->Date?{
        dateFormatter.dateFormat = dateformat
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        return  dateFormatter.date(from: string)
    }
    
    func string(from date: Date?, dateformat: String)->String?{
        guard let date = date  else { return nil }
        dateFormatter.dateFormat = dateformat
        return dateFormatter.string(from: date)
    }
    
    func convertTo12Hours(timeString: String, isAm: Bool = false)->String?{
        let convertedDate = date(from: timeString, dateformat: "HH:mm")
        let format = isAm ? "hh:mm a" : "hh:mm"
        let convertedString = string(from: convertedDate, dateformat: format)
        return convertedString
    }
    
    func UTCToElapsedTime(inputFormat : String = "yyyy-MM-dd HH:mm:ss" , dateString : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat //"H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateString){
            return date.elapsedTime
        }else{
            return ""
        }
    }
}

extension Date{
    
    var elapsedTime: String {
        var component: Set<Calendar.Component> = [.year]
        var interval = Calendar.current.dateComponents(component, from: self, to: Date()).year ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + "Year Ago" :
                "\(interval) " + "Years Ago"
        }
        component = [.month]
        interval = Calendar.current.dateComponents(component, from: self, to: Date()).month ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + "Month Ago":
                "\(interval) " + "Months Ago"
        }
        component = [.day]
        interval = Calendar.current.dateComponents(component, from: self, to: Date()).day ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + "Day Ago" :
                "\(interval) " + "Days Ago"
        }
        component = [.hour]
        interval = Calendar.current.dateComponents(component, from: self, to: Date()).hour ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + "Hour Ago" :
                "\(interval) " + "Hours Ago"
        }
        component = [.minute]
        interval = Calendar.current.dateComponents(component, from: self, to: Date()).minute ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + "Minute Ago" :
                "\(interval) " + "Minutes Ago"
        }
        component = [.second]
        interval = Calendar.current.dateComponents(component, from: self, to: Date()).second ?? 0
        
        if interval > 1{
            return interval == 2 ? "\(interval) " + "Second Ago" :
                "\(interval) " + "Seconds Ago"
        }
        return "Just Now"
    }
}
