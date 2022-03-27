//SlotView.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 26/03/2022

import UIKit

class SlotView: UIView {
    
    enum Item {
        case tom
        case spike
        case jerry
        case butch
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var scrollView : UIScrollView!
    @IBOutlet private var contentView: UIStackView!
    
    // MARK: - Variables
    
    private let rowHeight: CGFloat = 70
    private var space    : CGFloat { contentView.spacing }
    private var halfSpace: CGFloat { space / 2 }
    
    var number: Int!
        
    private var items: Array<Item> = [
        .tom, .spike, .jerry, .butch,
        .tom, .spike, .jerry, .butch,
        .tom
    ]
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
        initialize()
    }
  
    func initialize() {
        generateContent()
        scrollView.contentInset = UIEdgeInsets.init(top: halfSpace, left: 0, bottom: halfSpace, right: 0)
        
        resetScrollPosition()
    }
    
    private func generateContent() {
        for item in items {
            let containerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: contentView.bounds.width, height: rowHeight))
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = .clear
            containerView.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
            
            let imageView = UIImageView.init()
            imageView.translatesAutoresizingMaskIntoConstraints = false
          
            switch item {            
            case .tom : imageView.image = UIImage.init(named: "tom")
            case .spike: imageView.image = UIImage.init(named: "spike")
            case .jerry: imageView.image = UIImage.init(named: "jerry")
            case .butch: imageView.image = UIImage.init(named: "butch")
            }
            
            containerView.addSubview(imageView)
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            
            self.contentView.addArrangedSubview(containerView)
        }
        
        contentView.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    private var isRolling: Bool = false
    
    func startScroll() {
        isRolling = true
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveLinear,
            animations: {
                self.scrollView.contentOffset.y -= self.rowHeight + self.space
        },
            completion: { _ in
                if self.isRolling {
                    if self.scrollView.contentOffset.y <= 0 {
                        self.resetScrollPosition()
                    }
                    self.startScroll()
                } else {
                    self.scrollView.contentOffset.y = self.scrollView.contentSize.height - (self.rowHeight + self.halfSpace)

                    UIView.animate(
                        withDuration: 0.7,
                        delay: 0,
                        options: .curveEaseOut,
                        animations: {
                            self.number = Int.random(in: 0..<8)
                            self.scrollView.contentOffset.y -= CGFloat(self.number).rounded() * (self.rowHeight + self.space)
                    },
                        completion: nil
                    )
                }
        })
    }
    
    private func resetScrollPosition() {
        self.scrollView.contentOffset.y = 4 * (rowHeight + space) - halfSpace
    }
    
    func stopScroll() {
        isRolling = false
    }
}
