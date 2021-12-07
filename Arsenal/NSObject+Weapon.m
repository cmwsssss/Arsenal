//
//  NSObject+Weapon.m
//  Real
//
//  Created by cmw on 2019/11/25.
//  Copyright © 2019 com. All rights reserved.
//

#import "NSObject+Weapon.h"
#import <objc/message.h>

@interface NSObject (Weapon)

@property (nonatomic, strong) NSMutableArray *weapons;

@end

@implementation NSObject (Weapon)

- (NSMutableArray *)weapons {
    return objc_getAssociatedObject(self, "weapons");
}

- (void)setWeapons:(NSMutableArray *)weapons {
    objc_setAssociatedObject(self, "weapons", weapons, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation NSObject (Soldier)

- (NSObject *(^)(Class))cc_addWeapon {
    __weak typeof(self) wself = self;
    return ^(Class weaponClass) {
        
        assert(weaponClass);
        
        if(!wself.weapons) {
            wself.weapons = [[NSMutableArray alloc] init];
        }
        
        id weapon = ((id (*) (id, SEL))objc_msgSend)([weaponClass alloc], @selector(init));
        if (![wself.weapons containsObject:weapon]) {
            [wself.weapons addObject:weapon];
        }
        
        return wself;
    };
}

- (NSObject *(^)(id))cc_addWeaponWithInstance {
    __weak typeof(self) wself = self;
    return ^(id instance) {
        
        assert(instance);
        
        if(!wself.weapons) {
            wself.weapons = [[NSMutableArray alloc] init];
        }
        if (![wself.weapons containsObject:instance]) {
            [wself.weapons addObject:instance];
        }
        return wself;
    };
}

- (id)findWeaponForIvar:(NSString *)name weapons:(NSArray *)weapons {
    
    if(!weapons) {
        return nil;
    }
    
    for(NSObject *weapon in weapons) {
        
        if ([weapon hasIvar:name]) {
            return weapon;
        }
        id subWeapon = [self findWeaponForIvar:name weapons:weapon.weapons];
        
        if (subWeapon) {
            return subWeapon;
        }
    }
    
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (self.weapons) {
        id weapon = [self findWeaponForIvar:key weapons:self.weapons];
        if(weapon) {
            [weapon setValue:value forKey:key];
            return;
        }
    }
    
    [NSException raise:@"Invalid keyPath" format:@"%@ key :%@ is invalid",NSStringFromClass([self class]), key];
}

- (id)valueForUndefinedKey:(NSString *)key {
    if (self.weapons) {
        id weapon = [self findWeaponForIvar:key weapons:self.weapons];
        if(weapon) {
            return [weapon valueForKey:key];
        }
    }
    return nil;
}

- (id)findWeaponFromWeapons:(NSArray *)weapons propertyName:(NSString *)propertyName{
    
    if(!weapons) {
        return nil;
    }

    for(NSObject *weapon in weapons) {
        
        if([weapon respondsToSelector:sel_getUid(propertyName.UTF8String)]) {
            return weapon;
        }
        
        id subWeapon = [self findWeaponFromWeapons:weapon.weapons propertyName:propertyName];
        
        if(subWeapon) {
            return subWeapon;
        }
    }
    
    return nil;
}

- (BOOL)hasIvar:(NSString *)name {
    Ivar ivar = class_getInstanceVariable([self class], name.UTF8String);
    if (!ivar) {
        ivar = class_getInstanceVariable([self class], [[@"_" stringByAppendingString:name]UTF8String]);
    }
    if(ivar) {
        return YES;
    }
    return NO;
}

- (NSObject *(^)(NSString *propertyName, id value, Class weaponClass))cc_link {
    __weak typeof(self) wself = self;
    return ^(NSString *propertyName, id value, Class weaponClass) {
        
        assert(propertyName && weaponClass);
        
        for (NSObject *weapon in self.weapons) {
            if ([weapon isKindOfClass:weaponClass]) {
                if ([weapon hasIvar:propertyName]) {
                    [weapon setValue:value forKey:propertyName];
                    return wself;
                }
                id subWeapon = [self findWeaponFromWeapons:weapon.weapons propertyName:propertyName];
                
                if (subWeapon) {
                    [subWeapon setValue:value forKey:propertyName];
                }
            }
        }
        return wself;
    };
}

//TODO 把系统方法保存

- (id)findWeaponForSelector:(SEL)aSelector weapons:(NSArray *)weapons {
    
    if(!weapons) {
        return nil;
    }
    
    for(NSObject *weapon in weapons) {
        if([weapon respondsToSelector:aSelector]) {
            return weapon;
        }
        id subWeapon = [self findWeaponForSelector:aSelector weapons:weapon.weapons];
        
        if(subWeapon) {
            return subWeapon;
        }
    }
    
    return nil;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    if (self.weapons) {
        id weapon = [self findWeaponForSelector:aSelector weapons:self.weapons];
        return weapon;
    }
    
    return nil;
}

#pragma mark --TODO--

- (void)lockMemoryPool {
    [self memoryControl:self isDrain:NO];
}

- (void)unlockMemoryPool {
    [self memoryControl:self isDrain:YES];
}

- (void)memoryControl:(NSObject *)target isDrain:(BOOL)isDrain {
    unsigned int outCount;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([target class], &outCount);
    for(int i = 0; i < outCount; i++) {
        Protocol *protocol = protocolList[i];
        if([[NSStringFromProtocol(protocol) lowercaseString]containsString:@"equip"]) {
            if([target conformsToProtocol:protocol]) {
                unsigned int ivarCount;
                Ivar *ivarList = class_copyIvarList([target class], &ivarCount);
                for(int j = 0; j < ivarCount; j++) {
                    Ivar ivar = ivarList[j];
                    id object = object_getIvar(target, ivar);
                    if(object) {
                        if(isDrain) {
                            CFRelease((__bridge CFTypeRef)(object));
                        }
                        else {
                            CFRetain((__bridge CFTypeRef)(object));
                        }
                    }
                }
                
                free(ivarList);
                
            }
            for(id weapon in target.weapons) {
                [self memoryControl:weapon isDrain:isDrain];
            }
        }
    }
    free(protocolList);
}

@end
