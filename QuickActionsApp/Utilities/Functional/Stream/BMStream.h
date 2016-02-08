@import Foundation;


@class BMStream2;
@class PMKPromise;

/// A -> Void
typedef void (^BMSink)(id value);
/// (A, B) -> Void
typedef void (^BMSink2)(id value1, id value2);


@interface BMStream<A> : NSObject

+ (instancetype)create:(void (^)(BMSink sink))block;

/// (A -> B) -> S<B>
- (BMStream *(^)(id (^)(id)))map;
- (BMStream *(^)(id))mapReplace;

/// (A -> S<B>) -> S<B>
- (BMStream *(^)(id (^)(id)))flatMap;
- (BMStream *)flatten;

/// (A -> Bool) -> S<A>
- (BMStream *(^)(BOOL (^)(id)))filter;

- (BMStream *(^)(BMStream *))mergeWith;
- (BMStream2 *(^)(BMStream *))combineLatestWith;
- (BMStream2 *(^)(BMStream *))zipWith;

/// (A -> Void) -> S<A>
- (BMStream *(^)(BMSink))next;

- (BMStream *)distinctUntilChanged;
- (BMStream *)ignoreNils;
- (BMStream *)ignoreErrors;

- (BMStream<NSNumber *> *)not;

- (PMKPromise *)takeOne;

@end


@interface BMStream2<A, B> : NSObject

+ (instancetype)create:(void (^)(BMSink2 sink))block;

/// ((A, B) -> C) -> S<C>
- (BMStream *(^)(id (^)(id, id)))reduce;

- (BMStream<NSNumber *> *)and;
- (BMStream<NSNumber *> *)or;

@end


@interface BMPipe : NSObject

@property (readonly, nonatomic) BMStream *stream;

- (void)put:(id)value;

@end
