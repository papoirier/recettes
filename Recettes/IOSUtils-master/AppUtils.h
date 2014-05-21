//
//  AppUtils.h
//  Flipper
//
//  Created by Todd Vanderlin on 4/25/12.
//  Copyright (c) 2012 Interactive Design. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef PI
#define PI       3.14159265358979323846
#endif

#ifndef TWO_PI
#define TWO_PI   6.28318530717958647693
#endif

#ifndef M_TWO_PI
#define M_TWO_PI   6.28318530717958647693
#endif

#ifndef FOUR_PI
#define FOUR_PI 12.56637061435917295385
#endif

#ifndef HALF_PI
#define HALF_PI  1.57079632679489661923
#endif

#ifndef DEG_TO_RAD
#define DEG_TO_RAD (PI/180.0)
#endif

#ifndef RAD_TO_DEG
#define RAD_TO_DEG (180.0/PI)
#endif

#ifndef MIN
#define MIN(x,y) (((x) < (y)) ? (x) : (y))
#endif

#ifndef MAX
#define MAX(x,y) (((x) > (y)) ? (x) : (y))
#endif

#ifndef CLAMP
#define CLAMP(val,min,max) (MAX(MIN(val,max),min))
#endif

#ifndef ABS
#define ABS(x) (((x) < 0) ? -(x) : (x))
#endif

// ----------------------------------------------------------------
typedef void (^BasicBlock)(void);

// ----------------------------------------------------------------
static void printAllFonts() {
    for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"%@", fontName);
        }
    }
}


// ----------------------------------------------------------------
@interface AppUtils : NSObject

+ (CGFloat) map:(CGFloat)value 
       inputMin:(CGFloat)inputMin 
       inputMax:(CGFloat)inputMax 
      outputMin:(CGFloat)outputMin
      outputMax:(CGFloat)outputMax
          clamp:(BOOL)clamp;

+ (CGFloat)clamp:(CGFloat)value min:(CGFloat)min max:(CGFloat)max;
+ (CGFloat)random:(CGFloat)max;
+ (CGFloat)random:(CGFloat)x y:(CGFloat)y;
+ (UIColor*)randomColor;
+ (NSString*)upperCaseFirstLetter:(NSString*)word;
+ (void)translateView:(UIView*)view position:(CGPoint)position;

+ (void)writeFile:(NSString *)fileName data:(id)data;
+ (NSString *)readFile:(NSString *)fileName;
+ (void)saveImageFromDocuments:(UIImage*)image withName:(NSString*)filename;
+ (UIImage*)loadImageFromDocuments:(NSString*)filename;
+ (BOOL)removeFileFromDocuments:(NSString *)fileName;
+ (void)addParam:(NSString**)url key:(NSString*)key value:(NSString*)value;

@end


#pragma mark --- UITextView ---
@interface UITextView (UITextViewExtension)
-(void)actLikeTextLabel;
@end
@implementation UITextView (UITextViewExtension)
-(void)actLikeTextLabel {
    self.selectable = NO;
    self.scrollEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}
@end


#pragma mark --- UIView ---
@interface UIView (UIViewExtension)
-(void)translate:(CGPoint)position;
-(CALayer*)getSublayerNamed:(NSString*)name;
-(CGPoint) getTopRight;
-(CGPoint) getTopLeft;
-(CGPoint) getBottomRight;
-(CGPoint) getBottomLeft;

-(CGPoint) getMiddleRight;
-(CGPoint) getMiddleLeft;

-(CALayer*)addTopBorder:(UIColor*)color;
-(CALayer*)addBottomBorder:(UIColor*)color;
-(CALayer*)addRightBorder:(UIColor*)color;
-(CALayer*)addLeftBorder:(UIColor*)color;
-(void)removeLayerName:(NSString*)name;
-(void)setWidth:(CGFloat)width;
-(void)setHeight:(CGFloat)height;

-(void)setWidth:(CGFloat)width andHeight:(CGFloat)height;
-(void)fadeToAlpha:(CGFloat)alpha speed:(CGFloat)speed delay:(CGFloat)delay onComplete:(BasicBlock)completeBlock;

@end
@implementation UIView (UIViewExtension)
-(void)fadeToAlpha:(CGFloat)alpha speed:(CGFloat)speed delay:(CGFloat)delay onComplete:(BasicBlock)completeBlock {
    [UIView animateWithDuration:speed delay:delay options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = alpha;
    } completion:^(BOOL fin) {
        if(completeBlock) completeBlock();
    }];
}
-(void)translate:(CGPoint)position {
    CGRect r = self.frame;
    r.origin = position;
    self.frame = r;
}
-(CALayer*) getSublayerNamed:(NSString *)name {
    for(CALayer * ca in self.layer.sublayers) {
        if([ca.name isEqualToString:name]) return ca;
    }
    return nil;
}
-(void)removeLayerName:(NSString *)name {
    for(CALayer * ca in self.layer.sublayers) {
        if([ca.name isEqualToString:name]) [ca removeFromSuperlayer];
    }
}
-(CGPoint) getTopLeft {
    return CGPointMake(self.frame.origin.x, self.frame.origin.y);
}
-(CGPoint) getBottomLeft {
    return CGPointMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
}
-(CGPoint) getTopRight {
    return CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y);
}
-(CGPoint) getBottomRight {
    return CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y+self.frame.size.height);
}
-(CGPoint) getMiddleRight {
    return CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y+(self.frame.size.height/2));
}
-(CGPoint) getMiddleLeft {
    return CGPointMake(self.frame.origin.x, self.frame.origin.y+(self.frame.size.height/2));
}

-(CALayer*) addTopBorder:(UIColor*)color {
    CALayer * stroke = [CALayer layer];
    [stroke setName:@"top_border_stoke"];
    for(CALayer * ca in self.layer.sublayers) {
        if([ca.name isEqualToString:@"top_border_stroke"]) [ca removeFromSuperlayer];
    }
    stroke.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    stroke.backgroundColor = color.CGColor;
    [self.layer addSublayer:stroke];
    return stroke;
}
-(CALayer*) addBottomBorder:(UIColor*)color {
    CALayer * stroke = [CALayer layer];
    [stroke setName:@"bottom_border_stoke"];
    for(CALayer * ca in self.layer.sublayers) {
        if([ca.name isEqualToString:@"bottom_border_stoke"]) [ca removeFromSuperlayer];
    }
    stroke.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    stroke.backgroundColor = color.CGColor;
    [self.layer addSublayer:stroke];
    return stroke;
}
-(CALayer*) addRightBorder:(UIColor*)color {
    CALayer * stroke = [CALayer layer];
    [stroke setName:@"right_border_stoke"];
    NSArray * ar = self.layer.sublayers;
    if(ar) {
        for(int i=0; i<ar.count; i++) {
            CALayer * ca = [ar objectAtIndex:i];
            if(ca && [ca.name isEqualToString:@"right_border_stoke"]) [ca removeFromSuperlayer];
        }
    }
    stroke.frame = CGRectMake(self.frame.size.width, 0, 1, self.frame.size.height);
    stroke.backgroundColor = color.CGColor;
    [self.layer addSublayer:stroke];
    return stroke;
}
-(CALayer*) addLeftBorder:(UIColor*)color {
    CALayer * stroke = [CALayer layer];
    [stroke setName:@"left_border_stoke"];
    for(CALayer * ca in self.layer.sublayers) {
        if([ca.name isEqualToString:@"left_border_stoke"]) [ca removeFromSuperlayer];
    }
    stroke.frame = CGRectMake(0, 0, 1, self.frame.size.height);
    stroke.backgroundColor = color.CGColor;
    [self.layer addSublayer:stroke];
    return stroke;
}
-(void)setWidth:(CGFloat)width andHeight:(CGFloat)height {
    CGRect rec = self.frame;
    rec.size = CGSizeMake(width, height);
    self.frame = rec;
}
-(void)setWidth:(CGFloat)width {
    [self setWidth:width andHeight:self.frame.size.height];
}
-(void)setHeight:(CGFloat)height {
    [self setWidth:self.frame.size.width andHeight:height];
}

@end


#pragma mark --- UIImage ---
//--------------------------------------------------------------
// UIImage Extensions
//--------------------------------------------------------------
@interface UIImage (UIImageExtension)
- (UIImage *)crop:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
@implementation UIImage (UIImageExtension)
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}
- (UIImage *)crop:(CGRect)rect {
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    float hRatio = image.size.height / image.size.width;
    //float vRatio = image.size.width / image.size.height;
    
    
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.width*hRatio)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

@interface UIImageView (UIImageViewExtension)
+(UIImageView*) imageViewWithImageNamed:(NSString*)filename;
@end
@implementation UIImageView (UIImageViewExtension)
+(UIImageView*) imageViewWithImageNamed:(NSString *)filename {
    UIImage * img = [UIImage imageNamed:filename];
    return [[UIImageView alloc] initWithImage:img];
}
@end

#pragma mark --- UIColor ---
//--------------------------------------------------------------
// UIColor Extensions
//--------------------------------------------------------------
@interface UIColor (Extensions)
+ (UIColor *)colorWithHex:(int)hexColor alpha:(CGFloat)alpha;
+ (UIColor *)colorWithColor:(UIColor*)color alpha:(CGFloat)alpha;
@end

@implementation UIColor (Extensions)
+ (UIColor *)colorWithHex:(int)hexColor alpha:(CGFloat)alpha {
    double r = (hexColor >> 16) & 0xff;
	double g = (hexColor >> 8) & 0xff;
	double b = (hexColor >> 0) & 0xff;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
}
+ (UIColor *)colorWithColor:(UIColor*)color alpha:(CGFloat)alpha {
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}
@end

#pragma mark --- NSDate ---
//--------------------------------------------------------------
// NSDate Extensions
//--------------------------------------------------------------
@interface NSDate (DateExtensions)
- (NSDate*)beginningOfDay;
- (NSDate*)endOfDay;
- (NSInteger)getDay;
- (NSInteger)getMonth;
- (NSInteger)getYear;

-(NSInteger)getHour;
-(NSInteger)getMinutes;
-(NSInteger)getSeconds;
-(NSInteger)getDayOfYear;

- (BOOL)isMidnight;
@end
@implementation NSDate (DateExtensions)

-(NSInteger)getDayOfYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"D"];
    NSUInteger dayOfYear = [[formatter stringFromDate:self] intValue];
    return dayOfYear;
}
- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    return [calendar dateFromComponents:components];
}
- (NSDate *)endOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    
    return [[calendar dateByAddingComponents:components toDate:[self beginningOfDay] options:0] dateByAddingTimeInterval:-1];
}
-(NSInteger)getDay {
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    return [components day];
}
-(NSInteger)getMonth {
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    return [components month];
}
-(NSInteger)getYear {
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    return [components year];
}
-(NSInteger)getHour {
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSCalendarUnitSecond | NSCalendarUnitMinute fromDate:self];
    return [components hour];
    
}
-(NSInteger)getMinutes {
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSCalendarUnitSecond | NSCalendarUnitMinute fromDate:self];
    return [components minute];
}
-(NSInteger)getSeconds {
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSCalendarUnitSecond | NSCalendarUnitMinute fromDate:self];
    return [components second];
}
-(BOOL)isMidnight {
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSCalendarUnitSecond | NSCalendarUnitMinute fromDate:self];
    return [components hour] == 0;
}
@end

#pragma mark --- NSDictionary ---
//--------------------------------------------------------------
// NSDictionary Extensions
//--------------------------------------------------------------
@interface NSDictionary (NSDictionaryExtensions)
- (id)objectForKeyNotNull : (id)key;
@end
@implementation NSDictionary (NSDictionaryExtensions)
- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null]) return nil;
    return object;
}
@end



#pragma mark --- NSString ---
//--------------------------------------------------------------
// NSString Extensions
//--------------------------------------------------------------
@interface NSString (NSStringExtensions)
+(NSString*)stringWithInt:(NSInteger)intValue;
@end
@implementation NSString (NSStringExtensions)
+(NSString*)stringWithInt:(NSInteger)intValue {
    return [NSString stringWithFormat:@"%i", intValue];
}
@end






#pragma mark --- NSString ---
//--------------------------------------------------------------
// NSAttributedString Extensions
//--------------------------------------------------------------


/*@implementation NSAttributedString (Geometrics)

#pragma mark * Measure Attributed String

- (NSSize)sizeForWidth:(float)width
				height:(float)height {
	NSSize answer = NSZeroSize ;
    if ([self length] > 0) {
		// Checking for empty string is necessary since Layout Manager will give the nominal
		// height of one line if length is 0.  Our API specifies 0.0 for an empty string.
		NSSize size = NSMakeSize(width, height) ;
		NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:size] ;
		NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self] ;
		NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init] ;
		[layoutManager addTextContainer:textContainer] ;
		[textStorage addLayoutManager:layoutManager] ;
		[layoutManager setHyphenationFactor:0.0] ;
		if (gNSStringGeometricsTypesetterBehavior != NSTypesetterLatestBehavior) {
			[layoutManager setTypesetterBehavior:gNSStringGeometricsTypesetterBehavior] ;
		}
		// NSLayoutManager is lazy, so we need the following kludge to force layout:
		[layoutManager glyphRangeForTextContainer:textContainer] ;
        
		answer = [layoutManager usedRectForTextContainer:textContainer].size ;
#if NO_ARC
		[textStorage release] ;
		[textContainer release] ;
#endif
		// Adjust if there is extra height for the cursor
		NSSize extraLineSize = [layoutManager extraLineFragmentRect].size ;
		if (extraLineSize.height > 0) {
			answer.height -= extraLineSize.height ;
		}
		
#if NO_ARC
		[layoutManager release] ;
#endif
		// In case we changed it above, set typesetterBehavior back
		// to the default value.
		gNSStringGeometricsTypesetterBehavior = NSTypesetterLatestBehavior ;
	}
    
	return answer ;
}

- (float)heightForWidth:(float)width {
	return [self sizeForWidth:width
					   height:FLT_MAX].height ;
}

- (float)widthForHeight:(float)height {
	return [self sizeForWidth:FLT_MAX
					   height:height].width ;
}

@end


@implementation NSString (Geometrics)

#pragma mark * Given String with Attributes

- (NSSize)sizeForWidth:(float)width
				height:(float)height
			attributes:(NSDictionary*)attributes {
	NSSize answer ;
    
	NSAttributedString *astr = [[NSAttributedString alloc] initWithString:self
															   attributes:attributes] ;
	answer = [astr sizeForWidth:width
						 height:height] ;
#if NO_ARC
	[astr release] ;
#endif
    
	return answer ;
}

- (float)heightForWidth:(float)width
			 attributes:(NSDictionary*)attributes {
	return [self sizeForWidth:width
					   height:FLT_MAX
				   attributes:attributes].height ;
}

- (float)widthForHeight:(float)height
			 attributes:(NSDictionary*)attributes {
	return [self sizeForWidth:FLT_MAX
					   height:height
				   attributes:attributes].width ;
}

#pragma mark * Given String with Font

- (NSSize)sizeForWidth:(float)width
				height:(float)height
				  font:(NSFont*)font {
	NSSize answer = NSZeroSize ;
    
	if (font == nil) {
		NSLog(@"[%@ %@]: Internal Error 561-3810: Nil font", [self class], NSStringFromSelector(_cmd)) ;
	}
	else {
		NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									font, NSFontAttributeName, nil] ;
		answer = [self sizeForWidth:width
							 height:height
						 attributes:attributes] ;
	}
    
	return answer ;
}

- (float)heightForWidth:(float)width
				   font:(NSFont*)font {
	return [self sizeForWidth:width
					   height:FLT_MAX
						 font:font].height ;
}

- (float)widthForHeight:(float)height
				   font:(NSFont*)font {
	return [self sizeForWidth:FLT_MAX
					   height:height
						 font:font].width ;
}

*/


//--------------------------------------------------------------
// AppURLConnection
//--------------------------------------------------------------
/*@interface AppURLConnection: NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSURLConnection * internalConnection;
    NSMutableData * container;
}
-(id)initWithRequest:(NSURLRequest *)req;
@property (nonatomic,copy)NSURLConnection * internalConnection;
@property (nonatomic,copy)NSURLRequest *request;
@property (nonatomic,copy)void (^completitionBlock) (id obj, NSError * err);
-(void)start;
@end

static NSMutableArray *sharedConnectionList = nil;

@implementation AppURLConnection
@synthesize request,completitionBlock,internalConnection;

-(id)initWithRequest:(NSURLRequest *)req {
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}

-(void)start {
    
    container = [[NSMutableData alloc]init];
    
    internalConnection = [[NSURLConnection alloc]initWithRequest:[self request] delegate:self startImmediately:YES];
    
    if(!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    [sharedConnectionList addObject:self];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [container appendData:data];
}

//If finish, return the data and the error nil
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if([self completitionBlock])
        [self completitionBlock](container,nil);
    
    [sharedConnectionList removeObject:self];
    
}

//If fail, return nil and an error
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if([self completitionBlock])
        [self completitionBlock](nil,error);
    
    [sharedConnectionList removeObject:self];
    
}

@end*/
























