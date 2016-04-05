/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import SnapKit

class URLToolbar: UIView {
    var curveRightButtons = [UIButton]() {
        didSet {
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }

    var insideRightButtons = [UIButton]()
    var insideLeftButtons = [UIButton]()
    let locationInputView = ToolbarTextField()

    private let curveRightButtonContainer = UIView()
    private let insideRightButtonContainer = UIView()
    private let insideLeftButtonContainer = UIView()

    private let curveBackgroundView = CurveBackgroundView()

    private let buttonWidth: CGFloat = 44

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(curveBackgroundView)
        addSubview(curveRightButtonContainer)
        addSubview(insideRightButtonContainer)
        addSubview(insideLeftButtonContainer)
        addSubview(locationInputView)

        curveRightButtonContainer.backgroundColor = .redColor()
        insideRightButtonContainer.backgroundColor = .blueColor()
        insideLeftButtonContainer.backgroundColor = .yellowColor()
        locationInputView.backgroundColor = .purpleColor()
    }

    override func updateConstraints() {
        super.updateConstraints()
        curveRightButtonContainer.snp_remakeConstraints { make in
            make.top.bottom.right.equalTo(self)
            make.width.equalTo(buttonWidth * CGFloat(curveRightButtons.count))
        }

        curveBackgroundView.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self)
            make.right.equalTo(curveRightButtonContainer.snp_left)
        }

        insideRightButtonContainer.snp_remakeConstraints { make in
            make.top.bottom.equalTo(curveBackgroundView)
            make.right.equalTo(curveBackgroundView).offset(-40)
            make.width.equalTo(buttonWidth * CGFloat(insideRightButtons.count))
        }

        insideLeftButtonContainer.snp_remakeConstraints { make in
            make.top.bottom.equalTo(curveBackgroundView)
            make.left.equalTo(curveBackgroundView).offset(10)
            make.width.equalTo(buttonWidth * CGFloat(insideLeftButtons.count))
        }

        locationInputView.snp_remakeConstraints { make in
            make.left.equalTo(insideLeftButtonContainer.snp_right)
            make.right.equalTo(insideRightButtonContainer.snp_left)
            make.top.bottom.equalTo(curveBackgroundView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class CurveBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .Redraw
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        CGContextClearRect(context, rect)
        drawBackgroundCurveInsideRect(rect, context: context)
    }

    private func drawBackgroundCurveInsideRect(rect: CGRect, context: CGContext) {
        CGContextSaveGState(context)
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)

        // Curve's aspect ratio
        let ASPECT_RATIO: CGFloat = 0.729

        // Width multipliers
        let W_M1: CGFloat = 0.343
        let W_M2: CGFloat = 0.514
        let W_M3: CGFloat = 0.49
        let W_M4: CGFloat = 0.545
        let W_M5: CGFloat = 0.723

        // Height multipliers
        let H_M1: CGFloat = 0.25
        let H_M2: CGFloat = 0.5
        let H_M3: CGFloat = 0.72
        let H_M4: CGFloat = 0.961

        let height = rect.height
        let width = rect.width
        let curveStart = CGPoint(x: width - 32, y: 0)
        let curveWidth = height * ASPECT_RATIO

        let path = UIBezierPath()
        // Start from the bottom-left
        path.moveToPoint(CGPoint(x: 0, y: height))
        path.addLineToPoint(CGPoint(x: 0, y: 5))

        // Left curved corner
        path.addArcWithCenter(CGPoint(x: 5, y: 5), radius: 5, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI + M_PI_2), clockwise: true)
        path.addLineToPoint(CGPoint(x: width - 32, y: 0))

        // Add tab curve on the right side
        path.addCurveToPoint(CGPoint(x: curveStart.x + curveWidth * W_M2, y: curveStart.y + height * H_M2),
                             controlPoint1: CGPoint(x: curveStart.x + curveWidth * W_M1, y: curveStart.y),
                             controlPoint2: CGPoint(x: curveStart.x + curveWidth * W_M3, y: curveStart.y + height * H_M1))
        path.addCurveToPoint(CGPoint(x: curveStart.x + curveWidth, y: curveStart.y + height),
              controlPoint1: CGPoint(x: curveStart.x + curveWidth * W_M4, y: curveStart.y + height * H_M3),
              controlPoint2: CGPoint(x: curveStart.x + curveWidth * W_M5, y: curveStart.y + height * H_M4))
        path.addLineToPoint(CGPoint(x: width, y: height))
        path.closePath()

        CGContextAddPath(context, path.CGPath)
        CGContextFillPath(context)
        CGContextRestoreGState(context)
    }
}
