//
//  XXPopupCategory.swift
//
//
//  Created by adad184 on 7/12/16.
//  Copyright © 2016 ustock. All rights reserved.
//

import UIKit

public extension UIColor {
	static func xx_hexColor(_ rgba: UInt32) -> UIColor {
		let d = CGFloat(255)
		let r = CGFloat(Int(rgba >> 24) & 0xFF) / d
		let g = CGFloat(Int(rgba >> 16) & 0xFF) / d
		let b = CGFloat(Int(rgba >> 8)  & 0xFF) / d
		let a = CGFloat(rgba & 0xFF) / d

		return UIColor(red: r, green: g, blue: b, alpha: a)
	}
}

public extension UIImage {
	static func xx_image(_ color: UIColor, size: CGSize = CGSize(width: 4, height: 4)) -> UIImage {

		let rect = CGRect(origin: CGPoint.zero, size: size)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()

		context?.setFillColor(color.cgColor)
		context?.fill(rect)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
}

public extension UIView {

	fileprivate struct XXDimBackgroundKey {
		static var view = "view"
		static var animating = "animating"
		static var duration = "dutaion"
		static var reference = "reference"
		static var enabled = "enabled"
		static var touchWild = "touchWild"
		static var normal = "normal"
		static var highlighted = "highlighted"
	}

	public func xx_showDimBackground() {

		self.xx_dimReferenceCount = self.xx_dimReferenceCount + 1

		if self.xx_dimReferenceCount > 1 {
			return
		}

		if self.isKind(of: XXWindow.self) {
			self.isHidden = false
		} else if self.isKind(of: UIWindow.self) {
			if let window = UIApplication.shared.delegate?.window {
				if self == window {
					return
				}
			}

			self.isHidden = false
		} else {
			self.bringSubview(toFront: self.xx_dimBackgroundView)
		}

		self.xx_dimBackgroundAnimating = true
		self.xx_dimBackgroundView.isHidden = false

		UIView.animate(
			withDuration: self.xx_dimBackgroundAnimatingDuration,
			delay: 0.0,
			options: [
				UIViewAnimationOptions.curveEaseOut,
				UIViewAnimationOptions.beginFromCurrentState
			],
			animations: {
				self.xx_dimBackgroundView.layer.backgroundColor = UIColor.xx_hexColor(self.xx_dimBackgroundEnabled ? 0x0000007F : 0xFFFFFF00).cgColor
			},
			completion: { (finished: Bool) in
				if finished {
					self.xx_dimBackgroundAnimating = false
				}
		})
	}

	public func xx_hideDimBackground() {

		self.xx_dimReferenceCount = self.xx_dimReferenceCount - 1

		if self.xx_dimReferenceCount > 0 {
			return
		}
		self.xx_dimBackgroundAnimating = true

		UIView.animate(
			withDuration: self.xx_dimBackgroundAnimatingDuration,
			delay: 0.0,
			options: [
				UIViewAnimationOptions.curveEaseIn,
				UIViewAnimationOptions.beginFromCurrentState
			],
			animations: {
				self.xx_dimBackgroundView.layer.backgroundColor = UIColor.xx_hexColor(0x00000000).cgColor
			},
			completion: { (finished: Bool) in
				if finished {
					self.xx_dimBackgroundAnimating = false
					self.xx_dimBackgroundView.isHidden = true

					if self.isKind(of: UIWindow.self) {

						if self.isKind(of: XXWindow.self) {
							self.isHidden = true
						}

						if let window = UIApplication.shared.delegate?.window {
							if self == window {
								return
							}

							self.isHidden = true
						}
					}
				}
		})
	}

	public var xx_dimReferenceCount: Int {
		get {
			return objc_getAssociatedObject(self, &XXDimBackgroundKey.reference) as? Int ?? 0
		}
		set {
			objc_setAssociatedObject(self, &XXDimBackgroundKey.reference, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	public var xx_dimBackgroundView: XXGestureView {
		get {
			guard let backView = objc_getAssociatedObject(self, &XXDimBackgroundKey.view) as? XXGestureView else {
				let view = XXGestureView()
				self.addSubview(view)
				view.isHidden = true
				view.snp.makeConstraints({ (make) in
					make.edges.equalTo(self)
				})
				view.backgroundColor = UIColor.xx_hexColor(0x00000000)
				view.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
				view.layoutIfNeeded()

				objc_setAssociatedObject(self, &XXDimBackgroundKey.view, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

				let gesture = UITapGestureRecognizer(target: self, action: #selector(xx_actionTapWild))
				gesture.cancelsTouchesInView = false
				gesture.delegate = view

				view.addGestureRecognizer(gesture)

				return view
			}
			return backView
		}
		set {
			objc_setAssociatedObject(self, &XXDimBackgroundKey.view, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	public func xx_actionTapWild() {
		if self.xx_dimTouchWildToHide && !self.xx_dimBackgroundAnimating {
			for view in self.xx_dimBackgroundView.subviews {
				if view.isKind(of: XXPopupView.self) {
					let popView = view as! XXPopupView
					popView.hide()
				}
			}
		}
	}

	public var xx_dimBackgroundAnimating: Bool {
		get {
			return objc_getAssociatedObject(self, &XXDimBackgroundKey.animating) as? Bool ?? false
		}
		set {
			objc_setAssociatedObject(self, &XXDimBackgroundKey.animating, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	public var xx_dimBackgroundEnabled: Bool {
		get {
			return objc_getAssociatedObject(self, &XXDimBackgroundKey.enabled) as? Bool ?? true
		}
		set {
			objc_setAssociatedObject(self, &XXDimBackgroundKey.enabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	public var xx_dimBackgroundAnimatingDuration: TimeInterval {
		get {
			return objc_getAssociatedObject(self, &XXDimBackgroundKey.duration) as? TimeInterval ?? 0.3
		}
		set {
			objc_setAssociatedObject(self, &XXDimBackgroundKey.duration, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	public var xx_dimTouchWildToHide: Bool {
		get {
			return objc_getAssociatedObject(self, &XXDimBackgroundKey.touchWild) as? Bool ?? true
		}
		set {
			objc_setAssociatedObject(self, &XXDimBackgroundKey.touchWild, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}

public class XXGestureView: UIView, UIGestureRecognizerDelegate {

	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return touch.view! == self
	}
}
