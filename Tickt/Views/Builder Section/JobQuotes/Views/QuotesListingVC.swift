//
//  QuotesListingVC.swift
//  Tickt
//
//  Created by Admin on 14/09/21.
//

import UIKit

protocol OpenJobsQuotesVCDelegate: AnyObject {
    func removedEmptyQuotes(jobId: String, status: AcceptDecline)
}

class QuotesListingVC: BaseVC {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var quotesTable: UITableView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categorytype: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var jobModel = BasicJobModel() {
        didSet {
            self.jobId = jobModel.jobId
        }
    }
    
    var model: QuotesModel? {
        didSet {
            self.quotesTable.reloadData {
                self.quotesTable.reloadData()
            }
        }
    }
    var currentCardSelectedIndex = 0
    var sortBy = 1
    var viewModel = OpenJobApplicationVM()
    private var jobId: String = ""
    weak var delegate: OpenJobsQuotesVCDelegate? = nil
   
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        initailSetUp()
    }
        
    //MARK:- PRIVATE FUNCTIONS
    //=======================
    private func initailSetUp() {
        setupTableView()
        viewModel.delegate = self
//        viewModel.getQuoteList(jobId: "6141ab9102195343b5e232d3", sortBy: self.sortBy)
        viewModel.getQuoteList(jobId: jobId, sortBy: self.sortBy)
        setupQuoteView()
    }
    
    func setupTableView() {
        self.quotesTable.delegate = self
        self.quotesTable.dataSource = self
        ///
        self.quotesTable.registerCell(with: GridCell.self)
        self.quotesTable.registerCell(with: PostedByCell.self)
        
        self.quotesTable.registerCell(with: LowestQuoteButtonCell.self)
        self.quotesTable.registerCell(with: QuotesUserCell.self)
    }
    
    private func gotoQuotesDetails(jobId: String, tradieId: String){
        let vc = QuotesDetailsVC.instantiate(fromAppStoryboard: .jobQuotes)
        vc.catName = jobModel.tradeName
        let status = model?.result?.resultData[currentCardSelectedIndex].status ?? ""
        if status.lowercased() == "pending" {
            vc.showBottomButton = true
        } else {
            vc.showBottomButton = false
        }
        vc.cattype = jobModel.jobName
        vc.ctImage =  jobModel.tradeImage
        vc.jobId = jobId
        vc.tradieId = tradieId
        self.push(vc: vc)
    }
    
    private func setupQuoteView() {
        self.categoryName.text = jobModel.tradeName
        self.categorytype.text = jobModel.jobName
        self.categoryImage.sd_setImage(with: URL(string: self.jobModel.tradeImage), placeholderImage: nil)
    }
}

extension QuotesListingVC{
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.pop()
    }
}

extension QuotesListingVC: TableDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return model?.result?.resultData.count ?? 0
        } else {
            return model?.result?.resultData.isEmpty ?? true ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    // set height for footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = quotesTable.dequeueCell(with: GridCell.self)
            if let model = self.model?.result?.resultData[indexPath.row]  {
                cell.populateData(data: model)
            }
            return cell
        
        case 1:
            let cell = quotesTable.dequeueCell(with: LowestQuoteButtonCell.self)
            cell.tap = { [weak self] in
                guard let self = self else { return }
                if cell.quoteOrderBtn.isSelected {
                    cell.dropDownImage.image = #imageLiteral(resourceName: "dropdown")
                    cell.quoteOrderBtn.setTitle("Lowest quote", for: .normal)
                    self.viewModel.getQuoteList(jobId: self.jobId, sortBy: 1)
                    cell.dropDownImage.transform = cell.dropDownImage.transform.rotated(by: CGFloat(Double.pi))
                } else {
                    cell.quoteOrderBtn.setTitle("Higest quote", for: .normal)
                    self.viewModel.getQuoteList(jobId: self.jobId, sortBy: -1)
                    cell.dropDownImage.transform = cell.dropDownImage.transform.rotated(by: CGFloat(Double.pi))

                }
                cell.quoteOrderBtn.isSelected = !cell.quoteOrderBtn.isSelected                
            }
            return cell
      
        case 2:
            let cell = tableView.dequeueCell(with: QuotesUserCell.self)
            cell.tableView = tableView
            if let model = self.model?.result?.resultData[indexPath.row]  {
                cell.applicationModel = model
            }
            cell.buttonClosure = { [weak self] (index) in
                guard let self = self else { return }
                if let tradieId = self.model?.result?.resultData[indexPath.row] {
                    self.currentCardSelectedIndex = indexPath.row
                    self.gotoQuotesDetails(jobId: self.jobId, tradieId: tradieId.userId)
                }
            }
            cell.layoutIfNeeded()
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}

//MARK:- DELEGATE
//==============
extension QuotesListingVC: OpenJobApplicationVMDelegate{
    func success(model: OpenJobApplicationModel) {
        
    }
    
    func quoteSuccess(model: QuotesModel) {
        self.model = model
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}
