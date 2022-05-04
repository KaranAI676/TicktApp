//
//  EditableOptionBuilderVC + Delegates.swift
//  Tickt
//
//  Created by S H U B H A M on 28/06/21.
//

import Foundation

extension EditableOptionBuilderVC: CommonButtonDelegate {
    
    func takePhoto() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: true)
    }
    
    func galleryButton() {
        captureImagePopUp(delegate: self, croppingEnabled: false, openCamera: false)
    }
}

extension EditableOptionBuilderVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            viewModel.changeProfilePicture(image: image)
        }
    }
}

extension EditableOptionBuilderVC: EditableOptionBuilderVMDelegate {
    
    func didGetTradeList() {
        let tradeId = tradieModel?.result.areasOfSpecialization.tradeData.first?.tradeId ?? ""
        if let selectedTradeIndex = kAppDelegate.tradeModel?.result?.trade?.firstIndex(where: {$0.id == tradeId}), var selecedTrade = kAppDelegate.tradeModel?.result?.trade?.filter({$0.id == tradeId}), var specializations = selecedTrade.first?.specialisations {
            if selecedTrade.count > 0 {
                for existingSpecialization in tradieModel?.result.areasOfSpecialization.specializationData ?? [] {
                    for (index, specialization) in specializations.enumerated() {
                        if existingSpecialization.specializationId == specialization.id {
                            specializations[index].isSelected = true
                        }
                    }
                }
                selecedTrade[0].isSelected = true
                selecedTrade[0].specialisations = specializations
                kAppDelegate.signupModel.tradeList = selecedTrade
                kAppDelegate.tradeModel?.result?.trade?[selectedTradeIndex].isSelected = true
                kAppDelegate.tradeModel?.result?.trade?[selectedTradeIndex].specialisations = specializations
                let tradeVC = WhatIsYourTradeVC.instantiate(fromAppStoryboard: .registration)
                tradeVC.isEdit = true
                tradeVC.selectedSpecializationClosure = { [weak self] (specializations, trade) in
                    self?.updateSpecialization(specializations: specializations, trade: trade)
                }
                push(vc: tradeVC)
            }
        }
    }
        
    func updateSpecialization(specializations: [SpecializationModel], trade: TradeDataModel) {

        tradieModel?.result.areasOfSpecialization.specializationData = specializations.map({ specialization -> (SpecializationData) in
            var object = SpecializationData()
            object.specializationId = specialization.id
            object.specializationName = specialization.name
            return object
        })
        tradieModel?.result.areasOfSpecialization.tradeData[0].tradeId = trade.tradeId
        tradieModel?.result.areasOfSpecialization.tradeData[0].tradeName = trade.tradeName
        tradieModel?.result.areasOfSpecialization.tradeData[0].tradeSelectedUrl = trade.tradeSelectedUrl

        tableViewOutlet.reloadData()        
    }
    
    func didGetTradieProfile(model: TradieProfilefromBuilderModel) {
        tradieModel = model
        photosArray = model.result.portfolio.map({ eachModel -> (String?, UIImage?) in
            return (eachModel.portfolioImage.first ?? "", nil)
        })
        tableViewOutlet.reloadData { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }
 
    func successChangeProfile(image: String) {
        if kUserDefaults.isTradie() {
            tradieModel?.result.tradieImage = image
        } else {
            loggedInBuilderModel?.result.builderImage = image
        }
        tableViewOutlet.reloadData()
    }
    
    func successEditProfile() {
        if let vc = navigationController?.viewControllers.first(where: { $0 is TabBarController }) {
            mainQueue { [weak self] in
                NotificationCenter.default.post(name: NotificationName.refreshProfile, object: nil, userInfo: nil)
                self?.navigationController?.popToViewController(vc, animated: true)
            }
        } else {
            pop()
        }
    }
    
    func failure(message: String) {
        CommonFunctions.showToastWithMessage(message)
    }
}

extension EditableOptionBuilderVC: AddPortfolioBuilderVCDelegate {
    
    func getUpdatedPortfolios(model: PortfoliaData) {
        if kUserDefaults.isTradie() {
            if model.portfolioId.isEmpty {
                tradieModel?.result.portfolio.append(TradieProfilePortfolio(model))
            } else {
                let index = tradieModel?.result.portfolio.firstIndex(where: { eachModel -> Bool in
                    return eachModel.portfolioId == model.portfolioId
                })
                
                if let index = index {
                    tradieModel?.result.portfolio[index] = TradieProfilePortfolio(model)
                    tableViewOutlet.reloadData()
                } else {
                    tradieModel?.result.portfolio.append(TradieProfilePortfolio(model))
                }

            }
            photosArray = tradieModel?.result.portfolio.map({ eachModel -> (String?, UIImage?) in
                return (eachModel.portfolioImage.first ?? "", nil)
            }) ?? []
        } else {
            
            if let index = currentIndexPortfolio {
                loggedInBuilderModel?.result.portfolio[index] = model
            } else if model.portfolioId.isEmpty {
                loggedInBuilderModel?.result.portfolio.append(model)
            }
            photosArray = loggedInBuilderModel?.result.portfolio.map({ eachModel -> (String?, UIImage?) in
                return (eachModel.portfolioImage?.first ?? "", nil)
            }) ?? []
        }
        tableViewOutlet.reloadData()
    }
}

extension EditableOptionBuilderVC: PortfolioDetailsBuilderVCDelegate {
    
    func getDeletedPortFolio(id: String) {
        
        if kUserDefaults.isTradie() {
            let index = tradieModel?.result.portfolio.firstIndex(where: { eachModel -> Bool in
                return eachModel.portfolioId == id
            })
            
            if let index = index {
                tradieModel?.result.portfolio.remove(at: index)
            }
            photosArray = tradieModel?.result.portfolio.map({ eachModel -> (String?, UIImage?) in
                return (eachModel.portfolioImage.first ?? "", nil)
            }) ?? []
        } else {
            if let index = currentIndexPortfolio {
                loggedInBuilderModel?.result.portfolio.remove(at: index)
                photosArray = loggedInBuilderModel?.result.portfolio.map({ eachModel -> (String?, UIImage?) in
                    return (eachModel.portfolioImage?.first ?? "", nil)
                }) ?? []
                tableViewOutlet.reloadData()
            }
        }
        tableViewOutlet.reloadData()
    }
    
    func getUpdatedPortfolio(model: PortfoliaData) {
        
        if kUserDefaults.isTradie() {
            if model.portfolioId.isEmpty {
                if tradieModel?.result.portfolio.count ?? 0 > 0 { //Locally added portfolio
                    tradieModel?.result.portfolio[0].portfolioImage = model.portfolioImage ?? []
                } else {
                    tradieModel?.result.portfolio.append(TradieProfilePortfolio(model))
                }
            } else {
                let index = tradieModel?.result.portfolio.firstIndex(where: { eachModel -> Bool in
                    return eachModel.portfolioId == model.portfolioId
                })
                
                if let index = index {
                    tradieModel?.result.portfolio[index] = TradieProfilePortfolio(model)
                    tableViewOutlet.reloadData()
                } else {
                    tradieModel?.result.portfolio.append(TradieProfilePortfolio(model))
                }
            }
            photosArray = tradieModel?.result.portfolio.map({ eachModel -> (String?, UIImage?) in
                return (eachModel.portfolioImage.first ?? "", nil)
            }) ?? []
        } else {
            
            if let index = currentIndexPortfolio {
                loggedInBuilderModel?.result.portfolio[index] = model
            }else if model.portfolioId.isEmpty {
                loggedInBuilderModel?.result.portfolio.append(model)
            }
            photosArray = loggedInBuilderModel?.result.portfolio.map({ eachModel -> (String?, UIImage?) in
                return (eachModel.portfolioImage?.first ?? "", nil)
            }) ?? []
        }
        tableViewOutlet.reloadData()
    }
}

extension EditableOptionBuilderVC: AddAboutBuilderVCDelegate {
    
    func getUpdatedAbout(text: String) {
        if kUserDefaults.isTradie() {
            tradieModel?.result.about = text
        } else {
            loggedInBuilderModel?.result.aboutCompany = text
        }
        tableViewOutlet.reloadData()
    }
}
