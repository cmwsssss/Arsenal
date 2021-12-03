# Arsenal

## 什么是Arsenal？
Arsenal 是一个插件式开发设计模式，该设计模式用于消除多重继承带来的高耦合性。

## 简介
该模式由两个角色构成：一个是soldier（插件插入对象），一个是weapon（插件）。在理想状态下，一个soldier可以任意的选用任意的weapon来完成工作，weapon和weapon之间可以互相组装，生成新的weapon。

## Soldier:
任意OC对象都可以成为Soldier

## Weapon:
Weapon是一个协议和类的复合体，协议部分声明了可以被Soldier复用的方法，类的部分则对协议的方法进行了实现

**简单来说Weapon是一个实现了的协议**

## 架构对比

### 传统的继承形式的架构

<img width="652" alt="截屏2021-12-03 下午3 25 23" src="https://user-images.githubusercontent.com/16182417/144562262-25435464-e166-4b73-a8fe-b0585ea91e0d.png">

这是一个依靠继承实现的多层架构，可以看到，一个装备完善的Soldier需要很多层级才能实现，一个层级的变动，会导致多个层级产生变化，而且在Rifle，Pistol，SMG这一级，很有可能出现过多的代码冗余，如果在Rifle，Pistol，SMG这一级再进行派生，生成新的类，那么下一级类之间的管理调用由于耦合关系过高，会更加的复杂

### 依靠Arsenal实现的架构

<img width="652" alt="截屏2021-12-03 下午3 27 34" src="https://user-images.githubusercontent.com/16182417/144562428-1cfd2aa9-78bf-452d-b584-ad696e125f9f.png">

这是一个依靠Arsenal实现的架构，由图可见，各个Weapon之间没有相互的耦合关系，与Soldier之间也没有过多的耦合关系，代码重用性也大大提高，Soldier可以立刻替换成任意OC对象。Weapon的数量也可以任意的增加或减少

### 与Swift的extension的差异
Swift原生就可以通过extension来实现该解耦方案，但是差异:
1. 在于Arsenal的粒度可以达到对象级别，而swift则是类级别，而且Arsenal的操控更加自由，可以在任何时候对任何对象进行weapon的装载和卸除
2. Arsenal支持property，而extension没办法支持property

### 使用教程：
#### 1.创建Weapon
Weapon是一个协议和类的集合体，所以我们的加入我们要创建一个Pistol的Weapon，可以这样做：

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
这样一把能进行Fire操作的Pistol类型就创建好了

#### 2.将Weapon装载到Soldier
##### 1.引入工具文件"NSObject+Weapon.h"
```
#import "NSObject+Weapon.h"
```

##### 2.类级别的组装
进行类级别的组装，则该类所有实例对象都能使用Weapon

```
//继承EquipPistol协议
@interface Soldier () <EquipPistol>

- (instancetype)init {
    self = [super init];
    if (self) {
        //将weapon安装到Soldier上
        self.soldier.cc_addWeapon([Pistol class])
    }
}

@end
```

##### 3.对象级别的组装
进行对象级别的组装，则只有该对象能使用Weapon

```
- (void)installWeapon {
    //生成一个Soldier，该对象继承自EquipPistol协议，方便编译器识别
    NSObject <EquipPistol> *soldier = [[NSObject alloc] init];
    //将weapon安装到Soldier上
    soldier.cc_addWeapon([Pistol class])
}
```
##### 3.调用
```
//该Soldier可以立即调用weapon的方法
[soldier fire];
```





