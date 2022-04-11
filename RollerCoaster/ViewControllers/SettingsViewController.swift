//
//  SettingsViewController.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 26/03/2022

import UIKit

struct SettingsRow {
    var title: String
    var theme: String
}

struct SettingsSection {
    var title: String
    var rows: [SettingsRow]
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    
    let SettingsList = [
        SettingsSection(title: "Location", rows: [SettingsRow(title: "Show near by Casinos", theme: "")]),
        SettingsSection(title: "Change Theme", rows: [SettingsRow(title: "Red", theme: "Red"), SettingsRow(title: "Blue", theme: "Blue")]),
        SettingsSection(title: "About", rows: [SettingsRow(title: "US Gambling Laws", theme: "")]),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.delegate = self
        tblView.dataSource = self
        tblView.tableFooterView = UIView()
        tblView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setThemeBasedUI()
    }
    
    private func showMap() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "kMapViewController") as? MapViewController {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func showWebPage() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "kWebPageViewController") as? WebPageViewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func setThemeBasedUI() {
        view.backgroundColor = Themes.init(rawValue: UserDefaultsManager.Theme)?.themeConfig().primaryColor
        self.tabBarController?.tabBar.tintColor = Themes.init(rawValue: UserDefaultsManager.Theme)?.themeConfig().primaryColor
        self.tabBarItem.selectedImage = UIImage(named: "control")?.withRenderingMode(.alwaysTemplate)
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: (Themes.init(rawValue: UserDefaultsManager.Theme) ?? Themes.Red).themeConfig().primaryColor!], for: .selected)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 24.0)
            headerView.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsList[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsList[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "SettingsCell")
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        
        cell.accessoryType = (indexPath.section == 1 ? (UserDefaultsManager.Theme == SettingsList[indexPath.section].rows[indexPath.row].title ? .checkmark : .none) : .disclosureIndicator)
        cell.textLabel?.text = SettingsList[indexPath.section].rows[indexPath.row].title
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            showMap()
        } else if indexPath.section == 2 {
            showWebPage()
        } else {
            UserDefaultsManager.Theme = SettingsList[indexPath.section].rows[indexPath.row].title
            tblView.reloadData()
            setThemeBasedUI()
        }
    }

}
