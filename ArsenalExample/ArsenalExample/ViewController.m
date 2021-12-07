//
//  ViewController.m
//  ArsenalExample
//
//  Created by cmw on 2021/12/6.
//

#import "ViewController.h"
#import "Rifle.h"
#import "SMG.h"
#import "DynamicDamageWeapon.h"
#import "WeaponsPackage.h"
#import <NSObject+Weapon.h>

@interface CellDataSource : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) void (^clickHandler)(void);

@end

@implementation CellDataSource

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(void))clickHandler {
    self = [super init];
    if (self) {
        self.title = title;
        self.clickHandler = clickHandler;
    }
    return self;
}

@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, EquipWeaponRifle, EquipWeaponsPackage>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <CellDataSource *>*dataSource;
@property (nonatomic, strong) void (^rifleFireHandler)(void);
@property (nonatomic, strong) void (^SMGFireHandler)(void);
@property (nonatomic, strong) void (^dynamicDamageWeaponFireHandler)(void);
@property (nonatomic, strong) void (^weaponsPackageFireHandler)(void);


@end

@implementation ViewController

//Soldier 为ViewController，调用Rifle的rf_fire方法
- (void (^)(void))rifleFireHandler {
    if (!_rifleFireHandler) {
        __weak typeof(self) weakSelf = self;
        _rifleFireHandler = ^{
            NSLog(@"Soldier is %@", [weakSelf class]);
            [weakSelf rf_fire];
        };
    }
    return _rifleFireHandler;
}

//Soldier 为临时生成的对象，为其添加 SMG，然后调用SMG的smg_fire方法
- (void (^)(void))SMGFireHandler {
    if (!_SMGFireHandler) {
        _SMGFireHandler = ^{
            NSObject <EquipWeaponSMG> *object = [[NSObject alloc] init];
            object.cc_addWeapon([SMG class]);
            NSLog(@"Soldier is %@", [object class]);
            [object smg_fire];
        };
    }
    return _SMGFireHandler;
}

//Soldier 为临时生成的对象，为其添加 DynamicDamageWeapon，设置武器的伤害值为15，然后调用dw_fire方法
- (void (^)(void))dynamicDamageWeaponFireHandler {
    if (!_dynamicDamageWeaponFireHandler) {
        _dynamicDamageWeaponFireHandler = ^{
            DynamicDamageWeapon *weapon = [[DynamicDamageWeapon alloc] init];
            weapon.damage = 15;
            NSObject <EquipWeaponDynamicDamage> *object = [[NSObject alloc] init];
            object.cc_addWeaponWithInstance(weapon);
            NSLog(@"Soldier is %@", [object class]);
            [object dw_fire];
        };
    }
    return _dynamicDamageWeaponFireHandler;
}

//Soldier 为ViewController，调用WeaponsPackage的fullFire方法， 该Weapon包含SMG，Rifle，DynamicDamageWeapon三种weapon，fullFire将会一次调用三种weapon的fire方法
- (void (^)(void))weaponsPackageFireHandler {
    if (!_weaponsPackageFireHandler) {
        __weak typeof(self) weakSelf = self;
        _weaponsPackageFireHandler = ^{
            NSLog(@"Soldier is %@", [weakSelf class]);
            [weakSelf fullFire];
        };
    }
    return _weaponsPackageFireHandler;
}

- (NSArray <CellDataSource *>*)dataSource {
    if (!_dataSource) {
        _dataSource = @[
            [[CellDataSource alloc] initWithTitle:@"Rifle Fire" handler:self.rifleFireHandler],
            [[CellDataSource alloc] initWithTitle:@"SMG Fire" handler:self.SMGFireHandler],
            [[CellDataSource alloc] initWithTitle:@"DynamicDamage Fire" handler:self.dynamicDamageWeaponFireHandler],
            [[CellDataSource alloc] initWithTitle:@"Full Fire" handler:self.weaponsPackageFireHandler]
        ];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell description]];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//为ViewController添加weapons
- (void)addWeapons {
    self.cc_addWeapon([Rifle class])
        .cc_addWeapon([WeaponsPackage class]);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addWeapons];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell description]];
    cell.textLabel.text = self.dataSource[indexPath.row].title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource[indexPath.row].clickHandler) {
        self.dataSource[indexPath.row].clickHandler();
    }
}


@end
