//
//  ViewController.m
//  搞笑选择题
//
//  Created by 三哥哥 on 2019/4/11.
//  Copyright © 2019年 三哥哥. All rights reserved.
//

#import "ViewController.h"
#import "WZHQuestion.h"
@interface ViewController ()
@property (nonatomic,strong) NSArray *questions;
//控制题目索引
@property (nonatomic,assign) int index;

//记录头像按钮的原始frame
@property (nonatomic,assign) CGRect iconframe;

@property (weak, nonatomic) IBOutlet UILabel *lblindex;
@property (weak, nonatomic) IBOutlet UIButton *btnscore;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@property (weak, nonatomic) IBOutlet UIButton *btnicon;
@property (weak, nonatomic) IBOutlet UIButton *btnnext;
@property (weak, nonatomic) IBOutlet UIView *answerview;
@property (weak, nonatomic) IBOutlet UIView *optionsview;



//用来引用那个阴影按钮的属性
@property (nonatomic,strong) UIButton *cover;
- (IBAction)btnnextclick;
- (IBAction)bigimage:(id)sender;

@end

@implementation ViewController
-(NSArray *)questions{
    if(!_questions){
        NSString *path=[[NSBundle mainBundle]pathForResource:@"xzq.plist" ofType:nil];
        NSArray *arraydict=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arraymodel=[NSMutableArray array];
        for (NSDictionary *dict in arraydict) {
            WZHQuestion *model=[WZHQuestion questionwithdict:dict];
            [arraymodel addObject:model];
        }
        _questions=arraymodel;
        
    }
    return _questions;
}
//改变状态栏的文字颜色为白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
//隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认第一题
    self.index=-1;
    [self nextquestion];
}


//点击下一题
- (IBAction)btnnextclick {
    
    [self nextquestion];
    
}
//显示大图
- (IBAction)bigimage:(id)sender {
    
    //记录一下原始头像按钮的frame
    self.iconframe=self.btnicon.frame;
    
    
    
    
    //1.创建大小与self.view一样的按钮,把这个按钮作为一个"阴影"
    UIButton *btncover=[[UIButton alloc]init];
    //设置按钮的大小
    btncover.frame = self.view.bounds;
    btncover.backgroundColor=[UIColor blackColor];
    btncover.alpha=0;
    [self.view addSubview:btncover];
    
    //为阴影按钮注册一个单机事件
    [btncover addTarget:self action:@selector(samllimage) forControlEvents:UIControlEventTouchUpInside];
    
    //2.把头像放在阴影上面
    [self.view bringSubviewToFront:self.btnicon];
    
    self.cover=btncover;
    
    //3.通过动画的方式把图片放大
    CGFloat iconw=self.view.frame.size.width;
    CGFloat iconh=iconw;
    CGFloat iconx=0;
    CGFloat icony=(self.view.frame.size.height - iconh)*0.5;
    [UIView animateWithDuration:0.7 animations:^{
        self.btnicon.frame=CGRectMake(iconx, icony, iconw, iconh);
        btncover.alpha=0.6;
    }];
    
    
}

- (IBAction)btniconclick:(id)sender {
    if(self.cover==nil){
        //显示大图
        [self bigimage:nil];
    }else{
        [self samllimage];
    }
}

//阴影点击回复正常
-(void)samllimage{
    
    
    [UIView animateWithDuration:0.7 animations:^{
        //1.设置btnico头像按钮frame还原
        self.btnicon.frame=self.iconframe;
        
        //2.让阴影按钮的透明还原0
        self.cover.alpha=0.0;
        
    } completion:^(BOOL finished) {
        if(finished){
            //3.移除阴影按钮
            [self.cover removeFromSuperview];
            //图片缩小后,为nil
            self.cover = nil;
        }
    }];
}
//下一题
-(void)nextquestion{
    
    //1.索引++
    self.index++;
    
    //判断当前索引是否越界,入股
    if(self.index == self.questions.count){
        NSLog(@"答题完毕");
        return;
    }
    
    
    
    
    //2.根据索引获取当前的模型数据
    WZHQuestion  *model=self.questions[self.index];
    
    //3.把模型数据设置到界面对应的控件上
    
    self.lblindex.text=[NSString stringWithFormat:@"%d / %ld",(self.index+1),self.questions.count];
    self.lbltitle.text=model.title;
    [self.btnicon setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    
    //4.设置到达最后一题禁用下一题按钮
    //如果索引 不等于6的话就执行 等于的话不执行
    self.btnnext.enabled=(self.index !=self.questions.count-1);
    
    
    //5.动态创建答案按钮
    //5.0清除所有的答案按钮
//    while (self.answerview.subviews.firstObject) {
//        [self.answerview.subviews.firstObject removeFromSuperview];
//    }
    [self.answerview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //5.1获取当前答案的文字
    NSUInteger len = model.answer.length;
    //5.2循环创建答案按钮,有几个文字创建几个按钮
    for (int i = 0; i<len; i++) {
        UIButton *btnanswer = [[UIButton alloc]init];
        [btnanswer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnanswer.backgroundColor=[UIColor whiteColor];
        //设置按钮
        CGFloat marginleft=(self.answerview.frame.size.width - (len-1)*80)/2;
        btnanswer.frame=CGRectMake(marginleft+i*(35+20), 0, 35, 35);
        
        //把按钮添加
        [self.answerview addSubview:btnanswer];
        
        [btnanswer addTarget:self action:@selector(btnanswerclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    self.optionsview.userInteractionEnabled=YES;
    //创建带选按钮
    //1.清除按钮
    [self.optionsview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //2.获取当前题目文字的数组
    NSArray *words = model.options;
    
    CGFloat optionw=35;
    CGFloat optionh=35;
    CGFloat margin=10;
    //知道一行多少按钮
    int columns=7;
    CGFloat marginleft=(self.optionsview.frame.size.width - columns*optionw - (columns-1)*margin)/2;
    //3.根据待选文字循环来创建按钮
    for (int i = 0; i<words.count; i++) {
        UIButton *btnopt = [[UIButton alloc]init];
        
        //给没一个option按钮一个唯一的tag值
        btnopt.tag=i;
        btnopt.backgroundColor=[UIColor whiteColor];
        [btnopt setTitle:words[i] forState:UIControlStateNormal];
        [btnopt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //计算当前按钮的列的索引和行的索引
        int colidx = i % columns;
        int rowidx = i / columns;
        CGFloat optionx = marginleft +colidx * (optionw + margin);
        CGFloat optiony = 10 + rowidx * (optionh + margin);
        btnopt.frame = CGRectMake(optionx, optiony, optionw, optionh);
        [self.optionsview addSubview:btnopt];
        
        [btnopt addTarget:self action:@selector(optionbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)btnanswerclick:(UIButton *)sender{
    //0.启用option view与用户的交互
    self.optionsview.userInteractionEnabled=YES;
    
    [self setanswerbuttontitilecolor:[UIColor blackColor]];
    //1.找到待选
    for (UIButton *optbtn in self.optionsview.subviews) {
//        if([sender.currentTitle isEqualToString:optbtn.currentTitle]){
//            optbtn.hidden=NO;
//        }
        if(sender.tag == optbtn.tag){
            optbtn.hidden=NO;
            break;
        
        }
    }
    //2.清空当前被点击按钮
    [sender setTitle:nil forState:UIControlStateNormal];
    
}
-(void)optionbuttonclick:(UIButton *)sender{
    //1.隐藏当前被点击的按钮
    sender.hidden=YES;
    //2.把当前被点击的按钮的文字显示到第一个为空的答案按钮上
    NSString *text = sender.currentTitle;//获取按钮当前状态下的文字
    
    
  
    
    //2.1 把文字显示到答案按钮上
    for (UIButton *answerbtn in self.answerview.subviews) {
        //判断每一个答案按钮上的文字是否为nil
        if(answerbtn.currentTitle == nil){
            
            [answerbtn setTitle:text forState:UIControlStateNormal];
            //把当前点击的待选按钮的tag值也设置给对应的答案按钮
            answerbtn.tag=sender.tag;
            break;
             
        }
    }
    BOOL isfull = YES;
    
    
    
    NSMutableString *userinput =[NSMutableString string];
    for (UIButton *btnanswer in self.answerview.subviews) {
        if(btnanswer.currentTitle == nil){
            isfull=NO;
            break;
        }else{
            [userinput appendString:btnanswer.currentTitle];
        }
    }
    //3.判断答案按钮是否已经满了
    if(isfull){
        //禁止待选按钮被点击
        self.optionsview.userInteractionEnabled = NO;
        //获取当前题目的正确答案
        WZHQuestion *model = self.questions[self.index];
        //4.如果答案按钮被填满了.那么久判断用户点击输入的答案是否与标准答案一致,
        if([model.answer isEqualToString:userinput]){
        //如果一致,则设置答案按钮的文字颜色为蓝色,同时在0.5秒之后跳转下一题
            
            //蓝色
            [self setanswerbuttontitilecolor:[UIColor blueColor]];
            
            
            //延迟0.5庙后,跳转到下一题
            [self performSelector:@selector(nextquestion) withObject:nil afterDelay:0.5];
        }else{
            //如果答案不一致 (答案错误)
            //红色
            [self setanswerbuttontitilecolor:[UIColor redColor]];
        }
        
    }
   
    
}
-(void)setanswerbuttontitilecolor:(UIColor *)color{
    //遍历每一个答案按钮,设置文字颜色
    for (UIButton *btnanswer in self.answerview.subviews) {
        [btnanswer setTitleColor:color forState:UIControlStateNormal];
    }
}
@end
