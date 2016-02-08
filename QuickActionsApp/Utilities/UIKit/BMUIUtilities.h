#import "UIColor+BMColor.h"
#import "UIFont+BMFont.h"
#import "UIColor+Hex.h"
#import "UIButton+BMCommand.h"
#import <PureLayout.h>

// MARK: tmp imports
#import "UILabel+MuseoFont.h"
#import "UIView+Extensions.h"
#import <SVProgressHUD.h>

#define BMShowHUD()			[SVProgressHUD show]
#define BMHideHUD()			[SVProgressHUD dismiss]
#define BMShowSuccess(msg)	[SVProgressHUD showSuccessWithStatus:msg]
#define BMShowError(msg)	[SVProgressHUD showErrorWithStatus:msg]

#define BMShowAlertWithMessage(msg) \
[[UIAlertView.alloc initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]
