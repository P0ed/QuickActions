@import Foundation;
#import "BMSaflyCallBlock.h"


@class PMKPromise;


@interface BMCommand : NSObject

/**
 * @param block may take one parameter (input from execute: method)
 * and return AnyObject, Promise or Void
 */
+ (instancetype)commandWithBlock:(BMBlock)block;

/**
 * Executes block passing input as parameter
 * @return Promise wrapping results of block execution
 */
- (PMKPromise *)execute:(id)input;

@end
