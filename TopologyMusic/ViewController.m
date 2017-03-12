//
//  ViewController.m
//  TopologyMusic
//
//  Created by Phineas_Huang on 07/03/2017.
//  Copyright © 2017 SunXiaoShan. All rights reserved.
//

#import "ViewController.h"
#import "NodeManager.h"
#import "CustomButton.h"
#import "AudioManager.h"


@interface ViewController ()
{
    NSMutableArray *btnList;
    NSMutableDictionary *btnDict;
    
    BOOL isCreateNode;
    BOOL isCreateMinPath;
}

@property (weak, nonatomic) IBOutlet CustomButton *btnStart;
@property (weak, nonatomic) IBOutlet CustomButton *btnEnd;

@property (weak, nonatomic) IBOutlet CustomButton *btn11;
@property (weak, nonatomic) IBOutlet CustomButton *btn12;
@property (weak, nonatomic) IBOutlet CustomButton *btn13;

@property (weak, nonatomic) IBOutlet CustomButton *btn21;
@property (weak, nonatomic) IBOutlet CustomButton *btn22;
@property (weak, nonatomic) IBOutlet CustomButton *btn23;

@property (weak, nonatomic) IBOutlet CustomButton *btn31;
@property (weak, nonatomic) IBOutlet CustomButton *btn32;
@property (weak, nonatomic) IBOutlet CustomButton *btn33;

@property (weak, nonatomic) IBOutlet CustomButton *btn41;
@property (weak, nonatomic) IBOutlet CustomButton *btn42;
@property (weak, nonatomic) IBOutlet CustomButton *btn43;

@property (weak, nonatomic) IBOutlet CustomButton *btn51;
@property (weak, nonatomic) IBOutlet CustomButton *btn52;
@property (weak, nonatomic) IBOutlet CustomButton *btn53;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    
    [self initVariable];
    [self settButtonAction];
}

- (void) initVariable {
    btnDict = [[NSMutableDictionary alloc] init];
    
    btnList = [[NSMutableArray alloc] initWithCapacity: MAX_SECTION];
    [btnList insertObject:[NSMutableArray arrayWithObjects:_btn11,_btn12,_btn13,nil] atIndex:0];
    [btnList insertObject:[NSMutableArray arrayWithObjects:_btn21,_btn22,_btn23,nil] atIndex:1];
    [btnList insertObject:[NSMutableArray arrayWithObjects:_btn31,_btn32,_btn33,nil] atIndex:2];
    [btnList insertObject:[NSMutableArray arrayWithObjects:_btn41,_btn42,_btn43,nil] atIndex:3];
    [btnList insertObject:[NSMutableArray arrayWithObjects:_btn51,_btn52,_btn53,nil] atIndex:4];
}

- (void) settButtonAction {
    
    [_btn11 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    [_btn12 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    [_btn13 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn21 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    [_btn22 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    [_btn23 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn31 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    [_btn32 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    [_btn33 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn41 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    [_btn42 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    [_btn43 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn51 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    [_btn52 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
    [_btn53 addTarget:self action:@selector(actionPlayTone:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) resetNodes {
    [[NodeManager getInstance] actionFillHole];
    [[NodeManager getInstance] actionMakeBridge];
    [btnDict removeAllObjects];
    
    [[NodeManager getInstance] debug];
    
    _btnStart.node = [[NodeManager getInstance] getStartNode];
    _btnEnd.node = [[NodeManager getInstance] getEndNode];
    
    NSMutableArray *map = [[NodeManager getInstance] getNodesMap];
    for (int section=0; section<[btnList count]; section++) {
        NSMutableArray *rowList = btnList[section];
        for (int row=0; row<[rowList count]; row++) {
            CustomButton *btn = rowList[row];
            if ([map[section][row] isKindOfClass:[Node class]]) {
                Node *node = map[section][row];
                btn.node = node;
                node.btnTag = btn.tag;
                btn.hidden = NO;
                [btn setTitle:[NSString stringWithFormat:@"%ld", node.value] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"Blue"] forState:UIControlStateNormal];
                [btnDict setObject:btn forKey:node.nodeId];
                
            } else {
                btn.hidden = YES;
                btn.node = NULL;
                [btn setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
    [btnDict setObject:_btnStart forKey:_btnStart.node.nodeId];
    [btnDict setObject:_btnEnd forKey:_btnEnd.node.nodeId];
    
    [self drawArrowLine];
}

- (void) drawArrowLine {
    for (CALayer *layer in [self.view.layer.sublayers copy]) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    Node *start = _btnStart.node;
    Node *end = _btnEnd.node;
    for (Node *buf in start.children) {
        CustomButton *btn = btnDict[buf.nodeId];
        if ([buf isMinPath]) {
            [self drawButtonToButton:_btnStart to:btn color:[UIColor redColor]];
        } else {
            [self drawButtonToButton:_btnStart to:btn color:[UIColor blackColor]];
        }
    }
    
    for (int section=0; section<[btnList count]; section++) {
        NSMutableArray *secList = btnList[section];
        for (int row=0; row<[secList count]; row++) {
            CustomButton *btn = secList[row];
            if (btn.node) {
                Node *node = btn.node;
                for (Node *cn in node.children) {
                    CustomButton *cBtn = btnDict[cn.nodeId];
                    if ([node isMinPath] && ([cn isMinPath] || [cn isEqual:end])) {
                        [self drawButtonToButton:btn to:cBtn color:[UIColor redColor]];
                    } else {
                        [self drawButtonToButton:btn to:cBtn color:[UIColor blackColor]];
                    }
                    
                    if ([node isMinPath]) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"Red"] forState:UIControlStateNormal];
                    } else {
                       [btn setBackgroundImage:[UIImage imageNamed:@"Blue"] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}

- (void) drawButtonToButton:(UIButton *)from to:(UIButton *)to color:(UIColor *)color {
    
    float radius = 25;
    
    CGPoint point1 = from.frame.origin;
    float shift_start_x = RAND_FROM_TO(0, radius);
    point1.x += shift_start_x + radius;
    point1.y += sqrt(radius*radius - shift_start_x*shift_start_x)+radius;
    
    float shift_end_x = RAND_FROM_TO(0, radius);
    CGPoint point2 = to.frame.origin;
    point2.x -= shift_end_x - radius;
    point2.y += sqrt(radius*radius - shift_end_x*shift_end_x) + radius;

    [DrawView drawArrowLine:self.view from:point1 to:point2 color:color];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionTopology:(id)sender {
    [self resetNodes];
    isCreateNode = YES;
}

- (IBAction)actionPlay:(id)sender {
    
    if (!isCreateMinPath) {
        [self actionCaculate:NULL];
    }
    
    NSArray *minPath = [[NodeManager getInstance] getMinPathList];
    for (Node *node in minPath) {
        [AudioManager playTone:node.value];
        sleep(1);
    }
}

- (IBAction)actionCaculate:(id)sender {
    
    if (!isCreateNode) {
        [self actionTopology:NULL];
    }
    
    [[NodeManager getInstance] actionCaculateMinPath];
    [self drawArrowLine];
    isCreateMinPath = YES;
}

- (void) actionPlayTone:(id)sender {
    
    CustomButton *btn = sender;
    [AudioManager playTone:btn.node.value];
}

@end
