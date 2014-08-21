//
//  GameViewController.m
//  Multic
//
//  Created by Ayman Mahfouz on 5/18/14.
//  Copyright (c) 2014 Ayman Mahfouz. All rights reserved.
//

#import "tgmath.h"
#import "GameViewController.h"
#import "HelpViewController.h"
#import "OptionsViewController.h"

#import "XGameModel.h"
#import "Difficulty.h"
#import "MulticPrefs.h"
#import "Knob.h"
#import "Player.h"
#import "BoardDef.h"
#import "XGameGridUiModel.h"
#import "MulticException.h"
#import "MulticUtils.h"
#import "MulticGameCell.h"

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

////////////////////////////////////////////////////

static UIColor* HUMAN_COLOR;
static UIColor* COMPUTER_COLOR;
static UIColor* EMPTY_COLOR;

static CGFloat MIN_GRID_INSET = 1;
static CGFloat GRID_SPACING = 1;

@interface GameViewController() {
    MMUXGameModel* game;
    UIEdgeInsets gridInsetObj;
    CGFloat gridCellSize;
}

-(void)startNewGame;
-(void)syncViewWithModel;
-(void)updateViewState;
-(void)setPickerEnablement:(BOOL)isEnabled;
-(void)showMessage:(NSString*)message
        withPlayer:(BOOL)isHuman;
-(void)announceWinAndPromptRestart:(NSString*)message
                        withWinner:(BOOL)isHuman;
-(void)flashCell:(IOSIntArray*)cells
    withDuration:(NSTimeInterval)duration
    withCallback:(void (^)(BOOL finished))completion;

-(void)setupViewsForPortraitOrientation;
-(void)setupViewsForLandscapeOrientation;


@end

///////////////////////////////////////////////////////////////////////////////

@implementation TouchInterceptingView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* hitView = [super hitTest:point withEvent:event];
   // NSLog(@"%@", hitView);
    return hitView;
}

@end

///////////////////////////////////////////////////////////////////////////////

@implementation TouchInterceptingPicker

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began");
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches ended");
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches moved");
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches canceled");
    [super touchesCancelled:touches withEvent:event];
}

@end

///////////////////////////////////////////////////////////////////////////////


@implementation GameViewController

- (id) init
{
    self = [super initWithNibName:@"GameView" bundle:nil];
    [[self navigationItem] setTitle:@"Multic"];
    UIBarButtonItem* settingsButton =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                              target:self
                              action:@selector(showMenu:)];
    
    self.navigationItem.rightBarButtonItem = settingsButton;
    
    gridInsetObj = UIEdgeInsetsMake
        (MIN_GRID_INSET, MIN_GRID_INSET, MIN_GRID_INSET, MIN_GRID_INSET);
    
    [self startNewGame];
    
    [self view].autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    return self;
}

+ (void)initialize {
    HUMAN_COLOR = [UIColor colorWithR:150 withG:210 withB:6];
    COMPUTER_COLOR = [UIColor colorWithR:224 withG:137 withB:104];
    EMPTY_COLOR = [UIColor colorWithR:68 withG:68 withB:68];
}

/////////////////////////////////////// View lifecycle
#pragma mark View lifecycle methods

- (void)viewWillAppear:(BOOL)animated {
    if (game == nil || [game getDifficulty] != [MulticPrefs getDifficulty]) {
        [self startNewGame];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [grid performBatchUpdates:nil completion:nil];
    
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    CGFloat navBarHeight = navBarFrame.origin.y + navBarFrame.size.height;
    NSLog(@"Did rotate %f", navBarHeight);
    
    [self.view setNeedsLayout];
    [self computeGridSpacing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"GridCell" bundle:nil];
    [grid registerNib:cellNib forCellWithReuseIdentifier:@"GridCell"];
    
    [UIView setAnimationsEnabled:YES];
    
    messageView.layer.cornerRadius = 5;
    messageView.layer.masksToBounds = YES;
    
    firstPicker.layer.cornerRadius = 5;
    firstPicker.layer.masksToBounds = YES;
    
    secondPicker.layer.cornerRadius = 5;
    secondPicker.layer.masksToBounds = YES;
/*
    [firstPicker addTarget:self
                    action:@selector(handleTouchDownPicker:)
          forControlEvents:UIControlEventTouchDown];
    [secondPicker addTarget:self
                    action:@selector(handleTouchDownPicker:)
          forControlEvents:UIControlEventTouchDown];
    
    [firstPicker addTarget:self
                    action:@selector(handleEndIxnPicker:)
          forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
*/    
    [self syncViewWithModel];
}

- (void)viewDidLayoutSubviews
{
    // re-layout components according to size of screen

    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    CGFloat navBarHeight = navBarFrame.origin.y + navBarFrame.size.height;
    NSLog(@"Did layout %f", navBarHeight);

    
    [super viewDidLayoutSubviews];
    
    UIInterfaceOrientation orientation
        = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsLandscape(orientation))
        [self setupViewsForLandscapeOrientation];
    else
        [self setupViewsForPortraitOrientation];
    
    [self computeGridSpacing];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)
interfaceOrientation
                                         duration:(NSTimeInterval)duration {

//    CGRect navBarFrame = self.navigationController.navigationBar.frame;
//    CGFloat navBarHeight = navBarFrame.origin.y + navBarFrame.size.height;
//    NSLog(@"Will animate %f", navBarHeight);

}

- (void)setupViewsForLandscapeOrientation
{
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    
    CGFloat navBarHeight = navBarFrame.size.height;
    NSLog(@"Nav y = %f", navBarFrame.origin.y);
    CGFloat navBarBottomY = navBarFrame.origin.y + navBarHeight;
    CGFloat availHeight = [UIScreen mainScreen].bounds.size.width - navBarBottomY;
    CGFloat availWidth = [UIScreen mainScreen].bounds.size.height;
    
    NSLog(@"View(%f, %f, %f, %f)", navBarHeight, navBarBottomY, availWidth, availHeight);
    
    // make grid square with side equal to shorter screen dim
    
    CGFloat padding = 2;
    CGFloat gridSide = availHeight - 2 * padding;

    grid.frame = CGRectMake
        (availWidth - padding - gridSide,
         navBarBottomY + padding,
         gridSide,
         gridSide);
    toast.frame = grid.frame;
    
    // message view spans rest of horizontal space
    
    CGFloat messageH = 34;
    CGFloat messageW = availWidth - gridSide - 3 * padding;
    
    messageView.frame = CGRectMake
        (padding, navBarBottomY + padding, messageW, messageH);

    // position multiplication sign centered in remaining space
    
    CGFloat remainingHeight = availHeight - messageH - 2 * padding;
    CGFloat centerX = messageView.center.x;
    CGFloat centerY = navBarBottomY + messageH + remainingHeight / 2;
    multiplicationSign.center = CGPointMake(centerX, centerY);

    CGFloat spinnerH = firstPicker.frame.size.height;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    
        // position spinners vertically aligned
        
        CGFloat spinnerPaddingH = 6;
        CGFloat spinnerPaddingW = 40;
     
        CGFloat distFromCenterOfSignToCenterOfSpinner
            = multiplicationSign.frame.size.height / 2
            + spinnerPaddingH
            + spinnerH / 2;
        
        firstPicker.center = CGPointMake
            (centerX, centerY - distFromCenterOfSignToCenterOfSpinner);
        
        CGFloat widthReduction = 2 * spinnerPaddingW;
        CGFloat spinnerW = messageW - widthReduction;
     
        firstPicker.frame = CGRectMake
            (centerX - spinnerW / 2,
             firstPicker.frame.origin.y,
             spinnerW,
             spinnerH);
        
        secondPicker.center = CGPointMake
            (centerX, centerY + distFromCenterOfSignToCenterOfSpinner);
     
        secondPicker.frame = CGRectMake
            (centerX - spinnerW / 2,
             secondPicker.frame.origin.y,
             spinnerW,
             spinnerH);
    }
    else
    {
        // position spinners horizontally aligned
        
        CGFloat spinnerPaddingW = 6;
        CGFloat spinnerW
            = (messageW - multiplicationSign.frame.size.width - 2 * spinnerPaddingW) / 2;
        
        CGFloat spinnerY = centerY - spinnerH / 2;
        
        firstPicker.frame = CGRectMake(padding, spinnerY, spinnerW, spinnerH);
        secondPicker.frame = CGRectMake
            (padding + messageW - spinnerW, spinnerY, spinnerW, spinnerH);
    }
}

- (void)setupViewsForPortraitOrientation
{
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    CGFloat navBarHeight = navBarFrame.origin.y + navBarFrame.size.height;

    CGFloat availHeight = [self view].bounds.size.height - navBarHeight;
    CGFloat availWidth = [self view].bounds.size.width;
    
    NSLog(@"View(%f, %f)", availWidth, availHeight);

    NSInteger numVertSpaces = 4; // top, under message, under spinner, under grid
    CGFloat minVertSpacing = 1; // vertical spacing betwen sub views
    CGFloat minHorizPadding = 1; // padding between grid and enclosing view
    CGFloat innertHorizSpacing = 6;
    CGFloat messageH = 22;
    CGRect origFirstPickerRect = firstPicker.frame;
    
    // choose grid dims based on what is available horizontally and vertically
    
    CGFloat maxAllowedGridH
        = availHeight
        - messageH
        - origFirstPickerRect.size.height
        - numVertSpaces * minVertSpacing;
    
    CGFloat maxAllowedGridW = availWidth - 2 * minHorizPadding;

    CGFloat gridSide = fmin(maxAllowedGridH, maxAllowedGridW);

    // compute remaining spacing
    
    CGFloat gridHorizPadding = (availWidth - gridSide) / 2;
    CGFloat horizPadding = fmaxf(gridHorizPadding, minHorizPadding);
    CGFloat vertSpacing
        = (availHeight
        - messageH
        - origFirstPickerRect.size.height
        - gridSide) / numVertSpaces;
    
    // position message view
    
    messageView.frame = CGRectMake
        (horizPadding,
         vertSpacing + navBarHeight,
         availWidth - 2 * horizPadding,
         messageH);
    
    // position multiplication sign centered
    
    CGFloat spinnerHeight = origFirstPickerRect.size.height;
    
    multiplicationSign.center = CGPointMake
        (messageView.center.x,
         messageView.frame.origin.y
         + messageView.frame.size.height
         + vertSpacing
         + spinnerHeight / 2);
    
    CGRect mulSignFrame = multiplicationSign.frame;
    
    // position spinners (iOS prevents changing their height)
    
    CGFloat spinnerY
        = navBarHeight
        + vertSpacing
        + messageView.frame.size.height
        + vertSpacing;
    
    CGFloat spinnerWidthPercent = 0.6;
    CGFloat spinnerWidthAvail
        = (gridSide - multiplicationSign.frame.size.width - 2 * innertHorizSpacing) / 2;
    CGFloat spinnerW = spinnerWidthAvail * spinnerWidthPercent;
    
    firstPicker.frame = CGRectMake
        (mulSignFrame.origin.x - horizPadding - spinnerW,
         spinnerY, spinnerW, spinnerHeight);
    secondPicker.frame = CGRectMake
        (mulSignFrame.origin.x + mulSignFrame.size.width + horizPadding,
         spinnerY, spinnerW, spinnerHeight);
    
  //  CGRect mulSignFrame = multiplicationSign.frame;
  //  CGFloat mulSignY = spinnerY + (spinnerHeight - mulSignFrame.size.height) / 2;
  //  multiplicationSign.frame = CGRectMake
  //      (horizPadding + spinnerW + innertHorizSpacing, mulSignY,
  //       mulSignFrame.size.width, mulSignFrame.size.height);

    // position grid
    
    CGFloat gridY = spinnerY + origFirstPickerRect.size.height + vertSpacing;
    CGRect gridFrame = CGRectMake(gridHorizPadding, gridY, gridSide, gridSide);
    grid.frame = gridFrame;
    toast.frame = gridFrame; // overlay on grid

}

/////////////////////////////////////// Game managmenet methods
#pragma mark Game management methods

-(void)startNewGame
{
    game = [[MMUXGameModel alloc] initWithMMCDifficultyEnum:[MulticPrefs getDifficulty]
                                 withMMUXGameModel_Listener:self
                                                withBoolean:[MulticPrefs getIsRandomFirstPos]
                                              withFirstTurn:[MulticPrefs getHumanStarts]
                                           withMMUMulticLog:self];
    if ([self view])
        [self syncViewWithModel];
}

-(void)syncViewWithModel
{
    
    [grid reloadData];

    [firstPicker selectRow:[game getSelectedIndexFor:MMCKnob_LocationEnum_TOP]
               inComponent:0
                  animated:NO];
    
    [secondPicker selectRow:[game getSelectedIndexFor:MMCKnob_LocationEnum_BOTTOM]
               inComponent:0
                  animated:NO];
    
    [self updateViewState];
}

-(void)updateViewState
{
    MMCPlayerEnum* turnPlayer = [game getTurnPlayer];
    BOOL isHumanTurn = (turnPlayer == MMCPlayerEnum_HUMAN);
    
    [self setPickerEnablement:isHumanTurn];
    
    if (turnPlayer == nil) {
        
        MMCPlayerEnum* winnerIfAny = [game getWinnerIfAny];
        
        if (winnerIfAny == MMCPlayerEnum_HUMAN)
            [self announceWinAndPromptRestart:@"You win!" withWinner:YES];
        else if (winnerIfAny == MMCPlayerEnum_COMPUTER)
            [self announceWinAndPromptRestart:@"Computer wins!" withWinner:NO];
        else {
            [self showMessage:@"Game drawn!" withPlayer:YES];
            [toast setHidden:NO];
        }
    }
    else {
        NSString* message = isHumanTurn
            ? @"Your turn!"
            : @"Thinking...";
        [self showMessage:message withPlayer:isHumanTurn];
        
        [toast setHidden:YES];
    }
}

-(void)announceWinAndPromptRestart:(NSString*)message
                        withWinner:(BOOL)isHuman
{
    [self showMessage:message withPlayer:isHuman];
    
    IOSIntArray* fourInRow = [game getWinningFourIfAny];
    
    // schedule later to let animation of last filled cell to complete
    dispatch_async(dispatch_get_main_queue(), ^{
        [self flashCell:fourInRow
           withDuration:0.5
           withCallback:^(BOOL finished) {
               [toast setHidden:NO];
           }];
    });
}

-(void)showMessage:(NSString*)message
        withPlayer:(BOOL)isHuman
{
    [messageView setText:message];
    messageView.layer.backgroundColor = (isHuman)
        ? HUMAN_COLOR.CGColor
        : COMPUTER_COLOR.CGColor;
}

-(void)setPickerEnablement:(BOOL)isEnabled
{
    [firstPicker setUserInteractionEnabled:isEnabled];
    [secondPicker setUserInteractionEnabled:isEnabled];
}

/////////////////////////////////////// Event handling methods
#pragma mark Event handling methods

- (IBAction)onNewGameTapped:(id)sender {
    [toast setHidden:YES];
    [self startNewGame];
}

-(void)showMenu:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"New Game", @"Instructions", @"Options", nil];
    
    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem
                              animated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UINavigationController* navController
        = (UINavigationController* )self.parentViewController;
 
    if (buttonIndex == 0)
    {
        UIAlertView *theAlert
            = [[UIAlertView alloc] initWithTitle:@"Start New Game"
                                         message:@"Abandon current game and start a new one?"
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:@"New Game", nil];
        [theAlert show];
    }
    else if (buttonIndex == 1)
    {
        [navController pushViewController:[[HelpViewController alloc] init] animated:YES];
    }
    else if (buttonIndex == 2)
    {
        [navController pushViewController:[[OptionsViewController alloc] init] animated:YES];
    }
}

-(void)showInstructions
{
    UINavigationController* navController
        = (UINavigationController* )self.parentViewController;
    
    [navController pushViewController:[[HelpViewController alloc] init] animated:YES];
}

/////////////////////////////////////// UIAlertViewDelegate delegate
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self startNewGame];
}

/////////////////////////////////////// UIPickerView datasource/delegate
#pragma mark UIPickerView methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return MMCKnob_MAX_FACTOR - MMCKnob_MIN_FACTOR + 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return [@(row + 1) stringValue];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {

    MMCKnob_LocationEnum* knobLoc = (pickerView == firstPicker)
        ? MMCKnob_LocationEnum_TOP
        : (pickerView == secondPicker)
           ? MMCKnob_LocationEnum_BOTTOM
           : nil;
    
    if (knobLoc == nil) {
        NSLog(@"Unrecognized picker view.");
        return;
    }
    
    // no change
    if ([game getSelectedIndexFor:knobLoc] == row)
        return;
    
    @try {
        [self setPickerEnablement:NO];
        [game makeUserMoveWithMMCKnob_LocationEnum:knobLoc withInt:row];
    }
    @catch (MMCMulticException *exception) {
        [self showMessage:[exception getMessage] withPlayer:YES];
        MMCMulticGameCell* cell = [exception getCellIfAny];
        if (cell) {
            IOSIntArray* cellIndexInArr
                = [IOSIntArray arrayWithInts:&(cell->cellIndex_) count:1];
            [self flashCell:cellIndexInArr
               withDuration:0.15
               withCallback:^(BOOL finished) {
                   [pickerView selectRow:[game getSelectedIndexFor:knobLoc] inComponent:0 animated:YES];
                   [self updateViewState];
            }];
        }
    }
}

/////////////////////////////////////// UICollectionView datasource/delegate
#pragma mark UICollectionView methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MMCBoardDef_NUM_CELLS;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"GridCell";
    
    UICollectionViewCell *cell
            = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                        forIndexPath:indexPath];
    id<MMUXGameGridUiModel> uim = [game getGridUiModel];
    
    UILabel *cellLabelView = (UILabel *)[cell viewWithTag:1];
    
    //cellLabelView.frame = cell.frame;
    
    NSUInteger cellIndex = [indexPath indexAtPosition:1];
    [cellLabelView setText:[uim getCellContentWithInt:cellIndex]];
    
    cellLabelView.layer.backgroundColor = [self getColorForCell:cellIndex].CGColor;

    cell.layer.cornerRadius = 2;
    cell.layer.masksToBounds = YES;
    
    return cell;
    
}

-(UIColor*)getColorForCell:(NSUInteger)cellIndex
{
    id<MMUXGameGridUiModel> uim = [game getGridUiModel];
    MMCPlayerEnum* occupant = [uim getCellOccupantIfAnyWithInt:cellIndex];
    
    return (occupant == MMCPlayerEnum_HUMAN)
        ? HUMAN_COLOR
        : (occupant == MMCPlayerEnum_COMPUTER)
            ? COMPUTER_COLOR
            : EMPTY_COLOR;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

///////////////////////////////
#pragma mark Grid layout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(gridCellSize, gridCellSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return GRID_SPACING;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return GRID_SPACING;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {

    return gridInsetObj;
}

-(void)computeGridSpacing
{
    CGFloat gridSide = grid.frame.size.width;
    CGFloat netContentWidth = gridSide - (2 * MIN_GRID_INSET) - 5 * GRID_SPACING;
    
    gridCellSize = floor(netContentWidth / 6);
    CGFloat gridInset = (gridSide - (6 * gridCellSize) - (5 * GRID_SPACING)) / 2;
    
    gridInsetObj = UIEdgeInsetsMake(gridInset, gridInset, gridInset, gridInset);
    
    NSLog(@"Grid(%f, %f, %f)", gridSide, gridCellSize, gridInset);
    
    [grid.collectionViewLayout invalidateLayout];
}

////////////////////////////////
#pragma mark XGameModel.Listener

-(void)cellStateChangedWithInt:(int)gridCellIfAny
{
    if (gridCellIfAny < 0)
        return;
    
    NSUInteger pathIndices[] = {0, gridCellIfAny};
    NSIndexPath* cellPath = [NSIndexPath indexPathWithIndexes:pathIndices length:2];
    UICollectionViewCell* cellView = [grid cellForItemAtIndexPath:cellPath];
    UILabel *cellLabelView = (UILabel *)[cellView viewWithTag:1];
    
    [UIView animateWithDuration:0.6
                      delay:0.0
                    options:UIViewAnimationOptionCurveEaseInOut
                 animations:^{
                        cellLabelView.layer.backgroundColor
                            = [self getColorForCell:gridCellIfAny].CGColor;
                 }
                 completion:^(BOOL finished) {
                     [self updateViewState];
                 }];
    
    [grid performBatchUpdates:nil completion:nil];
}

-(void)knobStateChangedWithMMCKnob_LocationEnum:(MMCKnob_LocationEnum *)knobLoc
{
    UIPickerView* picker = (knobLoc == MMCKnob_LocationEnum_BOTTOM)
        ? secondPicker
        : (knobLoc == MMCKnob_LocationEnum_TOP)
            ? firstPicker
            : nil;
    
    if (picker == nil) {
        NSLog(@"Invalid picker");
        return;
    }
    
    int newIndex = [game getSelectedIndexFor:knobLoc];
    
    [picker selectRow:newIndex inComponent:0 animated:true];
}

/////////////////////////////////////// Cell animation
#pragma mark Animation

-(void)flashCell:(IOSIntArray*)cells
    withDuration:(NSTimeInterval)duration
    withCallback:(void (^)(BOOL finished))completionBlock;
{
    UIColor* curColor = [self getColorForCell:[cells intAtIndex:0]];
    UIColor* newColor = [curColor halve];
    
    [UIView animateWithDuration:duration
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseInOut
                                |UIViewAnimationOptionRepeat
                                |UIViewAnimationOptionAutoreverse
                     animations:^{
                         [UIView setAnimationRepeatCount:3];
                         for (NSUInteger i = 0; i < cells.count; i++) {
                             NSUInteger pathIndices[] = {0, [cells intAtIndex:i]};
                             NSIndexPath* cellPath = [NSIndexPath indexPathWithIndexes:pathIndices length:2];
                             UICollectionViewCell* cellView = [grid cellForItemAtIndexPath:cellPath];
                             UILabel *cellLabelView = (UILabel *)[cellView viewWithTag:1];
                             
                             cellLabelView.layer.backgroundColor = newColor.CGColor;
                         }
                     }
                     completion:^(BOOL completed){
                         for (NSUInteger i = 0; i < cells.count; i++) {
                             NSUInteger pathIndices[] = {0, [cells intAtIndex:i]};
                             NSIndexPath* cellPath = [NSIndexPath indexPathWithIndexes:pathIndices length:2];
                             UICollectionViewCell* cellView = [grid cellForItemAtIndexPath:cellPath];
                             UILabel *cellLabelView = (UILabel *)[cellView viewWithTag:1];
                             
                             cellLabelView.layer.backgroundColor = curColor.CGColor;
                         }
                         // chain the call to the block passed in
                         completionBlock(completed);
                     }];
}

/////////////////////////////////////// MulticLog
#pragma mark Logging

- (void)debugWithNSString:(NSString *)message
{
    NSLog(@"D %@", message);
}

- (void)infoWithNSString:(NSString *)message
{
    NSLog(@"I %@", message);
}

- (void)warnWithNSString:(NSString *)message
{
    NSLog(@"W %@", message);
}

@end

