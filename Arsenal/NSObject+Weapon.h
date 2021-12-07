//
//  NSObject+Weapon.h
//  Real
//
//  Created by cmw on 2019/11/25.
//  Copyright © 2019 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Soldier)

/**
 @brief (添加一个weapon到当前实例对象)
 */
- (NSObject *(^)(Class))cc_addWeapon;
/**
 @brief (添加一个对象作为weapon加入到当前实例对象)
 */
- (NSObject *(^)(id))cc_addWeaponWithInstance;
/**
 @brief (如果weapon包含有属性，实例对象想要修改该属性的话，需要使用该方法才能对weapon的属性进行赋值)
 */
- (NSObject *(^)(NSString *property, id value, Class weaponClass))cc_link;

@end

NS_ASSUME_NONNULL_END
