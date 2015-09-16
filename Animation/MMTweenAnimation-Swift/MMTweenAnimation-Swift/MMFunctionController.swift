//
//  MMFunctionController.swift
//  MMTweenAnimation-Swift
//
//  Created by techset on 15/9/14.
//  Copyright (c) 2015年 iosdev. All rights reserved.
//

import UIKit

class MMFunctionController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MMTweenAnimation-Swift"
        
        tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.addSubview(tableView!)
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Int(MMTweenFunctionType.Max.rawValue)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(MMTweenEasingType.Max.rawValue)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        
        cell.textLabel?.text = "\(MMTweenFunction.sharedInstance.easingNames[indexPath.row])"
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let viewController = MMAnimationController()
        viewController.functionType = MMTweenFunctionType(rawValue: UInt(indexPath.section))!
        viewController.easingType = MMTweenEasingType(rawValue: UInt(indexPath.row))!
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return MMTweenFunction.sharedInstance.functionNames[section]
    }
}
