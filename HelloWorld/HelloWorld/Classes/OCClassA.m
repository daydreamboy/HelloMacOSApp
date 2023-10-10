//
//  OCClassA.m
//  HelloWorld
//
//  Created by wesley_chen on 2023/10/10.
//

#import "OCClassA.h"

@implementation OCClassA

+ (void)doSomething {
    NSLog(@"start to perform task2");
    [self performSelector:@selector(handleSelector) withObject:nil afterDelay:2];
}

+ (void)handleSelector {
    NSLog(@"delayed task2 is done");
}

@end
