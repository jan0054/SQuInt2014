//
//  Talk_obj.h
//  SQuInt2014
//
//  Created by csjan on 9/15/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session_obj.h"

@interface Talk_obj : NSObject
@property Session_obj *parent_session;
@property NSString *name;
@property NSString *pfobjid;

@end
