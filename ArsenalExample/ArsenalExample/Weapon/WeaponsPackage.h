//
//  WeaponPackage.h
//  ArsenalExample
//
//  Created by cmw on 2021/12/7.
//

#import <Foundation/Foundation.h>
#import "Rifle.h"
#import "SMG.h"
#import "DynamicDamageWeapon.h"
NS_ASSUME_NONNULL_BEGIN

@protocol EquipWeaponsPackage <EquipWeaponSMG, EquipWeaponRifle, EquipWeaponDynamicDamage>

@optional

- (void)fullFire;

@end

@interface WeaponsPackage : NSObject <EquipWeaponsPackage>

@end

NS_ASSUME_NONNULL_END
