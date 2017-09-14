//
//  XXBubbleView.swift
//  demoMQTT
//
//  Created by adad184 on 7/13/16.
//  Copyright © 2016 adad184. All rights reserved.
//

import SnapKit

public enum XXBubbleDiretcion: Int {
    case top
    case left
    case bottom
    case right
    case topLeft
    case topRight
    case leftTop
    case leftBottom
    case bottomLeft
    case bottomRight
    case rightTop
    case rightBottom
    case automatic
}

open class XXBubbleView: XXPopupView {

    public var cellAction: [XXActionItem] = [XXActionItem]()

    public let tableView = UITableView()
    public let arrowView = UIImageView()
    public var anchorView = UIView()
    public var anchorDirection = XXBubbleDiretcion.automatic

    public var popWidth: CGFloat = 0

    public override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience public init(anchorView: UIView, titles: [String], anchorDirection: XXBubbleDiretcion = .automatic, action: @escaping ((_ index: Int) -> Void), width: CGFloat) {

        var actions: [XXActionItem] = [XXActionItem]()
        for title in titles {
            let action = XXActionItem(title: title, action: action)

            actions.append(action)
        }

        self.init(anchorView: anchorView, anchorDirection: anchorDirection, cellAction: actions, width: width)
    }

    convenience public init(anchorView: UIView, titles: [String], anchorDirection: XXBubbleDiretcion = .automatic, action: @escaping ((_ index: Int) -> Void)) {

        var actions: [XXActionItem] = [XXActionItem]()
        for title in titles {
            let action = XXActionItem(title: title, action: action)

            actions.append(action)
        }

        self.init(anchorView: anchorView, anchorDirection: anchorDirection, cellAction: actions, width: XXBubbleViewConfig.width)
    }

    convenience public init(anchorView: UIView, anchorDirection: XXBubbleDiretcion = .automatic, cellAction: [XXActionItem]) {

        self.init(anchorView: anchorView, anchorDirection: anchorDirection, cellAction: cellAction, width: XXBubbleViewConfig.width)
    }

    convenience public init(anchorView: UIView, anchorDirection: XXBubbleDiretcion = .automatic, cellAction: [XXActionItem], width: CGFloat) {

        self.init(frame: CGRect.zero)

        self.anchorView = anchorView
        self.cellAction = cellAction
        self.anchorDirection = anchorDirection
        self.popWidth = width

        if self.anchorDirection == .automatic {
            self.anchorDirection = self.getAnchorDirection(self.anchorView)
        }

        self.buildUI()
    }

    open func buildUI() {

        assert(!self.cellAction.isEmpty, "Need at least 1 action")

        self.targetView = XXBubbleWindow

        typealias Config = XXBubbleViewConfig

        self.type = .custom

        self.snp.makeConstraints { (make) in
            make.width.equalTo(self.popWidth)
        }
        self.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)

        ({ (view: UIImageView) in
            view.contentMode = .center
            view.image = UIImage.xx_rhombusWithSize(CGSize(width: Config.arrowWidth + Config.cornerRadius, height: Config.arrowWidth + Config.cornerRadius), color: Config.cellBackgroundNormalColor)

            self.addSubview(view)
            }(self.arrowView))

        ({ (view: UITableView) in
            view.delegate = self
            view.dataSource = self
            view.separatorStyle = .none
            view.register(XXBubbleViewCell.self, forCellReuseIdentifier: "XXBubbleViewCell")
            view.isScrollEnabled = self.cellAction.count > Config.maxNumberOfItems
            view.canCancelContentTouches = false
            view.delaysContentTouches = false
            view.backgroundColor = Config.cellBackgroundNormalColor
            view.layer.cornerRadius = Config.cornerRadius
            view.layer.masksToBounds = true
            view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0000001))

            self.addSubview(view)
            }(self.tableView))

        self.tableView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(self).inset(UIEdgeInsets(top: Config.arrowWidth, left: Config.arrowWidth, bottom: Config.arrowWidth, right: Config.arrowWidth))

            let count = CGFloat(min(CGFloat(Config.maxNumberOfItems) + 0.5, CGFloat(self.cellAction.count)))

            make.height.equalTo(Config.cellHeight * count).priority(750)
        }

        self.layoutIfNeeded()
    }

    override open func showAnimation(completion closure: ((_ popupView: XXPopupView, _ finished: Bool) -> Void)?) {

        if self.superview == nil {
            self.targetView!.xx_dimBackgroundView.addSubview(self)
            self.targetView!.xx_dimBackgroundView.layoutIfNeeded()
            self.targetView!.xx_dimBackgroundAnimatingDuration = 0.15
            self.duration = self.targetView!.xx_dimBackgroundAnimatingDuration
        }
        
        self.tableView.isUserInteractionEnabled = true
        self.tableView.allowsSelection = true

        typealias Config = XXBubbleViewConfig

        let center = self.getAnchorPosition(self.anchorView)
        let widthOffset = self.anchorView.frame.size.width / 2.0
        let heightOffset = self.anchorView.frame.size.height / 2.0
        let arrowOffset = Config.arrowWidth * 2 + Config.cornerRadius
        let xOffsetRatio = arrowOffset / self.frame.width
        let yOffsetRatio = arrowOffset / self.frame.height

        switch self.anchorDirection {
        case .topLeft:
            self.layer.anchorPoint = CGPoint(x: xOffsetRatio, y: 0.0)
            self.layer.position = CGPoint(x: center.x, y: center.y + heightOffset)
        case .leftTop:
            self.layer.anchorPoint = CGPoint(x: 0.0, y: yOffsetRatio)
            self.layer.position = CGPoint(x: center.x + widthOffset, y: center.y)
        case .topRight:
            self.layer.anchorPoint = CGPoint(x: 1.0 - xOffsetRatio, y: 0.0)
            self.layer.position = CGPoint(x: center.x, y: center.y + heightOffset)
        case .rightTop:
            self.layer.anchorPoint = CGPoint(x: 1.0, y: yOffsetRatio)
            self.layer.position = CGPoint(x: center.x - widthOffset, y: center.y)
        case .bottomLeft:
            self.layer.anchorPoint = CGPoint(x: xOffsetRatio, y: 1.0)
            self.layer.position = CGPoint(x: center.x, y: center.y - heightOffset)
        case .leftBottom:
            self.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0 - yOffsetRatio)
            self.layer.position = CGPoint(x: center.x + widthOffset, y: center.y)
        case .bottomRight:
            self.layer.anchorPoint = CGPoint(x: 1.0 - xOffsetRatio, y: 1.0)
            self.layer.position = CGPoint(x: center.x, y: center.y - heightOffset)
        case .rightBottom:
            self.layer.anchorPoint = CGPoint(x: 1.0, y: 1.0 - yOffsetRatio)
            self.layer.position = CGPoint(x: center.x - widthOffset, y: center.y)
        case .top:
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            self.layer.position = CGPoint(x: center.x, y: center.y + heightOffset)
        case .bottom:
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            self.layer.position = CGPoint(x: center.x, y: center.y - heightOffset)
        case .left:
            self.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            self.layer.position = CGPoint(x: center.x + widthOffset, y: center.y)
        case .right:
            self.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            self.layer.position = CGPoint(x: center.x - widthOffset, y: center.y)
        default:
            break
        }

        self.arrowView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 2.0 * (Config.arrowWidth + Config.cornerRadius), height: 2.0 * (Config.arrowWidth + Config.cornerRadius)))

            switch self.anchorDirection {
            case .topLeft:
                make.centerY.equalTo(self.tableView.snp.top)
                make.left.equalTo(self.tableView.snp.left)
            case .leftTop:
                make.centerX.equalTo(self.tableView.snp.left)
                make.top.equalTo(self.tableView.snp.top)
            case .topRight:
                make.centerY.equalTo(self.tableView.snp.top)
                make.right.equalTo(self.tableView.snp.right)
            case .rightTop:
                make.centerX.equalTo(self.tableView.snp.right)
                make.top.equalTo(self.tableView.snp.top)
            case .bottomLeft:
                make.centerY.equalTo(self.tableView.snp.bottom)
                make.left.equalTo(self.tableView.snp.left)
            case .leftBottom:
                make.centerX.equalTo(self.tableView.snp.left)
                make.bottom.equalTo(self.tableView.snp.bottom)
            case .bottomRight:
                make.centerY.equalTo(self.tableView.snp.bottom)
                make.right.equalTo(self.tableView.snp.right)
            case .rightBottom:
                make.centerX.equalTo(self.tableView.snp.right)
                make.bottom.equalTo(self.tableView.snp.bottom)
            case .top:
                make.centerY.equalTo(self.tableView.snp.top)
                make.centerX.equalTo(self.tableView.snp.centerX)
            case .bottom:
                make.centerY.equalTo(self.tableView.snp.bottom)
                make.centerX.equalTo(self.tableView.snp.centerX)
            case .left:
                make.centerY.equalTo(self.tableView.snp.centerY)
                make.centerX.equalTo(self.tableView.snp.left)
            case .right:
                make.centerY.equalTo(self.tableView.snp.centerY)
                make.centerX.equalTo(self.tableView.snp.right)
            default:
                break
            }
        }

        self.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0)

        UIView.animate(
            withDuration: self.duration,
            delay: 0.0,
            options: [
                UIViewAnimationOptions.curveEaseOut,
                UIViewAnimationOptions.beginFromCurrentState
            ],
            animations: {
                self.layer.transform = CATransform3DIdentity
            },
            completion: { (finished: Bool) in
                if self.superview != nil && self.targetView?.isHidden == true {
                    self.targetView?.isHidden = false
                }
                if let completionClosure = closure {
                    completionClosure(self, finished)
                }
        })
    }

    override open func hideAnimation(completion closure: ((_ popupView: XXPopupView, _ finished: Bool) -> Void)?) {

        UIView.animate(
            withDuration: self.duration,
            delay: 0.0,
            options: [
                UIViewAnimationOptions.curveEaseIn,
                UIViewAnimationOptions.beginFromCurrentState
            ],
            animations: {
                self.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0)
            },
            completion: { (finished: Bool) in
                if finished {
                    self.removeFromSuperview()
                }
                if let completionClosure = closure {
                    completionClosure(self, finished)
                }
        })
    }

    public func getAnchorWindow(_ anchorView: UIView) -> UIWindow {

        var sv = anchorView.superview

        while sv != nil {
            if sv!.isKind(of: UIWindow.self) {
                break
            }

            sv = sv!.superview
        }

        assert(sv != nil, "fatal: anchorView should be on some window")

        let window = sv as! UIWindow

        return window
    }

    public func getAnchorPosition(_ anchorView: UIView) -> CGPoint {

        let window = self.getAnchorWindow(anchorView)

        let center = CGPoint(x: anchorView.frame.width / 2.0, y: anchorView.frame.height / 2.0)

        return anchorView.convert(center, to: window)
    }

    public func getAnchorDirection(_ anchorView: UIView) -> XXBubbleDiretcion {

        let position = self.getAnchorPosition(anchorView)
        let xRatio: CGFloat = position.x / UIScreen.main.bounds.width
        let yRatio: CGFloat = position.y / UIScreen.main.bounds.height

        switch (xRatio, yRatio) {
        case (CGFloat(0.0 / 3.0)..<CGFloat(1.0 / 3.0),
            CGFloat(0.0 / 6.0)..<CGFloat(1.0 / 6.0)):
                return .topLeft
        case (CGFloat(2.0 / 3.0)...CGFloat(3.0 / 3.0),
            CGFloat(0.0 / 6.0)..<CGFloat(1.0 / 6.0)):
                return .topRight
        case (CGFloat(0.0 / 3.0)..<CGFloat(1.0 / 3.0),
            CGFloat(1.0 / 6.0)..<CGFloat(2.0 / 6.0)):
                return .leftTop
        case (CGFloat(2.0 / 3.0)...CGFloat(3.0 / 3.0),
            CGFloat(1.0 / 6.0)..<CGFloat(2.0 / 6.0)):
                return .rightTop
        case (CGFloat(0.0 / 3.0)..<CGFloat(1.0 / 3.0),
            CGFloat(2.0 / 6.0)..<CGFloat(4.0 / 6.0)):
                return .left
        case (CGFloat(2.0 / 3.0)...CGFloat(3.0 / 3.0),
            CGFloat(2.0 / 6.0)..<CGFloat(4.0 / 6.0)):
                return .right
        case (CGFloat(0.0 / 3.0)..<CGFloat(1.0 / 3.0),
            CGFloat(4.0 / 6.0)..<CGFloat(5.0 / 6.0)):
                return .leftBottom
        case (CGFloat(2.0 / 3.0)...CGFloat(3.0 / 3.0),
            CGFloat(4.0 / 6.0)..<CGFloat(5.0 / 6.0)):
                return .rightBottom
        case (CGFloat(0.0 / 3.0)..<CGFloat(1.0 / 3.0),
            CGFloat(5.0 / 6.0)...CGFloat(6.0 / 6.0)):
                return .bottomLeft
        case (CGFloat(2.0 / 3.0)...CGFloat(3.0 / 3.0),
            CGFloat(5.0 / 6.0)...CGFloat(6.0 / 6.0)):
                return .bottomRight
        case (CGFloat(1.0 / 3.0)...CGFloat(2.0 / 3.0),
            CGFloat(0.0 / 6.0)..<CGFloat(4.0 / 6.0)):
                return .top
        case (CGFloat(1.0 / 3.0)...CGFloat(2.0 / 3.0),
            CGFloat(4.0 / 6.0)...CGFloat(6.0 / 6.0)):
                return .bottom
        default:
            SSLog("warning: anchorView is out of screen")
            return .top
        }
    }
    
    @objc func selectAction(_ button: UIButton) {
        guard button.tag < self.cellAction.count else {
            return
        }
        let item = self.cellAction[button.tag]
        
        if let action = item.action {
            action(button.tag)
        }
        
        self.hide()
    }
}

extension XXBubbleView: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellAction.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return XXBubbleViewConfig.cellHeight
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "XXBubbleViewCell", for: indexPath) as! XXBubbleViewCell
        cell.isUserInteractionEnabled = true
        
        let item = self.cellAction[indexPath.row]
        cell.button.setTitle(item.title, for: .normal)
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
        cell.showIcon = item.image != nil
        cell.iconView.image = item.image
        cell.split.isHidden = indexPath.row == self.cellAction.count - 1

        return cell
    }
}

public extension UIImage {

    public static func xx_rhombusWithSize(_ size: CGSize, color: UIColor) -> UIImage {

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)

        color.setFill()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: size.width / 2.0, y: 0.0))
        path.addLine(to: CGPoint(x: size.width, y: size.height / 2.0))
        path.addLine(to: CGPoint(x: size.width / 2.0, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: size.height / 2.0))
        path.addLine(to: CGPoint(x: size.width / 2.0, y: 0.0))
        path.close()
        path.fill()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

private class XXBubbleViewCell: UITableViewCell {

    var showIcon = false {
        didSet {
            self.iconView.isHidden = !showIcon
            
            typealias Config = XXBubbleViewConfig
            self.button.contentEdgeInsets = UIEdgeInsetsMake(0, self.showIcon ? 2*Config.innerPadding + Config.iconSize.width : Config.innerPadding, 0, Config.innerPadding)
        }
    }

    let iconView = UIImageView()
    let button = UIButton()
    let split = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {

        typealias Config = XXBubbleViewConfig

        self.selectionStyle = .none
        self.contentView.backgroundColor = Config.cellBackgroundNormalColor

        ({ (view: UIImageView) in

            self.contentView.addSubview(view)
            }(self.iconView))
        
        ({ (view: UIButton) in
            view.setTitleColor(Config.cellTitleColor, for: .normal)
            view.titleLabel?.font = Config.cellTitleFont
            view.contentHorizontalAlignment = Config.cellTitleAlignment
            view.contentEdgeInsets = UIEdgeInsetsMake(0, self.showIcon ? 2*Config.innerPadding + Config.iconSize.width : Config.innerPadding, 0, Config.innerPadding)
            view.titleLabel?.adjustsFontSizeToFitWidth = true
            view.setBackgroundImage(UIImage.ss.image(XXBubbleViewConfig.cellBackgroundHighlightedColor), for: .highlighted)
            
            self.contentView.addSubview(view)
            }(self.button))

        ({ (view: UIView) in
            view.backgroundColor = Config.cellSplitColor

            self.contentView.addSubview(view)
            }(self.split))

        self.iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.leading.equalTo(self.contentView.snp.leading).offset(Config.innerPadding)
            make.size.equalTo(Config.iconSize)
        }
        
        self.button.snp.makeConstraints { (make) in
            make.leading.top.bottom.trailing.equalToSuperview()
        }

        self.split.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self.contentView)
            make.height.equalTo(Config.splitWidth)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.contentView.backgroundColor = XXBubbleViewConfig.cellBackgroundHighlightedColor
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.contentView.backgroundColor = XXBubbleViewConfig.cellBackgroundNormalColor
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.contentView.backgroundColor = XXBubbleViewConfig.cellBackgroundNormalColor
    }
}

public struct XXBubbleViewConfig {

    public static var maxNumberOfItems = 5
    public static var width: CGFloat = 160.0
    public static var cornerRadius: CGFloat = 5.0
    public static var cellHeight: CGFloat = 50.0
    public static var innerPadding: CGFloat = 10.0
    public static var splitWidth: CGFloat = 1.0 / UIScreen.main.scale
    public static var iconSize: CGSize = CGSize(width: 25, height: 25)
    public static var arrowWidth: CGFloat = 10.0

    public static var cellTitleAlignment: UIControlContentHorizontalAlignment = .left
    public static var cellTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    public static var cellTitleColor: UIColor = UIColor.xx_hexColor(0x333333FF)
    public static var cellSplitColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)
    public static var cellBackgroundNormalColor: UIColor = UIColor.xx_hexColor(0xFFFFFFFF)
    public static var cellBackgroundHighlightedColor: UIColor = UIColor.xx_hexColor(0xCCCCCCFF)
    public static var cellImageColor: UIColor = UIColor.xx_hexColor(0xFFFFFFFF)
}
