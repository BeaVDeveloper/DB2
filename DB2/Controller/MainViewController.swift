//
//  ViewController.swift
//  DB2
//
//  Created by Yura Velko on 7/12/19.
//  Copyright © 2019 Yura Velko. All rights reserved.
//

import UIKit
import SwiftyPickerPopover
import JGProgressHUD

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var privatTableView: UITableView!
    @IBOutlet weak var nbuTableView: UITableView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nbuDateLabel: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var nbuCalendarButton: UIButton!
    
    
    private let rowHeight = 40
    private var isRecievingInfo = false
    
    let privatHud = JGProgressHUD(style: .light)
    let nbuHud = JGProgressHUD(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nbuDateLabel.attributedText = NSMutableAttributedString(string: Date().formattedString(), attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        dateLabel.attributedText = NSMutableAttributedString(string: Date().formattedString(), attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        privatTableView.separatorStyle = .none
        nbuTableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViews(_:)), name: Globals.NotificationNames.UpdateTableData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createActivityIndicator(_:)), name: Globals.NotificationNames.StartLoadingData, object: nil)
        
        DatabaseManager.shared.fillDatabase(type: .URL_NOW)
    }
    
    @objc private func updateTableViews(_ notification: Notification) {
        if let bool = notification.userInfo?["isPrivatData"] as? Bool {
            calendarButton.isUserInteractionEnabled = false
            nbuCalendarButton.isUserInteractionEnabled = false
            if bool == true {
                privatTableView.reloadData()
                stopActivityIndicator(tableView: privatTableView)
                privatHud.dismiss()
            } else {
                nbuTableView.reloadData()
                stopActivityIndicator(tableView: nbuTableView)
                nbuHud.dismiss()
            }
            if privatTableView.isUserInteractionEnabled == true, nbuTableView.isUserInteractionEnabled == true {
                calendarButton.isUserInteractionEnabled = true
                nbuCalendarButton.isUserInteractionEnabled = true
                isRecievingInfo = false
            }
        }
    }
    
    @objc private func createActivityIndicator(_ notification: Notification) {
        if let bool = notification.userInfo?["isPrivatData"] as? Bool {
            if bool == true {
                privatHud.show(in: mainStack.arrangedSubviews[0])
                privatTableView.isUserInteractionEnabled = false
                privatTableView.alpha = 0.4
            } else {
                nbuHud.show(in: mainStack.arrangedSubviews[1])
                nbuTableView.isUserInteractionEnabled = false
                nbuTableView.alpha = 0.4
            }
        }
    }
    
    private func stopActivityIndicator(tableView: UITableView) {
        tableView.alpha = 1
        tableView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        privatTableView.frame = CGRect(x: privatTableView.frame.origin.x, y: privatTableView.frame.origin.y, width: privatTableView.frame.size.width, height: CGFloat(rowHeight * 3))
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        view.layoutIfNeeded()
        
        if view.traitCollection.horizontalSizeClass == .compact && view.traitCollection.verticalSizeClass == .regular {
            mainStack.distribution = .fill
            mainStack.axis = .vertical
            mainStack.spacing = 15
        } else {
            mainStack.distribution = .fillEqually
            mainStack.axis = .horizontal
            mainStack.spacing = 25
        }
        mainStack.reloadInputViews()
    }
    
    
    @IBAction func openCalendar(_ sender: UIButton) {
        guard isRecievingInfo == false else { return }
        guard let minDate = Calendar.current.date(byAdding: .year, value: -4, to: Date()) else {return}
        sender.setImage(#imageLiteral(resourceName: "calendarOn"), for: .normal)
        
        DatePickerPopover(title: "Выберете дату")
            .setDateMode(.date)
            .setSelectedDate(Date())
            
            .setClearButton(title: "Clear", font: UIFont(name: "Avenir Next", size: 17), color: #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1), action: { (popover, selectedDate) in
                popover.setSelectedDate(Date()).reload()
            })
            .setDoneButton(title: "Done", font: UIFont(name: "Avenir Next", size: 17), color: #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1), action: { (popover, selectedDate) in
                
                self.dateLabel.attributedText = NSMutableAttributedString(string: selectedDate.formattedString(), attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
                self.nbuDateLabel.attributedText = NSMutableAttributedString(string: selectedDate.formattedString(), attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
                sender.setImage(#imageLiteral(resourceName: "calendarOff"), for: .normal)
                DatabaseManager.shared.fillDatabase(type: selectedDate == Date() ? .URL_NOW : .URL_ON_DATE, date: selectedDate.formattedString())
            })
            .setCancelButton(title: "Cancel", font: UIFont(name: "Avenir Next", size: 17), color: #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1), action: { (popover, selectedDate) in
                sender.setImage(#imageLiteral(resourceName: "calendarOff"), for: .normal)
                popover.disappear()
            })
            .setMinimumDate(minDate)
            .setMaximumDate(Date())
            .setOutsideTapDismissing(allowed: false)
            .appear(originView: sender, baseViewController: self)
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == privatTableView {
            return DatabaseManager.shared.privatBankData.count
        } else {
            return DatabaseManager.shared.nbuData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == privatTableView {
            let item = DatabaseManager.shared.privatBankData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: Globals.CellIdentifier.privatBankCell, for: indexPath) as! PrivatBankCell
            cell.setPrivatBankCurrency(curr: item)
            return cell
            
        } else if tableView == nbuTableView {
            let item = DatabaseManager.shared.nbuData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: Globals.CellIdentifier.nbuCell, for: indexPath) as! NBUCell
            cell.setNBUCurrency(curr: item)
            cell.backgroundColor = .white
            if indexPath.row % 2 == 1 {
                cell.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9568627451, blue: 0.9411764706, alpha: 1)
            }
            return cell
        } else { return UITableViewCell()}
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == privatTableView {
            let cell = tableView.cellForRow(at: indexPath) as! PrivatBankCell
            for curr in DatabaseManager.shared.nbuData {
                let cellName = String(cell.name.text?.suffix(3) ?? "")
                
                if cellName == curr.oneCurrency {
                    guard let index = DatabaseManager.shared.nbuData.firstIndex(where: { $0.oneCurrency == cellName }) else { return }
                    let appropriatedIndexPath = IndexPath(row: index, section: 0)
                    nbuTableView.scrollToRow(at: appropriatedIndexPath, at: .none, animated: true)
                    nbuTableView.selectRow(at: appropriatedIndexPath, animated: true, scrollPosition: .none)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        self.nbuTableView.deselectRow(at: appropriatedIndexPath, animated: true)
                        self.privatTableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! NBUCell
            for curr in DatabaseManager.shared.privatBankData {
                let cellName = String(cell.oneCurrency.text?.suffix(3) ?? "")
                
                if cellName == curr.name {
                    guard let index = DatabaseManager.shared.privatBankData.firstIndex(where: { $0.name == cellName}) else { return }
                    
                    let appropriatedIndexPath = IndexPath(row: index, section: 0)
                    privatTableView.scrollToRow(at: appropriatedIndexPath, at: .none, animated: true)
                    privatTableView.selectRow(at: appropriatedIndexPath, animated: true, scrollPosition: .none)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        self.privatTableView.deselectRow(at: appropriatedIndexPath, animated: true)
                        self.nbuTableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
        }
    }
}


