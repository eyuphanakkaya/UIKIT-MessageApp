//
//  PagesViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 5.09.2023.
//

import UIKit

class PagesViewController: UIPageViewController {
    lazy var vcArray: [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let defaultPage = storyBoard.instantiateViewController(withIdentifier: "one") as! IntroViewController
        
        let page0 = storyBoard.instantiateViewController(withIdentifier: "one") as! IntroViewController
        page0.page = pages[0] // İlk sayfa için veriyi ata
        
        let page1 = storyBoard.instantiateViewController(withIdentifier: "one") as! IntroViewController
        page1.page = pages[1] // İkinci sayfa için veriyi ata
        
        let page2 = storyBoard.instantiateViewController(withIdentifier: "one") as! IntroViewController
        page2.page = pages[2] // Üçüncü sayfa için veriyi ata
        
        return [page0, page1, page2]
    }()
    
    var pages: [Page] = Page.samplePages
    var pageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let vc = vcArray.first as? IntroViewController{
            vc.page = pages[pageIndex]
            self.setViewControllers([vc], direction: .forward, animated: true)
        }
    }
    override func viewDidLayoutSubviews() {
        for subview in self.view.subviews {
            if subview is UIScrollView {
                subview.frame = self.view.bounds
            }
        }
    }
    
    
    
}
extension PagesViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcArray.lastIndex(of: viewController) else {return nil}
        let previousIndex = index - 1
        guard previousIndex >= 0 else {return nil}
        guard previousIndex < vcArray.count else {return nil}
        pageIndex = index - 1
        return vcArray[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcArray.lastIndex(of: viewController) else {return nil}
        let previousIndex = index + 1
        guard previousIndex >= 0 else {return nil}
        guard previousIndex < vcArray.count else {return nil}
        pageIndex = index + 1
        return vcArray[previousIndex]
        
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcArray.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pageIndex
    }
    
}





