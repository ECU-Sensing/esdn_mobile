//
//  ProjectListViewController.swift
//  esdn_app
//
//  Created by Colby Sawyer on 11/27/22.
//

import Foundation
import SwiftUI

class ProjectListViewController: UIViewController{
    let contentView = UIHostingController(rootView: ProjectListUIView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        view.addSubview(contentView.view)
    }
    
}
