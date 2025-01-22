//
//  RandomViewController.swift
//  Unsplash
//
//  Created by ilim on 2025-01-22.
//

import UIKit
import Alamofire
import SnapKit

final class RandomViewController: BaseViewController {
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
    private let group = DispatchGroup()
    
    private var images: [Photo] = []
    private var dataViewControllers: [UIViewController] = []
    
    override func configureHierarchy() {
        addChild(pageViewController)
        addSubView(pageViewController.view)
    }
    
    override func configureLayout() {
        initPages()
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        pageViewController.didMove(toParent: self)
    }
    
    private func setImages() {
        group.enter()

        APIManager.shared.requestAPI(APIRouter.random) { (result: Result<[Photo], Error>) in
            switch result {
            case .success(let data):
                self.images = data
                self.group.leave()
            case .failure(let error):
                guard let error = error as? ErrorMessage else { return }
                self.presentAlert(message: error.message)
            }
        }
        group.notify(queue: .main) { [self] in
            makeViewControllers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationBarTransparent()
        setImages()
    }
    
    private func makeViewControllers() {
        for i in 0 ..< images.count {
            let vc = CustomViewController()
            vc.photo = images[i]
            dataViewControllers.append(vc)
        }
        
        if let firstVC = dataViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func initPages() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
}

extension RandomViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        
        return dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        
        return dataViewControllers[nextIndex]
    }
}
