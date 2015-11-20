//
//  LoginViewController.m
//  eSub_Notes
//
//  Created by LAWRENCE SHANNON on 1/22/14.
//  Copyright (c) 2014 LAWRENCE SHANNON. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginAFHTTPClient.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"
#import "Constants.h"
#import "Common.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.barTintColor =     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 184.0/255.0 green: 185.0/255.0 blue:188.0/255.0 alpha: 1.0];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   nil];
//    self.navigationItem.title = @"eSub Notes";


    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
//    self.view.backgroundColor = [UIColor colorWithRed: 202.0/255.0 green: 225.0/255.0 blue:255.0/255.0 alpha: 1.0];
//    self.view.backgroundColor = [UIColor grayColor];

    self.loginButton.layer.cornerRadius = 3;
    self.loginButton.layer.borderWidth = 1;
//    self.loginButton.layer.borderColor = [UIColor grayColor].CGColor;
//    self.loginButton.layer.backgroundColor = [UIColor grayColor].CGColor;
    
    self.emailTextbox.tag = 1;
    self.passwordTextbox.tag = 2;

    self.emailTextbox.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextbox.delegate = self;

    [self.emailTextbox setReturnKeyType:UIReturnKeyDone];
    [self.emailTextbox addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.passwordTextbox.secureTextEntry = YES;
    self.passwordTextbox.keyboardType = UIKeyboardTypeDefault;
    self.passwordTextbox.delegate = self;
    [self.passwordTextbox setReturnKeyType:UIReturnKeyDone];
    [self.passwordTextbox addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.subscriberTextbox setReturnKeyType:UIReturnKeyDone];
    [self.subscriberTextbox addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];

    self.rememberMeButton.selected = [[[NSUserDefaults standardUserDefaults] objectForKey:kRememberedRememberFlagDataKey] boolValue];
    if (self.rememberMeButton.selected)
    {
        self.subscriberTextbox.text = [[NSUserDefaults standardUserDefaults] objectForKey:kRememberedSubscriberDataKey];
        self.emailTextbox.text = [[NSUserDefaults standardUserDefaults] objectForKey:kRememberedEmailDataKey];
        self.passwordTextbox.text = [[NSUserDefaults standardUserDefaults] objectForKey:kRememberedPasswordDataKey];
    }

}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)textFieldFinished:(id)sender
{
    
    UITextField *textField = (UITextField *) sender;
    
    [textField resignFirstResponder];

}


- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
/*
    if (textField.tag == 1)
    {
        self.emailTextbox.text = @"";
    }
    else
    {
        self.passwordTextbox.text = @"";
    }
*/
}

- (IBAction)loginButton:(id)sender
{

    if (self.emailTextbox.text.length == 0 || self.passwordTextbox.text.length == 0 || self.subscriberTextbox.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a subscriber, username and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSString *email = [self.emailTextbox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextbox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *subscriber = [self.subscriberTextbox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
/*
    if ([subscriber rangeOfString:@"qa\\"].location == NSNotFound)
    {
        appD.eSUBServerURL = keSUBServerURL;
    }
    else
    {
        appD.eSUBServerURL = keSUBQAServerURL;
        subscriber = [subscriber stringByReplacingOccurrencesOfString:@"qa\\" withString:@""];
    }
*/
    
    if ([subscriber containsString:@"qa\\"])
    {
        appD.eSUBServerURL = keSUBQAServerURL;
        subscriber = [subscriber stringByReplacingOccurrencesOfString:@"qa\\" withString:@""];
    }
    else if ([subscriber containsString:@"beta\\"])
    {
        appD.eSUBServerURL = keSUBBETAServerURL;
        subscriber = [subscriber stringByReplacingOccurrencesOfString:@"beta\\" withString:@""];
    }
    else
    {
        appD.eSUBServerURL = keSUBServerURL;
    }

    if ([appD.reachability currentReachabilityStatus] == NotReachable)
    {
        appD.userId = [appD.eSubsDB checkForUser:subscriber forUserName:email andPassword:password];
        if (appD.userId != 0)
        {
            ChooseProjectViewController *chooseProjectVC = [[ChooseProjectViewController alloc] initWithNibName:@"ChooseProjectViewController" bundle:nil];
            chooseProjectVC.refresh = YES;
            [self.navigationController pushViewController:chooseProjectVC animated:YES];
            return;
        }
    }

    [DejalBezelActivityView activityViewForView:self.view];

    LoginAFHTTPClient *client = [LoginAFHTTPClient sharedClient:[NSURL URLWithString:appD.eSUBServerURL]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setObject:@"password" forKey:@"grant_type"];
    [params setObject:subscriber forKey:@"client_id"];
//    [params setObject:@"&%(&@^^" forKey:@"client_secret"];
//    [params setObject:@"support@esubinc.com" forKey:@"username"];
//    [params setObject:@"gato" forKey:@"password"];
    [params setObject:self.emailTextbox.text forKey:@"username"];
    [params setObject:self.passwordTextbox.text forKey:@"password"];

    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"Authenticate/" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];

            if ([JSON objectForKey:@"access_token"])
            {
                appD.tokenAccess = [JSON objectForKey:@"access_token"];
                appD.tokenExpires = [JSON objectForKey:@"expires_in"];
                appD.tokenType = [JSON objectForKey:@"token_type"];

                if (self.rememberMeButton.selected)
                {
                    NSString *a = [self.subscriberTextbox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [[NSUserDefaults standardUserDefaults] setObject:a forKey:kRememberedSubscriberDataKey];
                    [[NSUserDefaults standardUserDefaults] setObject:email forKey:kRememberedEmailDataKey];
                    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kRememberedPasswordDataKey];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRememberedSubscriberDataKey];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRememberedEmailDataKey];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRememberedPasswordDataKey];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRememberedRememberFlagDataKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.rememberMeButton.selected] forKey:kRememberedRememberFlagDataKey];
                [[NSUserDefaults standardUserDefaults] synchronize];

                appD.userId = [appD.eSubsDB insertUser:subscriber forUserName:email andPassword:password];
                //update the offline Data
                [self updateOfflineData];
                
                ChooseProjectViewController *chooseProjectVC = [[ChooseProjectViewController alloc] initWithNibName:@"ChooseProjectViewController" bundle:nil];
                chooseProjectVC.refresh = YES;
                [self.navigationController pushViewController:chooseProjectVC animated:YES];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
        {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            if ([JSON objectForKey:@"exception"])
            {
                NSDictionary *exception = [JSON objectForKey:@"exception"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[exception objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    
    [operation start];
    
}

- (IBAction)rememberMeAction:(id)sender
{
    
    self.rememberMeButton.selected = !self.rememberMeButton.selected;
    
}

- (void)updateOfflineData
{
    
    AppDelegate *appD = (id) [[UIApplication sharedApplication] delegate];
    NetworkStatus remoteHostStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    
    if (remoteHostStatus != NotReachable && appD.tokenAccess)
    {
        for (NoteObject *note in [appD.eSubsDB getUnsavedNoteImageObjects:appD.userId])
        {
            [Common saveNoteImageToWebService:[appD.eSubsDB getNoteObject:note.projectId andNoteId:note.id forUserID:appD.userId]];
        }
        
        for (NoteObject *note in [appD.eSubsDB getUnsavedNoteObjects:appD.userId])
        {
            NoteObject *n = [appD.eSubsDB getNoteObject:note.projectId andNoteId:note.id forUserID:appD.userId];
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld", (long)n.id]];
            if (!str)
            {
                str = [[NSUUID UUID] UUIDString];
            }
            [Common saveNoteToWebService:n usingUUID:str];
        }
        
        NSMutableArray *listOfDR = [appD.eSubsDB getUnsavedDailyReportsObjects:appD.userId];
        for (int i = 0; i < listOfDR.count; i++ )
        {
            DailyReportObject *dr = [listOfDR objectAtIndex:i];
            NSString *zipCode = dr.weatherIcon;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd-yyyy"];
            NSDate *dateDr = [formatter dateFromString:dr.date];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *date  =[formatter stringFromDate:dateDr];
            
            BOOL isLastValue =(i < listOfDR.count);
            //get weather information todo
            if (zipCode)
            {
                [Common GetPastWeather:zipCode forDate:date
                               success:^(id responseObject)
                 {
                     NSDictionary *data = [responseObject objectForKey:@"data"];
                     NSArray *w = [data objectForKey:@"weather"];
                     if (w.count > 0)
                     {
                         NSDictionary *ndata = [w objectAtIndex:0];
                         NSArray *h = [ndata objectForKey:@"hourly"];
                         if (h.count > 4)
                         {
                             NSDictionary *hourly = [h objectAtIndex:4];
                             dr.weatherId = [[hourly objectForKey:@"weatherCode"] integerValue];
                             NSInteger windSpeed = [[hourly objectForKey:@"windspeedMiles"] integerValue];
                             if (windSpeed <= 2)
                             {
                                 dr.windId = 1;
                             }
                             else if (windSpeed > 2 && windSpeed <= 15)
                             {
                                 dr.windId = 2;
                             }
                             else if (windSpeed > 15 && windSpeed <= 22)
                             {
                                 dr.windId = 3;
                             }
                             else if (windSpeed > 22)
                             {
                                 dr.windId = 4;
                             }
                             else
                             {
                                 dr.windId = 0;
                             }
                             dr.temperature = [[hourly objectForKey:@"tempF"] integerValue];
                             NSArray *weatherIconUrl = [hourly objectForKey:@"weatherIconUrl"];
                             if (weatherIconUrl.count)
                             {
                                 NSDictionary *val = [weatherIconUrl objectAtIndex:0];
                                 dr.weatherIcon = [val objectForKey:@"value"];
                             }
                         }
                     }
                     
                     [self SaveDaliyReport:dr IsLast:isLastValue Delegate:appD];
                     
                 }
                failure:^(NSError *error)
                 {
                     NSLog(@"Network error in downloading weather: %@", [error localizedDescription]);
                     [self SaveDaliyReport:dr IsLast:isLastValue Delegate:appD];
                     
                 }];
                
            }
            else
            {
                [self SaveDaliyReport:dr IsLast:isLastValue Delegate:appD];
            }
        
            //end
        }
        if (listOfDR.count == 0)
        {
            [Common saveUnsavedCrewsToWebService];
            
            for (EquipmentObject *equipmentObject in [appD.eSubsDB getSavedEquipmentObjects:appD.userId])
            {
                [Common saveUnsavedEquipmentToWebService:equipmentObject
                                                 success:^(id responseObject) {
                                                 }
                                                 failure:^(NSError *error){
                                                 }];
                
            }
            
            for (UploadObject *uploadObject in [appD.eSubsDB getUnsavedUploadAttachmentPhotoObjects:appD.userId])
            {
                [Common saveUNsavedUploadAttachmentsPhotosToWebService:uploadObject];
            }
        }
    }
    
}

-(void) SaveDaliyReport:(DailyReportObject *) dr IsLast:(BOOL)isLastvalue Delegate:(AppDelegate *) appD
{
    [Common saveDailyReportToWebService:dr isLast:isLastvalue
                                success:^(id responseObject)
     {
         NSMutableArray *crewList = [appD.eSubsDB getCrewObjects:dr.projectId forDailyReportId:dr.drCopyId];
         NSMutableArray *c = [Common buildExistingCrewRows:crewList];
         
         if (c.count > 0)
         {
             [Common saveCrewsToWebService:c forProjectId:dr.projectId forDRId:[[responseObject objectForKey:@"Id"] integerValue] forDate:dr.date forId:-1
              success:^(id responseObject)
              {
              }
              failure:^(NSError *error)
              {
              }];
         }
         NSMutableArray *listOfEquipment = [appD.eSubsDB getEquipmentObjects:appD.userId forProjectId:dr.projectId andDailyReportId:dr.drCopyId];
         for (EquipmentObject *e in listOfEquipment)
         {
             e.id = 0;
             e.dailyReportId = [[responseObject objectForKey:@"Id"] integerValue];
             [Common saveUnsavedEquipmentToWebService:e
                                              success:^(id responseObject) {
                                              }
                                              failure:^(NSError *error){
                                              }];
         }
         
         // to do add local data to server.
         NSMutableArray *getListUnSaveToServer = [appD.eSubsDB getFlagMaterialObjects:dr.projectId];
         for (MaterialsObject *obj in getListUnSaveToServer) {
             obj.id = 0;
             obj.dailyReportId =[[responseObject objectForKey:@"Id"] integerValue];
             [Common SaveMaterial:obj dailyReportId:obj.dailyReportId
            success:^(id responseObject)
              {
                  [appD.eSubsDB updateProjectMaterialObjectFlag:obj forProjectId:dr.projectId];
              }
                          failure:^(NSError *error)
              {
              }];
         }
         
     }
          failure:^(NSError *error)
     {
     }];
}

@end
