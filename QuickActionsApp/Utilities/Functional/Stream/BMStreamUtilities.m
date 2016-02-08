#import "BMStreamUtilities.h"


BMSink bm_print_fmt(NSString *fmt) {
	return ^(id value) {
		NSLog(fmt, value);
	};
};

/// bm_print = bm_print_fmt(@"%@")
BMSink bm_print = ^(id value) {
	NSLog(@"%@", value);
};
