//
//  MDRTextField.h
//  myPageScheduler
//
//  Created by Michael Robinson on 18/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDRTextField : UITextField {
    NSString *_key;
}

@property (strong, nonatomic) NSString *key;

@end
