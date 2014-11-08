//
//  CurvedScatterPlot.m
//  Plot_Gallery_iOS
//
//  Created by Nino Ag on 23/10/11.

#import "CurvedScatterPlot.h"

NSString *const kData   = @"Data Source Plot";
NSString *const kFirst  = @"First Derivative";
NSString *const kSecond = @"Second Derivative";

@implementation CurvedScatterPlot

+(void)load
{
    [super registerPlotItem:self];
}

-(id)init
{
    if ( (self = [super init]) ) {
        self.title   = @"Curved Scatter Plot";
        self.section = kLinePlots;
    }

    return self;
}

-(void)killGraph
{
    if ( [self.graphs count] ) {
        CPTGraph *graph = [self.graphs objectAtIndex:0];

        if ( symbolTextAnnotation ) {
            [graph.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
            [symbolTextAnnotation release];
            symbolTextAnnotation = nil;
        }
    }

    [super killGraph];
}

-(void)generateData
{
    if ( plotData == nil ) {
        NSMutableArray *contentArray = [NSMutableArray array];

        for ( NSUInteger i = 0; i < 11; i++ ) {
            NSNumber *x = [NSNumber numberWithDouble:1.0 + i * 0.05];
            NSNumber *y = [NSNumber numberWithDouble:1.2 * rand() / (double)RAND_MAX + 0.5];
            [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
        }

        plotData = [contentArray retain];
    }

    if ( plotData1 == nil ) {
        NSMutableArray *contentArray = [NSMutableArray array];

        for ( NSUInteger i = 1; i < plotData.count; i++ ) {
            NSDictionary *point1 = [plotData objectAtIndex:i - 1];
            NSDictionary *point2 = [plotData objectAtIndex:i];

            double x1   = [(NSNumber *)[point1 objectForKey:@"x"] doubleValue];
            double x2   = [(NSNumber *)[point2 objectForKey:@"x"] doubleValue];
            double dx   = x2 - x1;
            double xLoc = (x1 + x2) * 0.5;

            double y1 = [(NSNumber *)[point1 objectForKey:@"y"] doubleValue];
            double y2 = [(NSNumber *)[point2 objectForKey:@"y"] doubleValue];
            double dy = y2 - y1;

            [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSDecimalNumber numberWithDouble:xLoc], @"x",
                                     [NSDecimalNumber numberWithDouble:(dy / dx) / 20.0], @"y", nil]];
        }

        plotData1 = [contentArray retain];
    }

    if ( plotData2 == nil ) {
        NSMutableArray *contentArray = [NSMutableArray array];

        for ( NSUInteger i = 1; i < plotData1.count; i++ ) {
            NSDictionary *point1 = [plotData1 objectAtIndex:i - 1];
            NSDictionary *point2 = [plotData1 objectAtIndex:i];

            double x1   = [(NSNumber *)[point1 objectForKey:@"x"] doubleValue];
            double x2   = [(NSNumber *)[point2 objectForKey:@"x"] doubleValue];
            double dx   = x2 - x1;
            double xLoc = (x1 + x2) * 0.5;

            double y1 = [(NSNumber *)[point1 objectForKey:@"y"] doubleValue];
            double y2 = [(NSNumber *)[point2 objectForKey:@"y"] doubleValue];
            double dy = y2 - y1;

            [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSDecimalNumber numberWithDouble:xLoc], @"x",
                                     [NSDecimalNumber numberWithDouble:(dy / dx) / 20.0], @"y", nil]];
        }

        plotData2 = [contentArray retain];
    }
}

-(void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme animated:(BOOL)animated
{
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    CGRect bounds = layerHostingView.bounds;
#else
    CGRect bounds = NSRectToCGRect(layerHostingView.bounds);
#endif

    CPTGraph *graph = [[[CPTXYGraph alloc] initWithFrame:bounds] autorelease];
    [self addGraph:graph toHostingView:layerHostingView];
    [self applyTheme:theme toGraph:graph withDefault:[CPTTheme themeNamed:kCPTDarkGradientTheme]];

    [self setTitleDefaultsForGraph:graph withBounds:bounds];
    [self setPaddingDefaultsForGraph:graph withBounds:bounds];

    graph.plotAreaFrame.paddingLeft   += 55.0;
    graph.plotAreaFrame.paddingTop    += 40.0;
    graph.plotAreaFrame.paddingRight  += 55.0;
    graph.plotAreaFrame.paddingBottom += 40.0;
    graph.plotAreaFrame.masksToBorder  = NO;

    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate              = self;

    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];

    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];

    CPTMutableLineStyle *redLineStyle = [CPTMutableLineStyle lineStyle];
    redLineStyle.lineWidth = 10.0;
    redLineStyle.lineColor = [[CPTColor redColor] colorWithAlphaComponent:0.5];

    CPTLineCap *lineCap = [CPTLineCap sweptArrowPlotLineCap];
    lineCap.size = CGSizeMake(15.0, 15.0);

    // Axes
    // Label x axis with a fixed interval policy
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength   = CPTDecimalFromDouble(0.1);
    x.minorTicksPerInterval = 4;
    x.majorGridLineStyle    = majorGridLineStyle;
    x.minorGridLineStyle    = minorGridLineStyle;
    x.axisConstraints       = [CPTConstraints constraintWithRelativeOffset:0.5];

    lineCap.lineStyle = x.axisLineStyle;
    lineCap.fill      = [CPTFill fillWithColor:lineCap.lineStyle.lineColor];
    x.axisLineCapMax  = lineCap;

    x.title       = @"X Axis";
    x.titleOffset = 30.0;

    // Label y with an automatic label policy.
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    y.minorTicksPerInterval       = 4;
    y.preferredNumberOfMajorTicks = 8;
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];
    y.labelOffset                 = 10.0;

    lineCap.lineStyle = y.axisLineStyle;
    lineCap.fill      = [CPTFill fillWithColor:lineCap.lineStyle.lineColor];
    y.axisLineCapMax  = lineCap;
    y.axisLineCapMin  = lineCap;

    y.title       = @"Y Axis";
    y.titleOffset = 32.0;

    // Set axes
    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];

    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = kData;

    // Make the data source line use curved interpolation
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationCurved;

    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth              = 3.0;
    lineStyle.lineColor              = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;

    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];

    // First derivative
    CPTScatterPlot *firstPlot = [[[CPTScatterPlot alloc] init] autorelease];
    firstPlot.identifier    = kFirst;
    lineStyle.lineWidth     = 2.0;
    lineStyle.lineColor     = [CPTColor redColor];
    firstPlot.dataLineStyle = lineStyle;
    firstPlot.dataSource    = self;

//    [graph addPlot:firstPlot];

    // Second derivative
    CPTScatterPlot *secondPlot = [[[CPTScatterPlot alloc] init] autorelease];
    secondPlot.identifier    = kSecond;
    lineStyle.lineColor      = [CPTColor blueColor];
    secondPlot.dataLineStyle = lineStyle;
    secondPlot.dataSource    = self;

//    [graph addPlot:secondPlot];

    // Auto scale the plot space to fit the plot data
    [plotSpace scaleToFitPlots:[graph allPlots]];
    CPTMutablePlotRange *xRange = [[plotSpace.xRange mutableCopy] autorelease];
    CPTMutablePlotRange *yRange = [[plotSpace.yRange mutableCopy] autorelease];

    // Expand the ranges to put some space around the plot
    [xRange expandRangeByFactor:CPTDecimalFromDouble(1.2)];
    [yRange expandRangeByFactor:CPTDecimalFromDouble(1.2)];
    plotSpace.xRange = xRange;
    plotSpace.yRange = yRange;

    [xRange expandRangeByFactor:CPTDecimalFromDouble(1.025)];
    xRange.location = plotSpace.xRange.location;
    [yRange expandRangeByFactor:CPTDecimalFromDouble(1.05)];
    x.visibleAxisRange = xRange;
    y.visibleAxisRange = yRange;

    [xRange expandRangeByFactor:CPTDecimalFromDouble(3.0)];
    [yRange expandRangeByFactor:CPTDecimalFromDouble(3.0)];
    plotSpace.globalXRange = xRange;
    plotSpace.globalYRange = yRange;

    // Add plot symbols
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:0.5];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill               = [CPTFill fillWithColor:[[CPTColor blueColor] colorWithAlphaComponent:0.5]];
    plotSymbol.lineStyle          = symbolLineStyle;
    plotSymbol.size               = CGSizeMake(10.0, 10.0);
    dataSourceLinePlot.plotSymbol = plotSymbol;

    // Set plot delegate, to know when symbols have been touched
    // We will display an annotation when a symbol is touched
    dataSourceLinePlot.delegate                        = self;
    dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0f;

    // Add legend
    graph.legend                 = [CPTLegend legendWithGraph:graph];
    graph.legend.numberOfRows    = 1;
    graph.legend.textStyle       = x.titleTextStyle;
    graph.legend.fill            = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
    graph.legend.borderLineStyle = x.axisLineStyle;
    graph.legend.cornerRadius    = 5.0;
    graph.legend.swatchSize      = CGSizeMake(25.0, 25.0);
    graph.legendAnchor           = CPTRectAnchorBottom;
    graph.legendDisplacement     = CGPointMake(0.0, 12.0);
}

-(void)dealloc
{
    [symbolTextAnnotation release];
    [plotData release];
    [super dealloc];
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSUInteger numRecords = 0;
    NSString *identifier  = (NSString *)plot.identifier;

    if ( [identifier isEqualToString:kData] ) {
        numRecords = plotData.count;
    }
    else if ( [identifier isEqualToString:kFirst] ) {
        numRecords = plotData1.count;
    }
    else if ( [identifier isEqualToString:kSecond] ) {
        numRecords = plotData2.count;
    }

    return numRecords;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num        = nil;
    NSString *identifier = (NSString *)plot.identifier;

    if ( [identifier isEqualToString:kData] ) {
        num = [[plotData objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
    }
    else if ( [identifier isEqualToString:kFirst] ) {
        num = [[plotData1 objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
    }
    else if ( [identifier isEqualToString:kSecond] ) {
        num = [[plotData2 objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
    }

    return num;
}

#pragma mark -
#pragma mark Plot Space Delegate Methods

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)space.graph.axisSet;

    CPTMutablePlotRange *changedRange = [[newRange mutableCopy] autorelease];

    switch ( coordinate ) {
        case CPTCoordinateX:
            [changedRange expandRangeByFactor:CPTDecimalFromDouble(1.025)];
            changedRange.location          = newRange.location;
            axisSet.xAxis.visibleAxisRange = changedRange;
            break;

        case CPTCoordinateY:
            [changedRange expandRangeByFactor:CPTDecimalFromDouble(1.05)];
            axisSet.yAxis.visibleAxisRange = changedRange;
            break;

        default:
            break;
    }

    return newRange;
}

#pragma mark -
#pragma mark CPTScatterPlot delegate method

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    CPTXYGraph *graph = [self.graphs objectAtIndex:0];

    if ( symbolTextAnnotation ) {
        [graph.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
        [symbolTextAnnotation release];
        symbolTextAnnotation = nil;
    }

    // Setup a style for the annotation
    CPTMutableTextStyle *hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
    hitAnnotationTextStyle.color    = [CPTColor whiteColor];
    hitAnnotationTextStyle.fontSize = 16.0f;
    hitAnnotationTextStyle.fontName = @"Helvetica-Bold";

    // Determine point of symbol in plot coordinates
    NSNumber *x          = [[plotData objectAtIndex:index] valueForKey:@"x"];
    NSNumber *y          = [[plotData objectAtIndex:index] valueForKey:@"y"];
    NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];

    // Add annotation
    // First make a string for the y value
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setMaximumFractionDigits:2];
    NSString *yString = [formatter stringFromNumber:y];

    // Now add the annotation to the plot area
    CPTTextLayer *textLayer = [[[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle] autorelease];
    symbolTextAnnotation              = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
    symbolTextAnnotation.contentLayer = textLayer;
    symbolTextAnnotation.displacement = CGPointMake(0.0f, 20.0f);
    [graph.plotAreaFrame.plotArea addAnnotation:symbolTextAnnotation];
}

@end
