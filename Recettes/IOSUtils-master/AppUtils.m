//
//  AppUtils.m
//  Flipper
//
//  Created by Todd Vanderlin on 4/25/12.
//  Copyright (c) 2012 Interactive Design. All rights reserved.
//

#import "AppUtils.h"

@implementation AppUtils

// ---------------------------------------------------------------
// Translate a view
// ---------------------------------------------------------------
+(void)translateView:(UIView *)view position:(CGPoint)position {
    if(view) {
        CGRect rect = view.frame;
        rect.origin = position;
        view.frame = rect;
    }
}

// ---------------------------------------------------------------
// Map a value 
// ---------------------------------------------------------------
+(CGFloat) map:(CGFloat)value 
      inputMin:(CGFloat)inputMin 
      inputMax:(CGFloat)inputMax 
     outputMin:(CGFloat)outputMin
     outputMax:(CGFloat)outputMax
         clamp:(BOOL)clamp {
    
    if (fabs(inputMin - inputMax) < FLT_EPSILON){
		return outputMin;
	} else {
		float outVal = ((value - inputMin) / (inputMax - inputMin) * (outputMax - outputMin) + outputMin);
        
		if( clamp ){
			if(outputMax < outputMin){
				if( outVal < outputMax )outVal = outputMax;
				else if( outVal > outputMin )outVal = outputMin;
			}else{
				if( outVal > outputMax )outVal = outputMax;
				else if( outVal < outputMin )outVal = outputMin;
			}
		}
		return outVal;
	}
    
}

// ---------------------------------------------------------------
// random min/max
// ---------------------------------------------------------------
+ (CGFloat)clamp:(CGFloat)value min:(CGFloat)min max:(CGFloat)max {
    return value < min ? min : value > max ? max : value;
}

// ---------------------------------------------------------------
// random min/max
// ---------------------------------------------------------------
+ (CGFloat)random:(CGFloat)x y:(CGFloat)y {
	float high = 0;
	float low  = 0;
	float randNum = 0;
	// if there is no range, return the value
	if (x == y) return x;// float == ?, wise? epsilon?
	high = MAX(x,y);
	low = MIN(x,y);
	randNum = low + ((high-low) * rand()/(RAND_MAX + 1.0));
	return randNum;
}


// ---------------------------------------------------------------
// random max
// ---------------------------------------------------------------
+ (CGFloat)random:(CGFloat)max {
	return max * rand() / (RAND_MAX + 1.0f);
}

// ---------------------------------------------------------------
// random color
// ---------------------------------------------------------------
+ (UIColor*)randomColor {
    return [UIColor colorWithRed:[AppUtils random:1] green:[AppUtils random:1] blue:[AppUtils random:1] alpha:1];
}


// ---------------------------------------------------------------
// make the first letter uppercase
// ---------------------------------------------------------------
+ (NSString*)upperCaseFirstLetter:(NSString *)word {
    return [word stringByReplacingCharactersInRange:NSMakeRange(0,1)  
                                         withString:[[word  substringToIndex:1] capitalizedString]];
}
// ---------------------------------------------------------------
// Read & Write text file
// ---------------------------------------------------------------
+ (void)writeFile:(NSString *)fileName data:(id)data {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSError *error=NULL;

    [data writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:&error];

    if (error != NULL) {
        //Check Error Here. if any.
    }
}

+(NSString *)readFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:appFile])
    {
        NSError *error= NULL;
        id resultData=[NSString stringWithContentsOfFile:appFile encoding:NSUTF8StringEncoding error:&error];
        if (error == NULL)
        {
            return resultData;
        }
    }
    return NULL;
}

+(void)saveImageFromDocuments: (UIImage*)image withName:(NSString*)filename {
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithString: filename] ];
        NSData* data = UIImageJPEGRepresentation(image, 1);
        [data writeToFile:path atomically:YES];
    }
}
+ (UIImage*)loadImageFromDocuments:(NSString*)filename {
    if(filename == nil || [filename isEqualToString:@""]) return nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString: filename] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+ (BOOL)removeFileFromDocuments:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success =[fileManager removeItemAtPath:filePath error:&error];
    return success;
}

+ (void)addParam:(NSString**)url key:(NSString*)key value:(NSString*)value {
    NSMutableString * temp = [NSMutableString stringWithString:*url];
    if ([temp rangeOfString:@"?"].location == NSNotFound) {
        [temp appendFormat:@"?%@=%@", key, value];
    }
    else {
        [temp appendFormat:@"&%@=%@", key, value];
    }
    *url = [NSString stringWithString:temp];
}

@end














