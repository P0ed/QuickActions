@import Foundation;
@import CoreGraphics.CGBase;


@class BMStream<A>;
@class PMKPromise;


@interface BMTransitionProgress : NSObject

//@property (readonly, nonatomic) CGFloat progress;
//@property (readonly, nonatomic) BOOL complete;
//@property (readonly, nonatomic) BOOL cancelled;

@property (readonly, nonatomic) BMStream<NSNumber *> *progress;
@property (copy, nonatomic) void (^completionHandler)(void);
@property (copy, nonatomic) void (^cancellationHandler)(void);

- (instancetype)initWithBlock:(void (^)(void (^setProgress)(CGFloat), void (^close)(BOOL isComplete)))block;

@end
