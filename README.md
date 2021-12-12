中文版本请[点击这里](https://github.com/cmwsssss/Arsenal/blob/main/README-CN.md)

## Arsenal
Arsenal is a plug-in development design pattern that is used to eliminate the high coupling caused by multiple layers of inheritance.

## Introduction
The pattern consists of two roles: a soldier (plug-in insertion object) and a weapon (plug-in). Ideally, a soldier can arbitrarily choose any weapon to do its job, weapon and weapon can be assembled with each other to generate new weapon.

## Soldier:
Any OBJC object can be a Soldier

## Weapon:
Weapon is a composite of a protocol and a class. The protocol part declares the methods that can be used by Soldier, and the class part implements the methods of the protocol

**Weapon is an implemented protocol**

## Architecture comparison

### Traditional architecture in the form of inheritance

<img width="652" alt="截屏2021-12-03 下午3 25 23" src="https://user-images.githubusercontent.com/16182417/144562262-25435464-e166-4b73-a8fe-b0585ea91e0d.png">

This is a multi-layer architecture that relies on inheritance. As you can see, a well-equipped Soldier needs many layers to be implemented, and a change in one layer will lead to changes in multiple layers, and at the Rifle, Pistol, SMG level, there is a high probability of too much code redundancy, and if derivation is done again at the Rifle, Pistol, SMG level to generate new classes, then the management calls between the next level classes will be more complicated due to the high coupling

### Architecture that relies on Arsenal implementation

<img width="652" alt="截屏2021-12-03 下午3 27 34" src="https://user-images.githubusercontent.com/16182417/144562428-1cfd2aa9-78bf-452d-b584-ad696e125f9f.png">

This is an architecture that relies on Arsenal, and as you can see from the diagram, there is no coupling between Weapon and Soldier, and no excessive coupling between Soldier and Soldier, so code reusability is greatly improved, and Soldier can be immediately replaced with any OBJC object.

### Differences with Swift's extensions
Swift can natively implement the decoupling scheme through extensions, but the differences are:
1. the granularity of Arsenal is at the object level, while swift is at the class level, and the control of Arsenal is much freer, as weapon can be loaded and unloaded at any time for any object
2. Arsenal supports properties, while extension does not support properties

## Getting Started

### Prerequisites
Apps using Arsenal can target: iOS 6 or later.

### Installation
pod 'Arsenal-OBJC'

### Creating a Weapon
A Weapon is a composite of protocols and classes, so to create a Weapon of a Pistol, do this

#### Pistol.h
```
@protocol EquipPistol <NSObject>

@optional

- (void)fire;

@end

@interface Pistol : NSObject <EquipPistol>

@end
```

#### Pistol.m
```
@implementation Pistol

- (void)fire {
    NSLog(@"Fire!")
}

@end
```
This creates a Pistol type that can perform Fire

### Install the weapon on the Soldier

#### import "NSObject+Weapon.h"
```
#import "NSObject+Weapon.h"
```

#### Install the weapon on class
If you do class-level assembly, all instances of the class will be able to use Weapon

```
//Inherit EquipPistol protocol
@interface Soldier () <EquipPistol>

- (instancetype)init {
    self = [super init];
    if (self) {
        //Install the weapon on the Soldier
        self.soldier.cc_addWeapon([Pistol class])
    }
}

@end
```

#### 3.Install the weapon on object
Install the weapon on a object only this object can use this weapon

```
- (void)installWeapon {
    //Generate a Soldier object that inherits from the EquipPistol protocol
    NSObject <EquipPistol> *soldier = [[NSObject alloc] init];
    
    //Install the weapon on the Soldier
    soldier.cc_addWeapon([Pistol class])
}
```
### Call the weapons's method
```
//This Soldier can immediately call the weapon's method
[soldier fire];
```





