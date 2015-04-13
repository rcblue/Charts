//
//  BubbleChartDataSet.swift
//  Charts
//
//  Created by Pierre-Marc Airoldi on 2015-04-07.
//  Copyright (c) 2015 Pierre-Marc Airoldi. All rights reserved.
//

import Foundation
import CoreGraphics;

public class BubbleChartDataSet: BarLineScatterCandleChartDataSet
{
    internal var _xMax = Float(0.0)
    internal var _xMin = Float(0.0)
    internal var _maxSize = Float(1.0)

    public var xMin: Float { return _xMin }
    public var xMax: Float { return _xMax }
    public var maxSize: Float { return _maxSize }
    
    public override func setColor(color: UIColor)
    {
        super.setColor(color.colorWithAlphaComponent(0.5))
    }
    
    internal override func calcMinMax()
    {
        let entries = yVals as! [BubbleChartDataEntry];
    
        //need chart width to guess this properly
        
        for entry in entries
        {
            let ymin = yMin(entry)
            let ymax = yMax(entry)
            
            if (ymin < _yMin)
            {
                _yMin = ymin
            }
            
            if (ymax > _yMax)
            {
                _yMax = ymax;
            }
            
            let xmin = xMin(entry)
            let xmax = xMax(entry)
            
            if (xmin < _xMin)
            {
                _xMin = xmin;
            }
            
            if (xmax > _xMax)
            {
                _xMax = xmax;
            }

            let size = largestSize(entry)
            
            if (size > _maxSize)
            {
                _maxSize = size
            }
        }
    }
    
    private func yMin(entry: BubbleChartDataEntry) -> Float {
        return entry.value
    }
    
    private func yMax(entry: BubbleChartDataEntry) -> Float {
        return entry.value
    }
    
    private func xMin(entry: BubbleChartDataEntry) -> Float {
        return Float(entry.xIndex)
    }
    
    private func xMax(entry: BubbleChartDataEntry) -> Float {
        return Float(entry.xIndex)
    }
    
    private func largestSize(entry: BubbleChartDataEntry) -> Float {
        return entry.size
    }
}
