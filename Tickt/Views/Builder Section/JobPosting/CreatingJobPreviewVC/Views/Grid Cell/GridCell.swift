//
//  GridCell.swift
//  Tickt
//
//  Created by Admin on 27/04/21.
//

class GridCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: CustomRomanLabel!
    @IBOutlet weak var daysLabel: CustomRomanLabel!
    @IBOutlet weak var priceLabel: CustomRomanLabel!
    @IBOutlet weak var addressLabel: CustomRomanLabel!
    
    var isOnGoingJob = false
    
    var job: JobDetailsData? {
        didSet {
            let time = job?.time ?? ""
            if !time.isEmpty {
                timeLabel.text = job?.time
            } else {
                timeLabel.text = CommonFunctions.getFormattedDates(fromDate: job?.fromDate?.convertToDateAllowsNil(), toDate: job?.toDate?.convertToDateAllowsNil())
            }
            priceLabel.text = job?.amount
            addressLabel.text = job?.locationName
            let jobStatus = job?.jobStatus ?? ""
            let duration = job?.duration ?? "0"
            if duration == "0", (jobStatus.lowercased() == "expired" || jobStatus.lowercased() == "completed" || jobStatus.lowercased() == "cancelledApply" || jobStatus.lowercased() == "active") {
                daysLabel.textColor = #colorLiteral(red: 0.0431372549, green: 0.2549019608, blue: 0.6588235294, alpha: 1)
                daysLabel.font = UIFont.kAppDefaultFontBold(ofSize: 11)
                if jobStatus == "cancelledApply" {
                    daysLabel.text = JobStatus.cancelled.rawValue
                } else {
                    daysLabel.text = jobStatus.uppercased()
                }
            } else {
                daysLabel.textColor = .black
                daysLabel.font = UIFont.kAppDefaultFontRoman(ofSize: 14)
                daysLabel.text = job?.duration ?? "In progress"//isOnGoingJob ? "In progress" : job?.duration
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //FOR QUOTES GRID CELL
    //===================
    func populateData(data:QuoteList){
        let time = data.createdAt
        if !time.isEmpty {
            timeLabel.text = CommonFunctions.getFormattedDates(fromDate: data.fromDate?.convertToDateAllowsNil(), toDate: data.toDate?.convertToDateAllowsNil())
            //data.toDate
        } else {
            timeLabel.text = CommonFunctions.getFormattedDates(fromDate: data.fromDate?.convertToDateAllowsNil(), toDate: data.toDate?.convertToDateAllowsNil())
        }
        priceLabel.text = "\(data.amount)"//.currencyFormatting()
        addressLabel.text = data.locationName
        let jobStatus = data.status
        let duration = data.duration
        if duration == "0", (jobStatus.lowercased() == "expired" || jobStatus.lowercased() == "completed" || jobStatus.lowercased() == "cancelledApply" || jobStatus.lowercased() == "active") {
            daysLabel.textColor = #colorLiteral(red: 0.0431372549, green: 0.2549019608, blue: 0.6588235294, alpha: 1)
            daysLabel.font = UIFont.kAppDefaultFontBold(ofSize: 11)
            if jobStatus == "cancelledApply" {
                daysLabel.text = JobStatus.cancelled.rawValue
            } else {
                daysLabel.text = jobStatus.uppercased()
            }
        } else {
            daysLabel.textColor = .black
            daysLabel.font = UIFont.kAppDefaultFontRoman(ofSize: 14)
            daysLabel.text = data.duration
        }
    }
}
