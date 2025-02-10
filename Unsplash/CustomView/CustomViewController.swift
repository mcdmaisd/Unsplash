//
//  CustomViewController.swift
//  Unsplash
//
//  Created by ilim on 2025-01-22.
//

import UIKit
import Kingfisher
import SnapKit

class CustomViewController: BaseViewController {
    
    var photo: Photo?
    
    private let randomImageView = UIImageView()
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    
    override func configureHierarchy() {
        addSubView(randomImageView)
    }
    
    override func configureLayout() {
        randomImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        randomImageView.contentMode = .scaleAspectFill
        randomImageView.isUserInteractionEnabled = true
        randomImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        guard let photo else { return }
        randomImageView.kf.setImage(with: URL(string: photo.urls.regular))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc
    private func imageTapped() {
        guard let photo else { return }
        let vc = DetailViewController()
        let request = APIRouter.statistics(id: photo.id)
        
        vc.viewModel.input.data.value = photo
        
        APIManager.shared.requestAPI(request, self) { [weak self] data in
            vc.viewModel.input.statistics.value = data
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
