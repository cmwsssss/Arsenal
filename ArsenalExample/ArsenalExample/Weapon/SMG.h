//
//  SMG.h
//  ArsenalExample
//
//  Created by cmw on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EquipWeaponSMG <NSObject>

@optional

- (void)smg_fire;

@end

@interface SMG : NSObject <EquipWeaponSMG>

@end

NS_ASSUME_NONNULL_END
