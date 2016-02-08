@import Foundation;


@class PMKPromise;

/**
 Rejects pending promise when deallocated.
 */
@interface BMPromiseResolver : NSObject

@property (readonly) PMKPromise *promise;

- (void)resolve:(id)value;

@end
