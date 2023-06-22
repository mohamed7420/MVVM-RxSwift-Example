//
//  Extensions.swift
//  KickStartTask
//
//  Created by MohamedOsama on 20/06/2023.
//

import Foundation
import UIKit

public extension UIView {
    @IBInspectable var isCircled: Bool {
        get {
            false
        }
        set {
            if newValue {
                cornerRadius = bounds.height / 2
                layer.allowsEdgeAntialiasing = true
                
                if #available(iOS 13.0, *) {
                    layer.cornerCurve = .continuous
                }
                
                DispatchQueue.main.async {
                    self.cornerRadius = self.bounds.height / 2
                }
            }
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            layer.masksToBounds
        }
        set {
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 13.0, *) {
                layer.cornerCurve = .continuous
            }
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.allowsEdgeAntialiasing = true
            if #available(iOS 13.0, *) {
                self.traitCollection.performAsCurrent {
                    self.layer.borderColor = newValue.cgColor
                }
            } else {
                layer.borderColor = newValue.cgColor
            }
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable var shadowColor: UIColor {
        get {
            UIColor(cgColor: layer.shadowColor ?? UIColor.lightGray.cgColor)
        }
        set {
            if #available(iOS 13.0, *) {
                self.traitCollection.performAsCurrent {
                    self.layer.shadowColor = newValue.cgColor
                }
            } else {
                layer.shadowColor = newValue.cgColor
            }
        }
    }

    @IBInspectable var shadowRadius: Float {
        get {
            Float(layer.shadowRadius)
        }
        set {
            layer.shadowRadius = CGFloat(newValue)
        }
    }
}

public extension UIView {
    /// loads a full view from a xib file
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIView>() -> T {
            UINib(nibName: "\(T.self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
        }
        return instantiateFromNib()
    }
}

class AMControlView: UIControl {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 1/3) {self.transform = CGAffineTransform.init(scaleX: 0.93, y: 0.93)}
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.3) {self.transform = .identity}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {self.transform = .identity}
        guard let touch = touches.first else { return }
        if point(inside: touch.location(in: self), with: event) {
            sendActions(for: .touchUpInside)
        }
    }
}

public extension String {
    var isEmptyOrWhitespaces: Bool {
        if isEmpty {
            return true
        }
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
