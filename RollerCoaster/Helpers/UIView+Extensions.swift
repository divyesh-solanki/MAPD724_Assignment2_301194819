//
//  UIView+Extensions.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 26/03/2022


import UIKit

extension UIView {
    /// Set Custom Xib view
    func nibSetup() {
        backgroundColor = .clear
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
        return nibView
    }
}
