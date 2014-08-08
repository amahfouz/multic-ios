//
//  GameViewController.h
//  Multic
//
//  Created by Ayman Mahfouz on 5/18/14.
//  Copyright (c) 2014 Ayman Mahfouz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XGameModel.h"
#import "MulticLog.h"

@interface GameViewController : UIViewController <UIPickerViewDataSource,  UIPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, MMUXGameModel_Listener, MMUMulticLog> {

    __weak IBOutlet UILabel *messageView;
    __weak IBOutlet UIPickerView *firstPicker;
    __weak IBOutlet UIPickerView *secondPicker;
    __weak IBOutlet UICollectionView *grid;
    __weak IBOutlet UILabel *toast;
    __weak IBOutlet UILabel *multiplicationSign;
}

- (id)init;
- (IBAction)onNewGameTapped:(id)sender;

@end
