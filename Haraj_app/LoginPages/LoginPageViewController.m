//
//  LoginPageViewController.m
//  care2Dare
//
//  Created by Spiel's Macmini on 3/3/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import "LoginPageViewController.h"
#import "SignUpViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Reachability.h"
#import "UIView+RNActivityView.h"
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import "SBJsonParser.h"
#import "HomeNavigationController.h"
#import "MobileViewController.h"
#import "Firebase.h"

#define Buttonlogincolor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]
@interface LoginPageViewController ()
{
    NSUserDefaults *defaults;
    NSDictionary *urlplist;
    NSMutableArray *array_login;
    NSString *emailFb,*DobFb,*nameFb,*genderfb,*profile_picFb,*Fbid,*regTypeVal,*EmailValidTxt,*Str_fb_friend_id,*Str_fb_friend_id_Count, *String_Forgot;
    NSMutableArray *fb_friend_id;
}
@end

@implementation LoginPageViewController
@synthesize Label_TitleName,textfield_uname,textfield_password,Button_Login,view_LoginFB,View_LoginTW,Label_TermsAndCon,Button_LoginFb,Button_LoginTw,Image_logo;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults=[[NSUserDefaults alloc]init];
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if ([UIScreen mainScreen].bounds.size.width==375 && [UIScreen mainScreen].bounds.size.height==812)
    {
        [Image_logo setFrame:CGRectMake(Image_logo.frame.origin.x, Image_logo.frame.origin.y+22, Image_logo.frame.size.width, Image_logo.frame.size.height)];
    }
 //   NSString *myString = @"Care2Dare";
 //   NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
 //   NSRange range = [myString rangeOfString:@"Care2"];
 //   [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:20/255.0 green:245/255.0 blue:115/255.0 alpha:1.0] range:range];
//    Label_TitleName.attributedText = attString;
    
    CALayer *borderBottom_uname = [CALayer layer];
    borderBottom_uname.backgroundColor = [UIColor whiteColor].CGColor;
    borderBottom_uname.frame = CGRectMake(0, textfield_uname.frame.size.height-0.8, textfield_uname.frame.size.width,0.5f);
    [textfield_uname.layer addSublayer:borderBottom_uname];
    
    CALayer *borderBottom_passeord = [CALayer layer];
    borderBottom_passeord.backgroundColor = [UIColor whiteColor].CGColor;
    borderBottom_passeord.frame = CGRectMake(0, textfield_password.frame.size.height-0.8, textfield_password.frame.size.width,0.5f);
    [textfield_password.layer addSublayer:borderBottom_passeord];
    
    
    Button_Login.clipsToBounds=YES;
    Button_Login.layer.cornerRadius=5.0f;
    Button_Login.layer.borderColor=[UIColor whiteColor].CGColor;
    Button_Login.layer.borderWidth=0.5;
    
    
    view_LoginFB.clipsToBounds=YES;
    view_LoginFB.layer.cornerRadius=5.0f;
    view_LoginFB.layer.borderColor=[UIColor whiteColor].CGColor;
    view_LoginFB.layer.borderWidth=1.0f;
    UITapGestureRecognizer * LoginFB =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LoginWithFbAction:)];
    [view_LoginFB addGestureRecognizer:LoginFB];

    
    View_LoginTW.clipsToBounds=YES;
    View_LoginTW.layer.cornerRadius=5.0f;
    View_LoginTW.layer.borderColor=[UIColor whiteColor].CGColor;
    View_LoginTW.layer.borderWidth=1.0f;
    UITapGestureRecognizer * LoginTW =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LoginWithTwitterAction:)];
    [View_LoginTW addGestureRecognizer:LoginTW];
    
    CALayer *borderLeftFb = [CALayer layer];
    borderLeftFb.backgroundColor = [UIColor whiteColor].CGColor;
    borderLeftFb.frame = CGRectMake(0, 0, 1.0,Button_LoginFb.frame.size.height);
    [Button_LoginFb.layer addSublayer:borderLeftFb];
    
    CALayer *borderLeftTw = [CALayer layer];
    borderLeftTw.backgroundColor = [UIColor whiteColor].CGColor;
    borderLeftTw.frame = CGRectMake(0, 0, 1.0, Button_LoginTw.frame.size.height);
    [Button_LoginTw.layer addSublayer:borderLeftTw];
    
    UIFont *arialFont = [UIFont fontWithName:@"San Francisco Display" size:14.0];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:@"By signing in, you agree to our " attributes: arialDict];
    
    UIFont *VerdanaFont = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:16.0];
    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: @"Terms & Conditions" attributes:verdanaDict];
    [aAttrString appendAttributedString:vAttrString];
    Label_TermsAndCon.attributedText = aAttrString;
    
    
    [Button_Login setTitleColor:Buttonlogincolor forState:UIControlStateNormal];
    Button_Login.enabled=NO;
    
    
    FRHyperLabel *label = self.termLabel;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont fontWithName:@"San Francisco Display" size:12]];
    
    //Step 1: Define a normal attributed string for non-link texts
    
    NSString *string = @"By signing in, you agree to our Terms & Conditions";
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:(255/255.0) green:255/255.0 blue:255/255.0 alpha:1],NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]};
    
    
    label.attributedText = [[NSAttributedString alloc]initWithString:string attributes:attributes];
    
    //Step 2: Define a selection handler block
    
    void(^handler)(FRHyperLabel *label, NSString *substring) = ^(FRHyperLabel *label, NSString *substring)
    {
        
        if ([substring isEqualToString:@"Terms & Conditions"])
        {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.tammapp.com/terms.html"]];
            
        }
        
    };
    
    //Step 3: Add link substrings
    
    [label setLinksForSubstrings:@[@"Terms & Conditions"] withLinkHandler:handler];
    
}

-(IBAction)SignUpView:(id)sender
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignUpViewController * set=[mainStoryboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:set animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


-(IBAction)ForgetPasswordAction:(id)sender
{
    
//    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Forgot Password" message:@"To send your password, please enter your registered email address." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    
    
    
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"كلمة السر" message:@"لإرسال كلمة السر، الرجاء ادخال الإيميل المسجل لحسابك" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
    NSLog(@"dddd=%@",av);
 
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100)
    {
        exit(0);
    }
    else
    {
        if (buttonIndex==1)
        {
            if ([[alertView textFieldAtIndex:0].text isEqualToString:@""])
            {
                
            }
            else
            {
                String_Forgot=[alertView textFieldAtIndex:0].text;
                [self ForgetPasswordCommunication];
                NSLog(@"%@", [alertView textFieldAtIndex:0].text);
            }
        }
        
    }
}
-(void)ForgetPasswordCommunication
{
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    
    
    if ([emailTest evaluateWithObject:String_Forgot] == NO)
        
    {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"This seems to be incorrect. Please enter a valid email address and try again." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        [self.view endEditing:YES];
    }
    
    else
    {
        
        [self.view endEditing:YES];
        [self.view showActivityViewWithLabel:@"Loading"];
        NSString *email= @"email";
        
        
        
        
      NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@",email,String_Forgot];
        
        
        
#pragma mark - swipe sesion
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url;
        NSString *  urlStrLivecount=[urlplist valueForKey:@"forgotpassword"];;
        url =[NSURL URLWithString:urlStrLivecount];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                         {
                                             if(data)
                                             {
                                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                 NSInteger statusCode = httpResponse.statusCode;
                                                 if(statusCode == 200)
                                                 {
                                                     
                                                     NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                     
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                     
                                                     
                                                     if ([ResultString isEqualToString:@"noemail"])
                                                     {
                                                         [self.view hideActivityViewWithAfterDelay:0];
//                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"The email address you have entered is not registered in our system or your account has been deactivated. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"تنبيه!" message:@"الإيميل الذي أدخلته غير مطابق للإيميل المسجل على حسابك. الرجاء المحاولة مرة أخرى" preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault handler:nil];
                                                         [alertController addAction:actionOk];
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                         
                                                     }
                                                     if ([ResultString isEqualToString:@"facebooklogin"])
                                                     {
                                                         [self.view hideActivityViewWithAfterDelay:0];
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You have registered with us via Facebook. Please use the Login with Facebook feature." preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault handler:nil];
                                                         [alertController addAction:actionOk];
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                     }
                                                     
                                                     if ([ResultString isEqualToString:@"twitterlogin"])
                                                     {
                                                         [self.view hideActivityViewWithAfterDelay:0];
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You have registered with us via Twitter. Please use the Login with Twitter feature." preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                                                                          handler:nil];
                                                         
                                                         [alertController addAction:actionOk];
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                         
                                                     }
                                                     
                                                     if ([ResultString isEqualToString:@"sent"])
                                                     {
                                                         [self.view hideActivityViewWithAfterDelay:0];
//                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Password Sent" message:@"Your password has been sent to your registered email address. Thank-you!" preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"تم ارسال كلمة السر!" message:@"تم ارسال كلمة السر على الايميل المسجل لحسابك. شكراً" preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                                                         
                                                         [alertController addAction:actionOk];
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                     }
                                                     
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     
                                                 }
                                                 
                                                 else
                                                 {
                                                     NSLog(@" error login1 ---%ld",(long)statusCode);
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                 }
                                                 
                                                 
                                             }
                                             else if(error)
                                             {
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                                 NSLog(@"error login2.......%@",error.description);
                                             }
                                             
                                             
                                         }];
        [dataTask resume];
    }
}



#pragma mark - FB Action

-(void)LoginWithFbAction:(UITapGestureRecognizer *)sender
    {
    
    
    
    [self.view endEditing:YES];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        //        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Play:Date." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        //        message.tag=100;
        //        [message show];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Tamm app." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }
    else
    {
        [self.view showActivityViewWithLabel:@"Loading"];
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile", @"email",@"user_friends"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             NSLog(@"Process result=%@",result);
             NSLog(@"Process error=%@",error);
             if (error)
             {
                 [self.view hideActivityViewWithAfterDelay:1];
                 
                 NSLog(@"Process error");
             }
             else if (result.isCancelled)
             {
                 [self.view hideActivityViewWithAfterDelay:1];
                 
                 NSLog(@"Cancelled");
             }
             else
             {
                 
                 NSLog(@"Logged in");
                 NSLog(@"Process result123123=%@",result);
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,friends,name,first_name,last_name,gender,email,picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         if ([result isKindOfClass:[NSDictionary class]])
                         {
                             NSLog(@"Results=%@",result);
                             emailFb=[result objectForKey:@"email"];
                             Fbid=[result objectForKey:@"id"];
                             //  nameFb=[NSString stringWithFormat:@"%@%@%@",[result objectForKey:@"first_name"],@" ",[result objectForKey:@"last_name"]];
                             nameFb=[result objectForKey:@"name"];
                             genderfb=[result objectForKey:@"gender"];
                                                    
                             
                             NSArray * allKeys = [[result valueForKey:@"friends"]objectForKey:@"data"];
                             
//                             fb_friend_Name = [[NSMutableArray alloc]init];
                             fb_friend_id  =  [[NSMutableArray alloc]init];
                             
                             for (int i=0; i<[allKeys count]; i++)
                             {
                    //   [fb_friend_Name addObject:[[[[result valueForKey:@"friends"]objectForKey:@"data"] objectAtIndex:i] valueForKey:@"name"]];
                              
                        [fb_friend_id addObject:[[[[result valueForKey:@"friends"]objectForKey:@"data"] objectAtIndex:i] valueForKey:@"id"]];
                                 
                             }
                             Str_fb_friend_id_Count=[NSString stringWithFormat:@"%lu",(unsigned long)fb_friend_id.count];
                        Str_fb_friend_id=[fb_friend_id componentsJoinedByString:@","];
                             NSLog(@"Friends ID : %@",Str_fb_friend_id);
                             ///NSLog(@"Friends Name : %@",fb_friend_Name);
                             
                             profile_picFb= [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",Fbid];
                             
                             [defaults setObject:nameFb forKey:@"UserName"];
                             [defaults setObject:profile_picFb forKey:@"ProImg"];
                             [defaults synchronize];

                             
                             NSLog(@"my url DataFBB=%@",result);
                             regTypeVal =@"FACEBOOK";
                             
                             [self FbTwittercommunicationServer];
                             
                         }
                         
                         
                     }
                 }];
                 
             }
             
         }];
    }
   
}

#pragma mark - TW Action

-(void)LoginWithTwitterAction:(UITapGestureRecognizer *)sender
    {
      [self.view endEditing:YES];
    
    
    
    [self.view showActivityViewWithLabel:@"Loading"];
    
    /*   [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
     if (session) {
     NSLog(@"signed in as %@", [session userName]);
     
     } else {
     NSLog(@"error: %@", [error localizedDescription]);
     }
     }];
     */
    
    [[Twitter sharedInstance] logInWithMethods:TWTRLoginMethodWebBased completion:^(TWTRSession *session, NSError *error)
     {
         if (session)
         {
             
             NSLog(@"signed in as %@", [session userName]);
             NSLog(@"signed in as %@", session);
             
             TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
             NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                              URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
                                                       parameters:@{@"include_email": @"true", @"skip_status": @"true"}
                                                            error:nil];
             
             //@"https://api.twitter.com/1.1/users/show.json";
             
             
             [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  NSLog(@"datadata in as %@", data);
                  NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                  NSLog(@"ResultString in as %@", ResultString);
                  NSMutableDictionary *  Array_sinupFb=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                  
                  NSLog(@"Array_sinupFbArray_sinupFb in as %@", Array_sinupFb);
                  NSLog(@"emailemail in as %@", [Array_sinupFb valueForKey:@"email"]);
                  NSLog(@"location in as %@", [Array_sinupFb valueForKey:@"location"]);
                  NSLog(@"name in as %@", [Array_sinupFb valueForKey:@"name"]);
                  nameFb=[Array_sinupFb valueForKey:@"name"];
                  emailFb=[Array_sinupFb valueForKey:@"email"];
                  Fbid= [session userID];
                  [defaults setObject:Fbid forKey:@"twitterid"];
                    regTypeVal =@"TWITTER";
                  genderfb=@"";
                  profile_picFb=[Array_sinupFb valueForKey:@"profile_image_url"];
                  
                  
                  [defaults setObject:nameFb forKey:@"UserName"];
                  [defaults setObject:profile_picFb forKey:@"ProImg"];
                  [defaults synchronize];

                  
                  
                  [self TwitterFriendsList];
                  
         //         [self FbTwittercommunicationServer];
                  
              }];
             
             
             
         } else
         {
             NSLog(@"error: %@", [error localizedDescription]);
              [self.view hideActivityViewWithAfterDelay:1];
         }
     }];
    
}
-(IBAction)LoginButtonAction:(id)sender
{
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    
    
    if ([emailTest evaluateWithObject:textfield_uname.text] == NO)
        
    {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Invalid email address.Please try again" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        [textfield_uname becomeFirstResponder];
    }
    
    else
    {
    
    [self.view endEditing:YES];
    [self.view showActivityViewWithLabel:@"Loading"];
    NSString *email= @"email";
    NSString *emailVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)textfield_uname.text,NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;
    
    
    NSString *password= @"password";
    NSString *passwordVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)textfield_password.text,NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
        NSString *city= @"city";
        NSString *cityVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[defaults valueForKey:@"Cityname"],NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;;
        
        NSString *country= @"country";
        NSString *countryVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[defaults valueForKey:@"Countryname"],NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;
        
    NSString *token = [[FIRInstanceID instanceID] token];
    NSString *devicetoken= @"devicetoken";
    NSString *devicetokenVal =token;
    
    NSString *regType= @"regtype";
    NSString *regTypeVal =@"LOGINEMAIL";
    
    NSString *Platform= @"platform";
    NSString *PlatformVal =@"ios";
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",email,emailVal,password,passwordVal,regType,regTypeVal,city,cityVal,country,countryVal,devicetoken,devicetokenVal,Platform,PlatformVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"loginsignup"];;
    url =[NSURL URLWithString:urlStrLivecount];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];//Web API Method
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
       {
           if(data)
              {
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             NSInteger statusCode = httpResponse.statusCode;
                if(statusCode == 200)
     {
                                                 
                        array_login=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 array_login=[objSBJsonParser objectWithData:data];
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 //        Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_Swipe options:kNilOptions error:nil];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"array_loginarray_login %@",array_login);
       
                                                 
                                                 NSLog(@"array_login ResultString %@",ResultString);
                                                 if ([ResultString isEqualToString:@"loginerror"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"خطأ في التسجيل" message:@"الرجاء ادخال عنوان الايميل السجل وكلمة السر لتسجيل الدخول" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"deactive"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Your account is deactive." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 
                                                 if ([ResultString isEqualToString:@"nullerror"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Could not retrieve one of the Account Ids. Please login and try again." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                     
                                                 }
                                    if(array_login.count !=0)
                                    {
                                        
                                      
                                        
                [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"challenges"]] forKey:@"challenges"];
                                        
            
                                        
                [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"email"]] forKey:@"email"];
                                        
            [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"friends"]] forKey:@"friends"];
                                        
            [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"name"]] forKey:@"name"];
                                        
                                        
            [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"profileimage"]] forKey:@"profileimage"];
                                        
        [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"userid"]] forKey:@"userid"];
        [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"regtype"]] forKey:@"logintype"];
                                        
        [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"mobileno"]] forKey:@"mobileNumber"];
         [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"verified"]] forKey:@"verified"];
                                        
    [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"allowpubliccalls"]] forKey:@"allowpubliccalls"];
   [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"pushcomments"]] forKey:@"pushcomments"];
   [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"pushmessages"]] forKey:@"pushmessages"];
   [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"pushoffers"]] forKey:@"pushoffers"];
                                        

                                        
                                        
            
                                        
                                        
                                        
                                        
                                    [self.view hideActivityViewWithAfterDelay:0];
                                        
                                        if ([[[array_login objectAtIndex:0]valueForKey:@"verified"] isEqualToString:@"yes"])
                                            
                                        {
                                            [defaults setObject:@"yes" forKey:@"LoginView"];
                                          
                                            HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
                                            [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
                                            
                                        }
                                        else
                                        {
                                            [defaults setObject:@"no" forKey:@"LoginView"];
                                            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                            MobileViewController * mobileController=[mainStoryboard instantiateViewControllerWithIdentifier:@"MobileViewController"];
                                            [self.navigationController pushViewController:mobileController animated:YES];
                                            
                                        }
                                       [defaults synchronize];   
                                        

//            HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
//            [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
                                        
                                                 }
                                                 
                                              [self.view hideActivityViewWithAfterDelay:0];    
                                                 
                                             }
                                             
                                             else
                                             {
                                                 NSLog(@" error login1 ---%ld",(long)statusCode);
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                             }
                                             
                                             
                                         }
                                         else if(error)
                                         {
                                             [self.view hideActivityViewWithAfterDelay:0];
                                             NSLog(@"error login2.......%@",error.description);
                                         }
                                         
                                         
                                     }];
    [dataTask resume];
    }
}

- (IBAction)usernameTxtAction:(id)sender
{
    UITextField *textField = (UITextField*)sender;
 
    
    
if(textfield_uname.text.length !=0 && textfield_password.text.length !=0 )
{
    Button_Login.enabled=YES;
    [Button_Login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
else
{
  Button_Login.enabled=NO;
    [Button_Login setTitleColor:Buttonlogincolor forState:UIControlStateNormal];
}
     NSLog(@"sendertag %ld",(long)textField.tag);
}
-(void)TwitterFriendsList
{
    
    
    TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:Fbid];
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/friends/ids.json";
    NSDictionary *params = @{@"id" : Fbid};
    NSError *clientError;
    
    NSURLRequest *request = [client URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:params error:&clientError];
    
    if (request) {
        [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                // handle the response data e.g.
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
               
                NSArray *json22=[json objectForKey:@"ids"];
             
                
                               NSLog(@"jsonjson: %d",json22.count);
               
                Str_fb_friend_id=[json22 componentsJoinedByString:@","];
                Str_fb_friend_id_Count=[NSString stringWithFormat:@"%d",json22.count];
                NSLog(@"Str_fb_friend_id: %@",Str_fb_friend_id);
                NSLog(@"jsonjson: %@",json22);
                
                [self FbTwittercommunicationServer];
            }
            else
            {
                NSLog(@"Error: %@", connectionError);
                
                [self TwitterFriendsList];
            }
        }];
    }
    else
    {
    NSLog(@"Error: %@", clientError);
        
        [self TwitterFriendsList];
    }
    
    

}


-(void)FbTwittercommunicationServer
{
    
    
    
    //   [self.view showActivityViewWithLabel:@"Loading"];
    NSString *email= @"email";
    NSString *fbid1;
    if ([regTypeVal isEqualToString:@"FACEBOOK"])
    {
        fbid1= @"fbid";
    }
    else
    {
        fbid1= @"twitterid";
    }
    
    
    NSString *gender= @"gender";
    NSString *name= @"name";
    NSString *imageurl= @"imageurl";
    // [defautls valueForKey:@""];
    
    NSString *password= @"password";
    NSString *passwordVal =@"";
    
    NSString *Dob= @"dateofbirth";
    NSString *DobVal =@"";
    
    NSString *city= @"city";
    NSString *cityVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[defaults valueForKey:@"Cityname"],NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;;
    
    NSString *country= @"country";
    NSString *countryVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[defaults valueForKey:@"Countryname"],NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;
    
    NSString *token = [[FIRInstanceID instanceID] token];
    NSString *devicetoken= @"devicetoken";
    NSString *devicetokenVal =token;
    
    NSString *regType= @"regtype";
    
    
    NSString *Platform= @"platform";
    NSString *PlatformVal =@"ios";
    
    NSString *nooffriends= @"nooffriends";
    
    NSString *friendlist= @"friendlist";
    NSString *friendlistval =[NSString stringWithFormat:@"%@",Str_fb_friend_id];
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",fbid1,Fbid,email,emailFb,gender,genderfb,name,nameFb,password,passwordVal,Dob,DobVal,regType,regTypeVal,city,cityVal,country,countryVal,devicetoken,devicetokenVal,Platform,PlatformVal,imageurl,profile_picFb,nooffriends,Str_fb_friend_id_Count,friendlist,friendlistval];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"loginsignup"];;
    url =[NSURL URLWithString:urlStrLivecount];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];//Web API Method
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                     {
                                         
                                         if(data)
                                         {
                                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                             NSInteger statusCode = httpResponse.statusCode;
                                             if(statusCode == 200)
                                             {
                                                 
                                                 array_login=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 array_login=[objSBJsonParser objectWithData:data];
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 //        Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_Swipe options:kNilOptions error:nil];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"array_loginarray_login %@",array_login);
                                                 
                                                 
                                                 NSLog(@"array_login ResultString %@",ResultString);
                                                 if ([ResultString isEqualToString:@"emailexists-facebook"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You already have a Facebook Account registered with this email id. Please login with Facebook." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"emailexists-twitter"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You already have a Twitter Account registered with this email id. Please login with Twitter." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"emailexists-email"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You already have an Account registered with this email id. Please login with your registered email." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 
                                                 if ([ResultString isEqualToString:@"nullerror"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Could not retrieve one of the Account Ids. Please login and try again." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"inserterror"])
                                                 {
                                                     
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Could not insert  Please try again" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                 }
                                                 
                                                 if(array_login.count !=0)
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"challenges"]] forKey:@"challenges"];
                                                     
                                                     
                                                     
                                                     [defaults setObject:[[array_login objectAtIndex:0]valueForKey:@"email"] forKey:@"email"];
                                                     
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"friends"]] forKey:@"friends"];
                                                     
                                                     [defaults setObject:[[array_login objectAtIndex:0]valueForKey:@"name"] forKey:@"name"];
                                                     
                                                     
                                                     [defaults setObject:[[array_login objectAtIndex:0]valueForKey:@"profileimage"] forKey:@"profileimage"];
                                                     
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"userid"]] forKey:@"userid"];
                                                     
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"regtype"]] forKey:@"logintype"];
                                                     
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"mobileno"]] forKey:@"mobileNumber"];
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"verified"]] forKey:@"verified"];
                                                     
                                                     
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"allowpubliccalls"]] forKey:@"allowpubliccalls"];
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"pushcomments"]] forKey:@"pushcomments"];
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"pushmessages"]] forKey:@"pushmessages"];
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"pushoffers"]] forKey:@"pushoffers"];
                                                     
                                                     
                                                    
                                                     
                                                     
                                                     if ([[[array_login objectAtIndex:0]valueForKey:@"verified"] isEqualToString:@"yes"])
                                                         
                                                     {
                                                         [defaults setObject:@"yes" forKey:@"LoginView"];
                                                         
                                                         
                                                         HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
                                                         [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
                                                         
                                                     }
                                                     else
                                                     {
                                                         [defaults setObject:@"no" forKey:@"LoginView"];
                                                         UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                         MobileViewController * mobileController=[mainStoryboard instantiateViewControllerWithIdentifier:@"MobileViewController"];
                                                         [self.navigationController pushViewController:mobileController animated:YES];
                                                         
                                                     }
                                                     [defaults synchronize];
                                                     
                                                     
                                                     //        HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
                                                     //        [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
                                                     
                                                 }
                                                 
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                                 
                                             }
                                             
                                             else
                                             {
                                                 NSLog(@" error login1 ---%ld",(long)statusCode);
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                             }
                                             
                                             
                                         }
                                         else if(error)
                                         {
                                             [self.view hideActivityViewWithAfterDelay:0];
                                             NSLog(@"error login2.......%@",error.description);
                                         }
                                         
                                         
                                     }];
    [dataTask resume];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}
@end
