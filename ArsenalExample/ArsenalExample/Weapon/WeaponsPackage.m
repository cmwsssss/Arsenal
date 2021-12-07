//
//  WeaponPackage.m
//  ArsenalExample
//
//  Created by cmw on 2021/12/7.
//

#import "WeaponsPackage.h"
#import <NSObject+Weapon.h>
@implementation WeaponsPackage

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cc_addWeapon([Rifle class]).cc_addWeapon([SMG class]).cc_addWeapon([DynamicDamageWeapon class]);
        self.cc_link(@"damage", @(20), [DynamicDamageWeapon class]);
    }
    return self;
}

- (void)fullFire {
    [self smg_fire];
    [self rf_fire];
    [self dw_fire];
}

@end
