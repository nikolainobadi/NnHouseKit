//
//  DeleteHouseVC.swift
//  
//
//  Created by Nikolai Nobadi on 2/8/22.
//

import UIKit
import NnUIViewKitPackage

public final class DeleteHouseVC: NiblessViewController {
    
    // MARK: - Properties
    private let tableVC: UIViewController
    private let detailsView: DeleteHouseDetailsInterface
    private let loader: DeleteHouseLoader
    private let alerts: DeleteHouseAlerts
    private let dismiss: () -> Void
    
    
    // MARK: - Init
    public init(tableVC: UIViewController,
                detailsView: DeleteHouseDetailsInterface,
                loader: DeleteHouseLoader,
                alerts: DeleteHouseAlerts,
                dismiss: @escaping () -> Void) {
        
        self.tableVC = tableVC
        self.detailsView = detailsView
        self.loader = loader
        self.alerts = alerts
        self.dismiss = dismiss
        super.init(hasTextFields: false)
    }
    
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadDetails()
    }
}


// MARK: - Private Methods
private extension DeleteHouseVC {
    
    func setupView() {
        addChild(tableVC)
        view.addSubview(detailsView)
        view.addSubview(tableVC.view)
        navigationItem.title = "Delete House"
        
        detailsView.anchor(view.safeTopAnchor,
                           left: view.leftAnchor,
                           bottom: tableVC.view.topAnchor,
                           right: view.rightAnchor,
                           topConstant: view.heightPercent(2),
                           leftConstant: view.widthPercent(2),
                           bottomConstant: view.heightPercent(2),
                           rightConstant: view.widthPercent(2))
        
        tableVC.view.anchor(left: view.leftAnchor,
                            bottom: view.safeBottomAnchor,
                            right: view.rightAnchor,
                            leftConstant: view.widthPercent(2),
                            rightConstant: view.widthPercent(2),
                            heightConstant: view.heightPercent(40))
    }
    
    func loadDetails() {
        loader.loadData { [weak self] result in
            switch result {
            case .success(let details):
                self?.setDetails(details)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
    func setDetails(_ details: String) {
        detailsView.updateView(details)
    }
    
    func showError(_ error: DeleteHouseError) {
        switch error {
        case .networkError:
            alerts.showError(error, completion: nil)
        case .shownByMistakeError:
            alerts.showError(error) { [weak self] in
                self?.dismiss()
            }
        }
    }
}


// MARK: - Dependencies
public protocol DeleteHouseLoader {
    func loadData(completion: @escaping (Result<String, DeleteHouseError>) -> Void)
}

public protocol DeleteHouseAlerts {
    func showError(_ error: Error, completion: (() -> Void)?)
}

public protocol DeleteHouseDetailsInterface: UIView {
    func updateView(_ details: String)
}
