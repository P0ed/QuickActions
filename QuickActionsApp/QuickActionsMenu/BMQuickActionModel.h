@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@class BMCommand;


@interface BMQuickActionModel : NSObject

@property (readonly, copy, nonatomic) NSString *icon;
@property (readonly, copy, nonatomic) NSString *title;
@property (readonly, nonatomic) BMCommand *action;

+ (instancetype)modelWithIcon:(NSString *)icon title:(NSString *)title action:(BMCommand *)action;

@end

NS_ASSUME_NONNULL_END
