//
//  JobDashboard+PageController.swift
//  Tickt
//
//  Created by Admin on 12/05/21.
//


extension JobDashboardVC: EMPageViewControllerDataSource {
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let selectedVc = pageViewController.selectedViewController {
            switch selectedVc {
            case activeJobVC:
                return nil
            case openJobVC:
                return activeJobVC
            case pastJobVC:
                return openJobVC
            default:
                return nil
            }
        }
        printDebug("\(#function) returns nil")
        return nil
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let selectedVc = pageViewController.selectedViewController {
            switch selectedVc {
            case activeJobVC:
                return openJobVC
            case openJobVC:
                return pastJobVC
            case pastJobVC:
                return nil
            default:
                return nil
            }
        }
        printDebug("\(#function) returns nil")
        return nil
    }
}

extension JobDashboardVC: EMPageViewControllerDelegate {
        
    func em_pageViewController(_ pageViewController: EMPageViewController, willStartScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController) {
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, isScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController, progress: CGFloat) {
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, didFinishScrollingFrom startViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        if pageViewController.selectedViewController === startViewController {
            return
        }
        
        switch destinationViewController {
        case activeJobVC:
            activeBtnAction()
        case openJobVC:
            openBtnAction()
        case pastJobVC:
            pastBtnAction()
        default:
            break
        }
    }
}
