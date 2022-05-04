//
//  AddQuoteVC.swift
//  Tickt
//
//  Created by Vijay's Macbook on 06/09/21.
//

import UIKit

protocol SubmitQuoteDelegate: AnyObject {
    func didQuoteAccepted()
    func didQuoteSubmitted()
}

protocol EditQuoteDelegate: AnyObject {
    func didPressSubmitQuoteFromEdit()
    func didItemDeleted(indexPath: IndexPath)
    func didQuoteEdited(itemList: [ItemDetails], indexPath: IndexPath)
}

class AddQuoteVC: BaseVC {

    enum CellType {
        case addItem
        case itemList
        case totalPrice
    }
    
    var isInvite = false
    var isEditItem = false
    var currentItemNumber = 1
    var isResubmitQuote = false
    let viewModel = AddQuoteVM()
    var jobDetail: JobDetailsData?
    var itemList: [ItemDetails] = []
    var editedIndexPath = IndexPath()
    weak var delegate: SubmitQuoteDelegate?
    weak var editDelegate: EditQuoteDelegate?
    var sectionArray: [CellType] = [.itemList, .addItem, .totalPrice]
        
    var isLastItem: Bool {
        get {
            return itemList.count == 1 && isResubmitQuote
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var quoteTableView: UITableView!
    @IBOutlet weak var tradeImageView: UIImageView!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet weak var jobNameLabel: CustomRegularLabel!
    @IBOutlet weak var tradeNameLabel: CustomMediumLabel!
    @IBOutlet weak var tableBottomContraint: NSLayoutConstraint!
            
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        buttonHeight.constant = isResubmitQuote ? 0 : 58
        tableBottomContraint.constant = isResubmitQuote ? 0 : 30
        viewModel.delegate = self
        quoteTableView.registerCell(with: AddItemCell.self)
        quoteTableView.registerCell(with: ItemListCell.self)
        quoteTableView.registerCell(with: TotalPriceCell.self)
        if isResubmitQuote, !isEditItem {
            viewModel.getQuoteDetail(jobId: jobDetail?.jobId ?? "")
        } else {
            quoteTableView.delegate = self
            quoteTableView.dataSource = self
            quoteTableView.reloadData()
        }
        jobNameLabel.text = jobDetail?.jobName
        tradeNameLabel.text = jobDetail?.tradeName
        tradeImageView.sd_setImage(with: URL(string: jobDetail?.tradeSelectedUrl ?? ""), placeholderImage: nil)
        enableQuoteButton()
        if isEditItem {
            if let cell = quoteTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AddItemCell {
                cell.editItemDetail = itemList[editedIndexPath.row]
            }
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case submitButton:
            if isResubmitQuote {
                showSuccessScreen()
            } else {
                viewModel.submitQuote(jobId: jobDetail?.jobId ?? "", items: itemList, builderId: jobDetail?.postedBy?.builderId ?? "", tradeId: jobDetail?.tradeId ?? "", specializationId: jobDetail?.specializationId ?? "", isInvited: isInvite, jobDetail: jobDetail)
            }
        default:
            break
        }
    }
}

