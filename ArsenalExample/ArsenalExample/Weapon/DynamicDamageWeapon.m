//
//  DynamicDamageWeapon.m
//  ArsenalExample
//
//  Created by cmw on 2021/12/7.
//

#import "DynamicDamageWeapon.h"

@implementation DynamicDamageWeapon

- (void)dw_fire {
    NSLog([NSString stringWithFormat:@"DynamicDamageWeapon fire, damamge is %ld", self.damage]);
}

@end
