//
//  BarChartView.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 4/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

/// Chart that draws bars.
public class BarChartView: BarLineChartViewBase, BarChartDataProvider
{
    /// if set to true, all values are drawn above their bars, instead of below their top
    private var _drawValueAboveBarEnabled = true

    /// if set to true, a grey area is drawn behind each bar that indicates the maximum value
    private var _drawBarShadowEnabled = false
    
    internal override func initialize()
    {
        super.initialize()
        
        renderer = BarChartRenderer(dataProvider: self, animator: _animator, viewPortHandler: _viewPortHandler)
        
        self.highlighter = BarChartHighlighter(chart: self)
    }
    
    internal override func calcMinMax()
    {
        guard let data = self.data as? BarChartData
            else { return }
        
        if self.autoScaleMinMaxEnabled
        {
            data.calcMinMax()
        }
        
        if fitBars
        {
            _xAxis.calculate(
                min: data.xMin - data.barWidth / 2.0,
                max: data.xMax - data.barWidth / 2.0)
        }
        else
        {
            _xAxis.calculate(min: data.xMin, max: data.xMax)
        }
        
        // calculate axis range (min / max) according to provided data
        _leftAxis.calculate(
            min: data.getYMin(.Left),
            max: data.getYMax(.Left))
        _rightAxis.calculate(
            min: data.getYMin(.Right),
            max: data.getYMax(.Right))
    }
    
    /// - returns: the Highlight object (contains x-index and DataSet index) of the selected value at the given touch point inside the BarChart.
    public override func getHighlightByTouchPoint(pt: CGPoint) -> ChartHighlight?
    {
        if _data === nil
        {
            Swift.print("Can't select by touch. No data set.")
            return nil
        }

        return self.highlighter?.getHighlight(x: pt.x, y: pt.y)
    }
        
    /// - returns: the bounding box of the specified Entry in the specified DataSet. Returns null if the Entry could not be found in the charts data.
    public func getBarBounds(e: BarChartDataEntry) -> CGRect
    {
        guard let
            data = _data as? BarChartData,
            set = data.getDataSetForEntry(e) as? IBarChartDataSet
            else { return CGRectNull }
        
        let y = e.y
        let x = e.x
        
        let barWidth = data.barWidth
        
        let left = x - barWidth / 2.0
        let right = x + barWidth / 2.0
        let top = y >= 0.0 ? y : 0.0
        let bottom = y <= 0.0 ? y : 0.0
        
        var bounds = CGRect(x: left, y: top, width: right - left, height: bottom - top)
        
        getTransformer(set.axisDependency).rectValueToPixel(&bounds)
        
        return bounds
    }
    
    /// Groups all BarDataSet objects this data object holds together by modifying the x-position of their entries.
    /// Leaves space as specified by the parameters.
    /// Calls `notifyDataSetChanged()` afterwards.
    ///
    /// - parameter fromX: the starting point on the x-axis where the grouping should begin
    /// - parameter groupSpace: the space between groups of bars in values (not pixels) e.g. 0.8f for bar width 1f
    /// - parameter barSpace: the space between individual bars in values (not pixels) e.g. 0.1f for bar width 1f
    public func groupBars(fromX fromX: Double, groupSpace: Double, barSpace: Double)
    {
        guard let barData = self.barData
            else
        {
            print("You need to set data for the chart before grouping bars.", terminator: "\n")
            return
        }
        
        barData.groupBars(fromX: fromX, groupSpace: groupSpace, barSpace: barSpace)
        notifyDataSetChanged()
    }

    // MARK: Accessors
    
    /// if set to true, all values are drawn above their bars, instead of below their top
    public var drawValueAboveBarEnabled: Bool
    {
        get { return _drawValueAboveBarEnabled; }
        set
        {
            _drawValueAboveBarEnabled = newValue
            setNeedsDisplay()
        }
    }
    
    /// if set to true, a grey area is drawn behind each bar that indicates the maximum value
    public var drawBarShadowEnabled: Bool
    {
        get { return _drawBarShadowEnabled; }
        set
        {
            _drawBarShadowEnabled = newValue
            setNeedsDisplay()
        }
    }
    
    /// Adds half of the bar width to each side of the x-axis range in order to allow the bars of the barchart to be fully displayed.
    /// **default**: false
    public var fitBars = false
    
    // MARK: - BarChartDataProbider
    
    public var barData: BarChartData? { return _data as? BarChartData }
    
    /// - returns: true if drawing values above bars is enabled, false if not
    public var isDrawValueAboveBarEnabled: Bool { return drawValueAboveBarEnabled }
    
    /// - returns: true if drawing shadows (maxvalue) for each bar is enabled, false if not
    public var isDrawBarShadowEnabled: Bool { return drawBarShadowEnabled }
}