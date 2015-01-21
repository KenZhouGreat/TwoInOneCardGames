//
//  GameResult.m
//  Matchismo
//
//  Created by Ken Zhou on 28/01/2014.
//  Copyright (c) 2014 Ken Zhou. All rights reserved.
//

#import "GameResult.h"
@interface GameResult()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@end

#define ALL_RESULTS_KEY @"all_results_key_GameResults"

@implementation GameResult

+(NSArray *)allGameResults{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    NSDictionary *gameResultsFromUserDefaults = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] ;
    for (id plist in [gameResultsFromUserDefaults allValues]) {
        GameResult *gameResult = [[GameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:gameResult];
    }
    
    
    return allGameResults;
}

- (void)synchronize{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#define START_KEY @"startDate"
#define END_KEY @"endDate"
#define SCORE_KEY @"score"


- (id)asPropertyList{
    return @{START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score) };
}

//convenience initializer
- (id)initFromPropertyList:(id)plist{
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _start = resultDictionary[START_KEY];
            _end    = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            if (!_start || !_end) {
                self = nil;
            }
        }
    }
    return self;
}

- (id)init{
    
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}


@end
