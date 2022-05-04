//
//  PortfolioDetailsBuilder.swift
//  Tickt
//
//  Created by S H U B H A M on 13/06/21.
//

import UIKit

protocol PortfolioDetailsBuilderVCDelegate: AnyObject {
    func getDeletedPortFolio(id: String)
    func getUpdatedPortfolio(model: PortfoliaData)
}

class PortfolioDetailsBuilderVC: BaseVC {

    enum SectionArray {
        case images
        case description
        
        var title: String {
            switch self {
            case .description:
                return "Job description"
            default:
                return ""
            }
        }
        
        var height: CGFloat {
            switch self {
            case .description:
                return 30
            default:
                return CGFloat.leastNonzeroMagnitude
            }
        }
        
        var color: UIColor {
            switch self {
            case .description:
                return #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.2901960784, alpha: 1)
            default:
                return .clear
            }
        }
        
        var font: UIFont {
            switch self {
            default:
                return UIFont.systemFont(ofSize: 16)
            }
        }
    }
    
    //MARK:- IB Outlets
    @IBOutlet weak var navBehindView: UIView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var threeDotButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK:- Variables
    var sectionArray = [SectionArray]()
    var model: TradieProfilePortfolio? {
        didSet {
            portfolioImageUrls = model?.portfolioImage.map({ eachModel -> (String?, UIImage?) in
                return (eachModel, nil)
            })
        }
    }
    var loggedInBuilderPortfolio: PortfoliaData? {
        didSet {
            portfolioImageUrls = loggedInBuilderPortfolio?.portfolioImage?.map({ eachModel -> (String?, UIImage?) in
                return (eachModel, nil)
            })
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    var portfolioImageUrls: [(String?, UIImage?)]?
    var isEdit: Bool = false
    var viewModel = PortfolioDetailsBuilderVM()
    weak var delegate: PortfolioDetailsBuilderVCDelegate? = nil
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.popUpView.popOut()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case backButton:
            pop()
        case threeDotButton:
            let _ = self.popUpView.alpha == 0 ? self.popUpView.popIn() : self.popUpView.popOut()
        case editButton:
            self.popUpView.popOut()
            gotoAddPortfolioVC()
        case deleteButton:
            if let model = loggedInBuilderPortfolio {
                delegate?.getDeletedPortFolio(id: model.portfolioId)
                pop()
            }
            if let tradieModel = model {
                if tradieModel.portfolioId.isEmpty {
                    deleteSuccess()
                } else {
                    viewModel.delegate = self
                    viewModel.deleteTradiePortfolio(id: tradieModel.portfolioId)
                }                
            }
        case saveButton:
            if let model = loggedInBuilderPortfolio {
                delegate?.getUpdatedPortfolio(model: model)
                pop()
            }
            
            if let tradieModel = model {
                delegate?.getUpdatedPortfolio(model: PortfoliaData(jobName: tradieModel.jobName, portfolioId: tradieModel.portfolioId, description: tradieModel.jobDescription, imagesUrls: tradieModel.portfolioImage))
                pop()
            }
        default:
            break
        }
    }
}
