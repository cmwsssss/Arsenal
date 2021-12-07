//
//  Rifle.h
//  ArsenalExample
//
//  Created by cmw on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EquipWeaponRifle <NSObject>

@optional

- (void)rf_fire;

@end

@interface Rifle : NSObject <EquipWeaponRifle>

@end

NS_ASSUME_NONNULL_END
