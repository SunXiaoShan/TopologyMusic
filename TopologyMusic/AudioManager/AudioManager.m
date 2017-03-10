//
//  MessageAudioManager.m
//  Nim
//
//  Created by Phineas_Huang on 5/4/16.
//  Copyright © 2016 gemtek. All rights reserved.
//

#import "AudioManager.h"
#import <AudioToolbox/AudioToolbox.h>

#define AUDIO_TYPE @"wav"

@implementation AudioManager

+ (void) playTone:(NSInteger)tone {
    switch (tone) {
            
        case 1:
            [self playDo];
            break;
            
        case 2:
            [self playRe];
            break;
            
        case 3:
            [self playMi];
            break;
            
        case 4:
            [self playFa];
            break;
            
        case 5:
            [self playSol];
            break;
        
        case 6:
            [self playLa];
            break;
            
        case 7:
            [self playSi];
            break;
            
            
        default:
            break;
    }
}

+ (void) playDo {
    [self PlaySound:@"316898__jaz-the-man-2__do" fileType:AUDIO_TYPE];
}

+ (void) playRe {
    [self PlaySound:@"316908__jaz-the-man-2__re" fileType:AUDIO_TYPE];
}

+ (void) playMi {
    [self PlaySound:@"316906__jaz-the-man-2__mi" fileType:AUDIO_TYPE];
}

+ (void) playFa {
    [self PlaySound:@"316904__jaz-the-man-2__fa" fileType:AUDIO_TYPE];
}

+ (void) playSol {
    [self PlaySound:@"316912__jaz-the-man-2__sol" fileType:AUDIO_TYPE];
}

+ (void) playLa {
    [self PlaySound:@"316902__jaz-the-man-2__la" fileType:AUDIO_TYPE];
}

+ (void) playSi {
    [self PlaySound:@"316913__jaz-the-man-2__si" fileType:AUDIO_TYPE];
}

+ (void) playDoOctave {
    [self PlaySound:@"316901__jaz-the-man-2__do-octave" fileType:AUDIO_TYPE];
}

+ (void) PlaySound:(NSString*)fileName fileType:(NSString *)fileType {
    
    SystemSoundID mySoundID;
    NSString *myFile=[[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    
    NSURL *mySoundURL =[NSURL fileURLWithPath:myFile];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)mySoundURL,&mySoundID);
    AudioServicesPlaySystemSound(mySoundID);
}

@end
