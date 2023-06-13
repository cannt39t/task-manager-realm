//
//  TaskManagerModuleBuilder.swift
//  Super easy dev
//
//  Created by Илья Казначеев on 12.06.2023
//

import UIKit

class TaskManagerModuleBuilder {
    static func build() -> UINavigationController {
        let interactor = TaskManagerInteractor()
        let router = TaskManagerRouter()
        let presenter = TaskManagerPresenter(interactor: interactor, router: router)
        let viewController = TaskManagerViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return UINavigationController(rootViewController: viewController)
    }
}
