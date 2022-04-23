//
//  uiview_extensions.swift
//  KBZ_NEWS
//
//  Created by Kyaw Ye Htun on 23/04/2022.
//

import Foundation
import UIKit
import NVActivityIndicatorView


extension UIView{
    
    @discardableResult
    func addCenterLoadingView(size: CGSize = CGSize(width: 40, height: 40), centerView: UIView? = nil, color: UIColor? = .gray) -> NVActivityIndicatorView {
        let loadingView = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: size), type: NVActivityIndicatorType.circleStrokeSpin, color: color, padding: 0)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: centerView?.centerXAnchor ?? centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerView?.centerYAnchor ?? centerYAnchor).isActive = true
        return loadingView
    }
}
