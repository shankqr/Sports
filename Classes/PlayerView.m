
#import "PlayerView.h"
#import "SquadView.h"
#import "MainView.h"
#import "Globals.h"
#import "PlayerCell.h"

@implementation PlayerView
@synthesize mainView;
@synthesize squadView;
@synthesize playerList;
@synthesize players;
@synthesize player_id;
@synthesize dialogBox;
@synthesize flagImageView;
@synthesize nationLabel;
@synthesize moraleLabel;

- (void)updateView:(NSDictionary *)player
{
    self.players = [[NSMutableArray alloc] initWithObjects:player, nil];
    [playerList reloadData];
    self.player_id = player[@"player_id"];
    
    moraleLabel.text = [NSString stringWithFormat:@"%ld%%", (long)[player[@"happiness"] integerValue]/2];
    
    if ([player[@"happiness"] integerValue] < 80)
    {
        moraleLabel.textColor = [UIColor redColor];
    }
    else if ([player[@"happiness"] integerValue] < 150)
    {
        moraleLabel.textColor = [UIColor yellowColor];
    }
    else
    {
        moraleLabel.textColor = [UIColor greenColor];
    }
    
    NSInteger nation = [player[@"nationality"] integerValue];
    
    if (nation > 0 && nation < 263)
    {
        nationLabel.text = ARRAY_FLAGS[nation];
        [flagImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"flag_%ld.png", (long)nation]]];
    }
    else
    {
        nationLabel.text = @" ";
        flagImageView.image = nil;
    }
}

- (void)close
{
	[[Globals i] closeTemplate];
}

-(IBAction)sellButton_tap:(id)sender
{
    NSInteger minimum_player = 11;
    
    if ([[[Globals i] GameType] isEqualToString:@"football"])
    {
        minimum_player = 11;
    }
    else if ([[[Globals i] GameType] isEqualToString:@"hockey"])
    {
        minimum_player = 6;
    }
    else if ([[[Globals i] GameType] isEqualToString:@"basketball"])
    {
        minimum_player = 5;
    }
    else if ([[[Globals i] GameType] isEqualToString:@"baseball"])
    {
        minimum_player = 9;
    }
    
    if((squadView.players.count > minimum_player) && (![squadView.sold_player_id isEqualToString:squadView.sel_player_id]))
    {
        if([Globals i].energy > 9)
        {
            [self createDialogBox];
            dialogBox.view.tag = 1;
            dialogBox.dialogType = 2;
            
            NSInteger half_value = [squadView.sel_player_value integerValue] / 2;
            NSNumber* number = @(half_value);
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
            [numberFormatter setGroupingSeparator:@","];
            squadView.sel_player_halfvalue = [numberFormatter stringForObjectValue:number];
            
            dialogBox.titleText = @"Sell Player";
            dialogBox.whiteText = squadView.sel_player_name;
            dialogBox.promptText = [NSString stringWithFormat:@"Are you sure you want to sell %@ half the value for $%@?", squadView.sel_player_name, squadView.sel_player_halfvalue];
            
            [self.view addSubview:dialogBox.view];
            [dialogBox updateView];
        }
        else
        {
            [self createDialogBox];
            dialogBox.view.tag = 2;
            dialogBox.dialogType = 2;
            
            dialogBox.titleText = @"Assistant Manager";
            dialogBox.whiteText = @"Not enough energy";
            dialogBox.promptText = @"10 energy is required to sell any player. Refill to full Energy?";
            
            [self.view addSubview:dialogBox.view];
            [dialogBox updateView];
        }
    }
    else
    {
        [self createDialogBox];
        dialogBox.titleText = @"Assistant Manager";
        dialogBox.whiteText = @"Not enough players";
        dialogBox.promptText = [NSString stringWithFormat:@"You must have at least %ld players left on your team.", (long)minimum_player];
        dialogBox.dialogType = 1;
        [self.view addSubview:dialogBox.view];
        [dialogBox updateView];
    }
}

-(IBAction)energizeButton_tap:(id)sender
{
    if([Globals i].energy > 9)
    {
        [self createDialogBox];
        dialogBox.view.tag = 3;
        dialogBox.dialogType = 2;
        dialogBox.titleText = @"Energize Player";
        dialogBox.whiteText = squadView.sel_player_name;
        dialogBox.promptText = [NSString stringWithFormat:@"Energize %@ for 10 Energy? %@'s Fitness will increase by 5.",
                                squadView.sel_player_name, squadView.sel_player_name];
        [self.view addSubview:dialogBox.view];
        [dialogBox updateView];
    }
    else
    {
        [self createDialogBox];
        dialogBox.view.tag = 2;
        dialogBox.dialogType = 2;
        
        dialogBox.titleText = @"Assistant Manager";
        dialogBox.whiteText = @"Not enough energy";
        dialogBox.promptText = @"10 energy is required to Energize any player. Refill to full Energy?";
        
        [self.view addSubview:dialogBox.view];
        [dialogBox updateView];
    }
}

-(IBAction)healButton_tap:(id)sender
{
    if([Globals i].energy > 9)
    {
        [self createDialogBox];
        dialogBox.view.tag = 4;
        dialogBox.dialogType = 2;
        dialogBox.titleText = @"Heal Player";
        dialogBox.whiteText = squadView.sel_player_name;
        dialogBox.promptText = [NSString stringWithFormat:@"Heal %@ for 10 Energy? %@'s injury days will decrease by 1.",
                                squadView.sel_player_name, squadView.sel_player_name];
        [self.view addSubview:dialogBox.view];
        [dialogBox updateView];
    }
    else
    {
        [self createDialogBox];
        dialogBox.view.tag = 2;
        dialogBox.dialogType = 2;
        
        dialogBox.titleText = @"Assistant Manager";
        dialogBox.whiteText = @"Not enough energy";
        dialogBox.promptText = @"10 energy is required to Energize any player. Refill to full Energy?";
        
        [self.view addSubview:dialogBox.view];
        [dialogBox updateView];
    }
}

-(IBAction)renameButton_tap:(id)sender
{
    NSInteger totalDiamonds = [[[Globals i] getClubData][@"currency_second"] integerValue];
    
    if(totalDiamonds > 9)
    {
        [self createDialogBox];
        dialogBox.titleText = @"Rename Player for 10 Diamonds?";
        dialogBox.whiteText = @"Enter a new name for this player.";
        dialogBox.promptText = @"";
        dialogBox.dialogType = 4;
        [self.view addSubview:dialogBox.view];
        [dialogBox updateView];
    }
    else
    {
        [self createDialogBox];
        dialogBox.view.tag = 5;
        dialogBox.dialogType = 2;
        
        dialogBox.titleText = @"Assistant Manager";
        dialogBox.whiteText = @"Not enough Diamonds";
        dialogBox.promptText = @"10 Diamonds is required to rename a player. Would you like to buy some diamonds?";
        
        [self.view addSubview:dialogBox.view];
        [dialogBox updateView];
    }
}

- (void)returnText:(NSString *)text
{
	[self removeDialogBox];
	
	NSString *returnValue = @"0";
	if([text isEqualToString:@""])
	{
		//returnValue = @"0";
	}
	else
	{
		NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/RenamePlayer/%@/%@/%@",
						   WS_URL, [[Globals i] UID], squadView.sel_player_id, text];
		NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSURL *url = [[NSURL alloc] initWithString:wsurl2];
		returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
		
	}
	
	if([returnValue isEqualToString:@"1"])
	{
        [squadView forceUpdate];
        
        //Update Header
        [[Globals i] updateClubData]; //Diamonds deducted for player rename
        
        NSString *message = [[NSString alloc] initWithFormat:@"I have just renamed my player %@ to %@", squadView.sel_player_name, text];
        NSString *extra_desc = @"Always check out the transfer list for new players, who knows you might sign up the next super star.";
        NSString *imagename = @"rename_player.png";
        [[Globals i] fbPublishStory:message :extra_desc :imagename];
        
        [dialogBox.view removeFromSuperview];
        [self close];
        
        dialogBox.titleText = @"Player Renamed";
        dialogBox.whiteText = squadView.sel_player_name;
        dialogBox.promptText = [NSString stringWithFormat:@"Congratulations! player %@ is now called %@.",
                                squadView.sel_player_name, text];
        dialogBox.dialogType = 1;
        [[squadView.view superview] insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
	}
	else
	{
        [self createDialogBox];
		dialogBox.titleText = @"NAME NOT VALID";
		dialogBox.whiteText = @"Enter another name.";
        dialogBox.promptText = @"";
		dialogBox.dialogType = 4;
		[self.view insertSubview:dialogBox.view atIndex:17];
		[dialogBox updateView];
	}
}

- (IBAction)improveButton_tap:(id)sender
{
    NSInteger totalDiamonds = [[[Globals i] getClubData][@"currency_second"] integerValue];
    
    if(totalDiamonds > 4)
    {
        [self createDialogBox];
        dialogBox.view.tag = 6;
        dialogBox.dialogType = 2;
        
        dialogBox.titleText = @"Send to Special Training";
        dialogBox.whiteText = squadView.sel_player_name;
        dialogBox.promptText = [NSString stringWithFormat:@"Send %@ to Special Training for 5 Diamonds? One of %@'s skill will level up after special training.",
                                squadView.sel_player_name, squadView.sel_player_name];
        
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
    else
    {
        [self createDialogBox];
        dialogBox.view.tag = 5;
        dialogBox.dialogType = 2;
        
        dialogBox.titleText = @"Assistant Manager";
        dialogBox.whiteText = @"Not enough Diamonds";
        dialogBox.promptText = @"5 Diamonds is required for Special Training. Would you like to buy some diamonds?";
        
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
}

- (IBAction)moraleButton_tap:(id)sender
{
    NSInteger totalDiamonds = [[[Globals i] getClubData][@"currency_second"] integerValue];
    
    if(totalDiamonds > 2)
    {
        [self createDialogBox];
        dialogBox.view.tag = 7;
        dialogBox.dialogType = 2;
        
        dialogBox.titleText = @"Give Morale Boost";
        dialogBox.whiteText = squadView.sel_player_name;
        dialogBox.promptText = [NSString stringWithFormat:@"Give %@ a Morale Boost for 3 Diamonds? %@'s Morale will increase by 5.",
                                squadView.sel_player_name, squadView.sel_player_name];
        
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
    else
    {
        [self createDialogBox];
        dialogBox.view.tag = 5;
        dialogBox.dialogType = 2;
        
        dialogBox.titleText = @"Assistant Manager";
        dialogBox.whiteText = @"Not enough Diamonds";
        dialogBox.promptText = @"3 Diamonds is required for a Morale Boost. Would you like to buy some diamonds?";
        
        [self.view insertSubview:dialogBox.view atIndex:17];
        [dialogBox updateView];
    }
}

- (void)returnDialog:(NSInteger)tag
{
    if (dialogBox.view.tag == 1) //Sell
    {
        if (tag == 1) //Yes
        {
            [Globals i].energy = [Globals i].energy-10;
            [[Globals i] storeEnergy];
            squadView.sold_player_id = squadView.sel_player_id;
            [[Globals i] sellPlayer: squadView.sel_player_value: squadView.sel_player_id];
            [squadView forceUpdate];
            
            //Update Header
            [[Globals i] updateClubData]; //Balance added with player sold price
            
            NSString *message = [[NSString alloc] initWithFormat:@"I have just sold my player %@ for $%@", squadView.sel_player_name, squadView.sel_player_halfvalue];
            NSString *extra_desc = @"Always check out the transfer list for new players, who knows you might buy the next super star.";
            NSString *imagename = @"sold_player.png";
            [[Globals i] fbPublishStory:message :extra_desc :imagename];
            
            [dialogBox.view removeFromSuperview];
            [self close];
            
            dialogBox.titleText = @"Player Sold";
            dialogBox.whiteText = squadView.sel_player_name;
            dialogBox.promptText = [NSString stringWithFormat:@"Congratulations! you managed to sell %@ to a 3rd world country for $%@. You now have %ld players left on your team.",
                                    squadView.sel_player_name, squadView.sel_player_halfvalue, (unsigned long)squadView.players.count];
            dialogBox.dialogType = 1;
            [[squadView.view superview] insertSubview:dialogBox.view atIndex:17];
            [dialogBox updateView];
        }
    }
    if (dialogBox.view.tag == 2) //Refill Energy
    {
        if (tag == 2) //Yes
        {
            [[Globals i] settPurchasedProduct:@"14"];
            [mainView buyProduct:[[Globals i] getProductIdentifiers][@"refill"]];
            [dialogBox.view removeFromSuperview];
        }
    }
    if (dialogBox.view.tag == 3) //Energize
    {
        if (tag == 3) //Yes
        {
            [Globals i].energy = [Globals i].energy-10;
            [[Globals i] storeEnergy];
            [[Globals i] energizePlayer:squadView.sel_player_id];
            
            [squadView normalUpdate];
            
            //Update Header
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"UpdateHeader"
             object:self];
            //[[Globals i] updateClubData]; //Club energy deducted
            
            [self updateView:(squadView.players)[squadView.selectedRow]];
            
            [dialogBox.view removeFromSuperview];
        }
    }
    if (dialogBox.view.tag == 4) //Heal
    {
        if (tag == 4) //Yes
        {
            [Globals i].energy = [Globals i].energy-10;
            [[Globals i] storeEnergy];
            [[Globals i] healPlayer: squadView.sel_player_id];
            
            [squadView normalUpdate];
            
            //Update Header
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"UpdateHeader"
             object:self];
            
            [self updateView:(squadView.players)[squadView.selectedRow]];
            
            [dialogBox.view removeFromSuperview];
        }
    }
    if (dialogBox.view.tag == 5) //Buy Diamonds
    {
        if (tag == 5) //Yes
        {
            [[Globals i] showBuy];
            [dialogBox.view removeFromSuperview];
            [self close];
        }
    }
    if (dialogBox.view.tag == 6) //Improve
    {
        if (tag == 6) //Yes
        {
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/UpgradePlayer/%@/%@",
                               WS_URL, [[Globals i] UID], squadView.sel_player_id];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
            
            
            if([returnValue isEqualToString:@"0"])
            {
                [self createDialogBox];
                dialogBox.titleText = @"Player NOT VALID";
                dialogBox.whiteText = @"Please select another player.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [squadView normalUpdate];
                
                //Update Header
                [[Globals i] updateClubData]; //Deduct diamonds
                
                NSString *message = [[NSString alloc] initWithFormat:@"I have just sent my player %@ to special training.", squadView.sel_player_name];
                NSString *extra_desc = @"One of your player skill will level up after special training.";
                NSString *imagename = @"special_training.png";
                [[Globals i] fbPublishStory:message :extra_desc :imagename];
                
                [self updateView:(squadView.players)[squadView.selectedRow]];
                [dialogBox.view removeFromSuperview];
                
                NSString *promptText = @"0";
                
                if([returnValue isEqualToString:@"1"])
                {
                    promptText = [NSString stringWithFormat:@"Congratulations! player %@ has level up his %@ skills.", squadView.sel_player_name, [[Globals i] PlayerSkill2]];
                }
                else if([returnValue isEqualToString:@"2"])
                {
                    promptText = [NSString stringWithFormat:@"Congratulations! player %@ has level up his %@ skills.", squadView.sel_player_name, [[Globals i] PlayerSkill3]];
                }
                else if([returnValue isEqualToString:@"3"])
                {
                    promptText = [NSString stringWithFormat:@"Congratulations! player %@ has level up his %@ skills.", squadView.sel_player_name, [[Globals i] PlayerSkill4]];
                }
                else if([returnValue isEqualToString:@"4"])
                {
                    promptText = [NSString stringWithFormat:@"Congratulations! player %@ has level up his %@ skills.", squadView.sel_player_name, [[Globals i] PlayerSkill5]];
                }
                else if([returnValue isEqualToString:@"5"])
                {
                    promptText = [NSString stringWithFormat:@"Congratulations! player %@ has level up his %@ skills.", squadView.sel_player_name, [[Globals i] PlayerSkill1]];
                }
                
                dialogBox.titleText = @"Player Improved";
                dialogBox.whiteText = squadView.sel_player_name;
                dialogBox.promptText = promptText;
                dialogBox.dialogType = 1;
                [[squadView.view superview] insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
    }
    if (dialogBox.view.tag == 7) //Morale Boost
    {
        if (tag == 7) //Yes
        {
            NSString *returnValue = @"0";
            NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/MoralePlayer/%@/%@",
                               WS_URL, [[Globals i] UID], squadView.sel_player_id];
            NSString *wsurl2 = [wsurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [[NSURL alloc] initWithString:wsurl2];
            returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
            
            
            if([returnValue isEqualToString:@"0"])
            {
                [self createDialogBox];
                dialogBox.titleText = @"Player NOT VALID";
                dialogBox.whiteText = @"Please select another player.";
                dialogBox.promptText = @"";
                dialogBox.dialogType = 1;
                [self.view insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
            else
            {
                [squadView normalUpdate];
                
                //Update Header
                [[Globals i] updateClubData]; //Diamonds deducted
                
                NSString *message = [[NSString alloc] initWithFormat:@"I have just gave my player %@ a Morale Boost.", squadView.sel_player_name];
                NSString *extra_desc = @"Your player's morale will increase by 5 after giving a Morale Boost.";
                NSString *imagename = @"morale_boost.png";
                [[Globals i] fbPublishStory:message :extra_desc :imagename];
                
                [self updateView:(squadView.players)[squadView.selectedRow]];
                [dialogBox.view removeFromSuperview];
                
                NSString *promptText = @"0";
                
                promptText = [NSString stringWithFormat:@"Congratulations! player %@ morale has increased by 5.", squadView.sel_player_name];

                dialogBox.titleText = @"Player morale boosted";
                dialogBox.whiteText = squadView.sel_player_name;
                dialogBox.promptText = promptText;
                dialogBox.dialogType = 1;
                [[squadView.view superview] insertSubview:dialogBox.view atIndex:17];
                [dialogBox updateView];
            }
        }
    }
}

// Driving The Table View
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return [[Globals i] playerCellHandler:tableView indexPath:indexPath playerArray:self.players checkPos:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170*SCALE_IPAD;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)createDialogBox
{
    if (dialogBox == nil)
    {
        dialogBox = [[DialogBoxView alloc] initWithNibName:@"DialogBoxView" bundle:nil];
        dialogBox.delegate = self;
    }
}

- (void)removeDialogBox
{
	if(dialogBox != nil)
	{
		[dialogBox.view removeFromSuperview];
	}
}

@end
