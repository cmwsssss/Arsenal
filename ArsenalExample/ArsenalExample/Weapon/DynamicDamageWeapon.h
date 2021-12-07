//
//  DynamicDamageWeapon.h
//  ArsenalExample
//
//  Created by cmw on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EquipWeaponDynamicDamage <NSObject>

@optional

- (void)dw_fire;

@end

@interface DynamicDamageWeapon : NSObject <EquipWeaponDynamicDamage>

@property (nonatomic, assign) NSInteger damage;

@end

NS_ASSUME_NONNULL_END
