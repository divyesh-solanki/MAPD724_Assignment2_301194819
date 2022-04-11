//  ViewController.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 26/03/2022

import UIKit

class ViewController: UIViewController {

    @IBOutlet var containerView: UIStackView?
    @IBOutlet var lottieContainerView: UIView!
    @IBOutlet var lblResult: UILabel!
    @IBOutlet var lblBalance: UILabel!
    @IBOutlet var lblBet: UILabel!
    @IBOutlet var slot1Views: [SlotView]?
    @IBOutlet var btnStartSpin: UIButton?
    @IBOutlet var btnStopSpin: UIButton?
    
    private var currentBet = 50 {
        didSet {
            lblBet.text = "Bet : \(currentBet) Coins"
        }
    }
    private var balance: Int {
        get {
            return UserDefaultsManager.Balance
        }
        set {
            UserDefaultsManager.Balance = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Home"
        lblBalance.text = "\(balance) Coins"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setThemeBasedUI()
    }
    
    private func setThemeBasedUI() {
        view.backgroundColor = Themes.init(rawValue: UserDefaultsManager.Theme)?.themeConfig().primaryColor
        self.tabBarController?.tabBar.tintColor = Themes.init(rawValue: UserDefaultsManager.Theme)?.themeConfig().primaryColor
        self.tabBarItem.selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: (Themes.init(rawValue: UserDefaultsManager.Theme) ?? Themes.Red).themeConfig().primaryColor!], for: .selected)
    }
    
    
    private func checkResult() {
        // var prev = 0
        // var isWinner = true
        var result: [Int] = [Int]()
        slot1Views?.enumerated().forEach({ obj in
            print(obj.element.number%4)
            result.append(obj.element.number%4)
        })
        let rewards = calculateReward(result: result.sorted())
        setResult(rewards.0, isJacpot: rewards.1)
    }
    
    private func calculateReward(result: [Int]) -> (Int, Bool) {
        let resultString = result.compactMap({"\($0)"}).joined(separator: "")
        var reward = 0
        var isJackpot = false
        if resultString.contains("111") {
            reward = 1000
            isJackpot = true
        } else if resultString.contains("333") {
            reward = currentBet + 60
        } else if resultString.contains("000") {
            reward = currentBet + 40
        } else if resultString.contains("222") {
            reward = currentBet + 20
        } else if resultString.contains("11") {
            reward = currentBet + 10
        } else if resultString.contains("33") {
            reward = currentBet + 6
        } else if resultString.contains("00") {
            reward = currentBet + 4
        } else if resultString.contains("22") {
            reward = currentBet + 2
        } else if resultString.contains("1") {
            reward = currentBet + 5
        }
        return (reward, isJackpot)
    }
    
    private func setResult(_ coins: Int, isJacpot: Bool) {
        var resultInfo = "You won \(coins) coins\nCongratulations!!!"
        if isJacpot {
            resultInfo = "Jackpot\nCongratulations!!!"
        } else if coins == 0 {
            resultInfo = "You Lose\nBetter luck next time"
        }
        lblResult.text = resultInfo
        balance += coins
        lblBalance.text = "\(balance) Coins"
        hideResult(coins > 0 ? 2.0 : 1.5)
    }
    
    private func hideResult(_ delay: Double) {
        UIView.animate(withDuration: 0.5, delay: delay, options: UIView.AnimationOptions.curveEaseInOut) {
            self.lblResult.alpha = 0.0
        } completion: { _ in
            self.lblResult.text = nil
            self.lblResult.alpha = 1.0
            self.btnStartSpin?.alpha = 1.0
            self.btnStartSpin?.isUserInteractionEnabled = true
        }
    }
    
    @IBAction private func startSpin() {
        balance -= currentBet
        lblBalance.text = "\(balance) Coins"
        slot1Views?.enumerated().forEach({ obj in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (Double(obj.offset) * 0.1)) {
                obj.element.startScroll()
            }
        })
        
        btnStartSpin?.alpha = 0.0
        btnStartSpin?.isHidden = false
        btnStopSpin?.isHidden = true
        btnStartSpin?.isUserInteractionEnabled = false
        self.perform(#selector(stopSpin), with: nil, afterDelay: 3.0)
    }
    
    @IBAction private func stopSpin() {
        let group = DispatchGroup()
        slot1Views?.enumerated().forEach({ obj in
            group.enter()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (Double(obj.offset) * 0.1)) {
                obj.element.stopScroll()
                group.leave()
            }
        })
        btnStartSpin?.isHidden = false
        btnStopSpin?.isHidden = true
        group.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.checkResult()
            }
        }
    }
    
    @IBAction private func betValueChanged(_ sender: UIStepper) {
        currentBet = Int(sender.value)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            containerView?.axis = .horizontal
        } else {
            print("Portrait")
            containerView?.axis = .vertical
        }
    }


}

