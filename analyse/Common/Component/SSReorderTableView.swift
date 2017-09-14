//
//  SSReorderTableView.swift
//  Common
//
//  Created by Eason Lee on 2017/2/6.
//  Copyright © 2017年 Stocks. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore

public protocol SSReorderCellDelegate: NSObjectProtocol {

    func longPress(_ gesture: UILongPressGestureRecognizer, cell: UITableViewCell)

}

public protocol SSReorderTableViewDelegate: NSObjectProtocol {

    // 保存数据并插入空行
    func saveObjectAndInsertBlankRow(at: IndexPath)

    func moveRow(at fromIndexPath: IndexPath, to targetIndexPath: IndexPath)

    func finishReordering(at indexPath: IndexPath)
}

public class SSReorderTableView: SSBaseTableView, SSReorderCellDelegate {

    var currentLocationIndexPath: IndexPath?
    var initialIndexPath: IndexPath?

    var scrollRate: CGFloat = 0.0
    var draggingRowHeight: CGFloat = 0.0
    var draggingViewOpacity: Float = 1.0

    var draggingView: UIImageView?

    public weak var reorderDelegate: SSReorderTableViewDelegate?

    public override func setup() {
        super.setup()
    }

    @objc public func longPress(_ gesture: UILongPressGestureRecognizer, cell: UITableViewCell) {

        switch gesture.state {
        case .began:

            let location = gesture.location(in: self)
            guard let indexPath = indexPathForRow(at: location) else { return }

            draggingRowHeight = cell.frame.height
            cell.setSelected(false, animated: false)
            cell.setHighlighted(false, animated: false)

            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            guard let context = UIGraphicsGetCurrentContext() else { return }
            cell.layer.render(in: context)
            let cellImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            if draggingView == nil {
                let dView = UIImageView(image: cellImage)
                addSubview(dView)
                let rect = rectForRow(at: indexPath)
                dView.frame = rectOffset(dView.bounds, rect.minX, rect.minY)

                dView.layer.masksToBounds = false
                dView.layer.shadowColor = UIColor.black.cgColor
                dView.layer.shadowOffset = CGSize(width: 0, height: 3)
                dView.layer.shadowRadius = 4.0
                dView.layer.shadowOpacity = 0.7
                dView.layer.opacity = draggingViewOpacity

                UIView.beginAnimations("zoom", context: nil)
                dView.center = CGPoint(x: center.x, y: location.y)
                UIView.commitAnimations()

                draggingView = dView
            }

            beginUpdates()
            deleteRows(at: [indexPath], with: .none)
            insertRows(at: [indexPath], with: .none)

            reorderDelegate?.saveObjectAndInsertBlankRow(at: indexPath)

            currentLocationIndexPath = indexPath
            initialIndexPath = indexPath
            endUpdates()

        // dragging
        case .changed:

            guard let draggingView = draggingView else { return }

            let location = gesture.location(in: self)

            if location.y >= 0 && location.y <= contentSize.height + 50 {
                draggingView.center = CGPoint(x: center.x, y: location.y)
            }

            var rect = bounds
            rect.size.height -= contentInset.top

            updateCurrentLocation(gesture)

            let scrollZoneHeight = rect.height / 6.0
            let bottomScrollBeginning = contentOffset.y + contentInset.top + rect.height - scrollZoneHeight
            let topScrollBeginning = contentOffset.y + contentInset.top + scrollZoneHeight

            if location.y >= bottomScrollBeginning {
                scrollRate = (location.y - bottomScrollBeginning) / scrollZoneHeight
            } else if location.y <= topScrollBeginning {
                scrollRate = (location.y - topScrollBeginning) / scrollZoneHeight
            } else {
                scrollRate = 0.0
            }

        case .ended:

            guard let indexPath = currentLocationIndexPath else { return }
            scrollRate = 0.0

            UIView.animate(withDuration: 0.3,
                           animations: { 
                            //
                            let rect = self.rectForRow(at: indexPath)
                            guard let draggingView = self.draggingView else { return }

                            draggingView.transform = CGAffineTransform.identity
                            draggingView.frame = self.rectOffset(draggingView.bounds, rect.minX, rect.minY)
            },
                           completion: { (finished) in
                            //
                            self.draggingView?.removeFromSuperview()

                            self.beginUpdates()
                            self.deleteRows(at: [indexPath], with: .none)
                            self.insertRows(at: [indexPath], with: .none)

                            self.reorderDelegate?.finishReordering(at: indexPath)

                            self.endUpdates()

                            guard let visibleRows = self.indexPathsForVisibleRows else { return }
                            var rows = Set(visibleRows)
                            rows.remove(indexPath)
                            let reloadRows = rows.map({ $0 })
                            self.reloadRows(at: reloadRows, with: .none)

                            self.currentLocationIndexPath = nil
                            self.draggingView = nil
            })
        case .cancelled:
            guard let indexPath = currentLocationIndexPath else { return }
            scrollRate = 0.0

            UIView.animate(withDuration: 0.3,
                           animations: {
                            //
                            let rect = self.rectForRow(at: indexPath)
                            guard let draggingView = self.draggingView else { return }

                            draggingView.transform = CGAffineTransform.identity
                            draggingView.frame = self.rectOffset(draggingView.bounds, rect.minX, rect.minY)
            },
                           completion: { (finished) in
                            //
                            self.draggingView?.removeFromSuperview()

                            self.beginUpdates()
                            self.deleteRows(at: [indexPath], with: .none)
                            self.insertRows(at: [indexPath], with: .none)

                            self.reorderDelegate?.finishReordering(at: indexPath)

                            self.endUpdates()

                            guard let visibleRows = self.indexPathsForVisibleRows else { return }
                            var rows = Set(visibleRows)
                            rows.remove(indexPath)
                            let reloadRows = rows.map({ $0 })
                            self.reloadRows(at: reloadRows, with: .none)
                            
                            self.currentLocationIndexPath = nil
                            self.draggingView = nil
            })
        default:
            break
        }
    }

    func updateCurrentLocation(_ gesture: UILongPressGestureRecognizer) {

        let location = gesture.location(in: self)

        guard
            let currentLocationIndexPath = currentLocationIndexPath,
            let indexPath = indexPathForRow(at: location),
            let initialIndexPath = initialIndexPath,
            let cell = cellForRow(at: indexPath)
            else { return }

        _ = delegate?.tableView?(self, targetIndexPathForMoveFromRowAt: initialIndexPath, toProposedIndexPath: indexPath)
        let oldHeight = rectForRow(at: currentLocationIndexPath).size.height
        let newHeight = rectForRow(at: indexPath).size.height

        if indexPath != currentLocationIndexPath && gesture.location(in: cell).y > newHeight - oldHeight {
            beginUpdates()

            deleteRows(at: [currentLocationIndexPath], with: .automatic)
            insertRows(at: [indexPath], with: .automatic)
            reorderDelegate?.moveRow(at: currentLocationIndexPath, to: indexPath)
            self.currentLocationIndexPath = indexPath
            endUpdates()
        }
    }

    // https://github.com/bvogelzang/BVReorderTableView/blob/master/BVReorderTableView.m

    fileprivate func rectOffset(_ rect: CGRect, _ offsetX: CGFloat, _ offsetY: CGFloat) -> CGRect {
        var newRect = rect
        newRect.origin.x += offsetX
        newRect.origin.y += offsetY
        return newRect
    }
}
