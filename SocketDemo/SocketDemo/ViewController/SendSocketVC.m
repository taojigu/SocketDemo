//
//  SendSocketVC.m
//  SocketDemo
//
//  Created by gus on 16/6/18.
//  Copyright © 2016年 gujitao. All rights reserved.
//

#import "SendSocketVC.h"
#import "GCDAsyncSocket.h"

@interface SendSocketVC ()<GCDAsyncSocketDelegate>

@property(nonatomic,strong)GCDAsyncSocket* socket;
@property(nonatomic,assign)NSInteger pageIndex;

@property(nonatomic,strong)IBOutlet UITextView* textView;
@property(nonatomic,strong)IBOutlet UILabel* pageLabel;
@property(nonatomic,strong)IBOutlet UILabel* socketLabel;
@property(nonatomic,strong)IBOutlet UILabel* resultLabel;



@end

@implementation SendSocketVC


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    self.pageIndex = 0;
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer*recg = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(textviewSwiped:)];
    recg.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.textView addGestureRecognizer:recg];
    
    recg = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(textviewSwiped:)];
    recg.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.textView addGestureRecognizer:recg];
    
    self.resultLabel.text = @"Not connected";
    
    
    [self refreshUIViews];
    [self updateTextPage];
    [self createSocket];
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendButtonClicked:(id)sender
{
    if(self.textView.text.length==0)
    {
        return;
    }
    
    NSData* data = [self.textView.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:5 tag:-1];
}


-(IBAction)connectButtonClicked:(id)sender
{
    NSError* error = nil;
    [self.socket connectToHost:self.socketAddress onPort:self.socketPort error:&error];
    if (error!=nil)
    {
        self.resultLabel.text = @"Connect failed";
    }
    
}

-(IBAction)disconnectButtonClicked:(id)sender
{
    
    [self.socket disconnect];
    
    self.resultLabel.text = @"Disconnected";
}

-(void)textviewSwiped:(UISwipeGestureRecognizer*)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        self.pageIndex --;
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        self.pageIndex++;
    }
    
    [self updateTextPage];
}

-(void)updateTextPage
{
    self.textView.text = [NSString stringWithFormat:@"Text page at %li",self.pageIndex];
    self.pageLabel.text = [NSString stringWithFormat:@"当前是第%li页，可以通过左右滑动翻页",self.pageIndex];
}

-(void)createSocket
{
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}


-(void)refreshUIViews
{
    self.socketLabel.text = [NSString stringWithFormat:@"%@:%li",self.socketAddress,self.socketPort];
    self.pageLabel.text = [NSString stringWithFormat:@"当前在第%li页，可以通过左右滑动翻页",self.pageIndex];
    
}


#pragma mark -- socket delegate messages

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    self.resultLabel.text = [NSString stringWithFormat:@"Connect %@:%li successful",host,(long)port];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    self.resultLabel.text = @"Socket Disconnected";
}


-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    self.resultLabel.text = @"Socket send successful";
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
