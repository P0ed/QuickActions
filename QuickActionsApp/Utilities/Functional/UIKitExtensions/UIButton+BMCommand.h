@import UIKit;


@class BMCommand;


@interface UIButton (BMCommand)

@property (nonatomic, setter=bm_setCommand:) BMCommand *bm_command;

@end
