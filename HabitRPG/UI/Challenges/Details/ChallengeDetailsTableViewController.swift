//
//  ChallengeDetailsTableViewController.swift
//  Habitica
//
//  Created by Elliot Schrock on 10/20/17.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//

import UIKit

class ChallengeDetailsTableViewController: MultiModelTableViewController {
    var viewModel: ChallengeDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topHeaderCoordinator.hideHeader = true
        self.topHeaderCoordinator.navbarHiddenColor = .white
        self.topHeaderCoordinator.followScrollView = false
        
        title = "Details"

        viewModel?.cellModelsSignal.observeValues({ [weak self] (sections) in
            self?.dataSource.sections = sections
            self?.tableView.reloadData()
        })
        
        viewModel?.reloadTableSignal.observeValues { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel?.animateUpdatesSignal.observeValues({ [weak self] _ in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        })
        
        viewModel?.nextViewControllerSignal.observeValues({ [weak self] viewController in
            self?.navigationController?.pushViewController(viewController, animated: true)
        })
        
        viewModel?.joinLeaveStyleProvider.promptProperty.signal.observeValues({ [weak self] prompt in
            if let alertController = prompt {
                self?.present(alertController, animated: true, completion: nil)
            }
        })
        
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ChallengeTableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        
        self.viewModel?.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let dataSourceSection = dataSource.sections?[section] {
            if let sectionTitleString = dataSourceSection.title {
                if let itemCount = dataSourceSection.items?.count {
                    
                    let header: ChallengeTableViewHeaderView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? ChallengeTableViewHeaderView
                    
                    header?.titleLabel.text = sectionTitleString
                    header?.countLabel.text = "\(itemCount)"

                    return header
                }
            }
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource.sections?[section].title != nil ? 55 : 0
    }
}
