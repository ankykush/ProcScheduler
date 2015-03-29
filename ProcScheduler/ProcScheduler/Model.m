//
//  Model.m
//  ProcScheduler
//
//  Created by Ankush Jain on 29/03/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import "Model.h"


@implementation Model
static Model *singletonInstance = nil;

+ (Model *)getInstance
{
    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    
    return singletonInstance;
}


+(PFUser *)getCurrentUser;

{
    PFUser *user = [PFUser currentUser];
    return user;
}

+ (int)getRowCountFromTable:(NSString *)table
{
    PFQuery *query = [PFQuery queryWithClassName:table];
    return [query countObjects];
}

+ (void)insertObjectWithTable:(NSString *)table
                       values:(NSDictionary *)values
                   completion:(CompletionWithBoolBlock)completion
{
    __block PFObject *parseObject = [PFObject objectWithClassName:table];
    
    for (NSString *key in [values allKeys]) {
        
        [parseObject setObject:[values objectForKey:key]  forKey:key];
    }
    
    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        NSString *object = parseObject.objectId;
        completion(succeeded,error,object);
        
    }];
}

+ (void)updateObject:(NSString *)object
             inTable:(NSString *)table
              values:(NSDictionary *)values
          completion:(CompletionWithBoolBlock)completion
{
    
    PFQuery *query = [PFQuery queryWithClassName:table];
    PFObject *parseObject = [query getObjectWithId:object];
    
    
    for (NSString *key in [values allKeys]) {
        
        [parseObject setObject:[values objectForKey:key]  forKey:key];
    }
    
    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        NSString *object = parseObject.objectId;
        completion(succeeded,error,object);
        
    }];
}

+ (void)updateAllObjects:(NSArray *)objectArray
                 inTable:(NSString *)table
              completion:(CompletionWithBoolBlock)completion
{
    
    [PFObject saveAllInBackground:objectArray block:^(BOOL succeeded, NSError *error) {
        
        completion(succeeded,error,nil);
    }];
}


+ (PFObject *)getParseObjectWithId:(NSString *)object inTable:(NSString *)table
{
    PFQuery *query = [PFQuery queryWithClassName:table];
    PFObject *parseObject = [query getObjectWithId:object];
    
    return parseObject;
}

+ (void)getParseObjectWithId:(NSString *)object
                     inTable:(NSString *)table
                  completion:(CompletionWithObjectBlock)completion
{
    PFQuery *query = [PFQuery queryWithClassName:table];
    
    [query getObjectInBackgroundWithId:object block:^(PFObject *object, NSError *error) {
        
        completion(object,error);
    }];
}

+ (PFFile *)createPFFileFromData:(NSData *)data withName:(NSString *)name
{
    PFFile *parseFile = [PFFile fileWithName:name data:data];
    
    return parseFile;
}

+ (PFObject *)createParseObjectOfTable:(NSString *)table
{
    PFObject *parseObject = [PFObject objectWithClassName:table];
    return parseObject;
}


+ (void)getDataFrom:(NSString *)table
               rows:(NSInteger)numberofrows
          withLimit:(NSInteger)skiprows
            orderBy:(NSString *)order
         completion:(CompletionWithArrayBlock)completion
{
    PFQuery *query = [PFQuery queryWithClassName:table];
    query.skip = skiprows;
    query.limit = numberofrows;
    [query orderByAscending:order];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        completion(objects,error,nil);
        
    }];
}


+ (void)getDataFrom:(NSString *)table
            orderBy:(NSString *)order
         completion:(CompletionWithArrayBlock)completion
{
    PFQuery *query = [PFQuery queryWithClassName:table];
    [query orderByAscending:order];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        completion(objects,error,nil);
        
    }];
}

+ (void)getDataFrom:(NSString *)table
               rows:(NSInteger)numberofrows
          withLimit:(NSInteger)skiprows
            orderBy:(NSString *)order
          ascending:(BOOL)ascending
         completion:(CompletionWithArrayBlock)completion
{
    PFQuery *query = [PFQuery queryWithClassName:table];
    query.skip = skiprows;
    query.limit = numberofrows;
    
    if(ascending)
        [query orderByAscending:order];
    else
        [query orderByDescending:order];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        completion(objects,error,nil);
        
    }];
}

+ (NSMutableArray *)getDataFrom:(NSString *)table
                          where:(NSString *)key
                         clause:(WhereClauseOption)clause
                          value:(id)value
{
    PFQuery *query = [PFQuery queryWithClassName:table];
    
    switch (clause) {
            
        case kEqualTo:
            
            [query whereKey:key equalTo:value];
            break;
            
        case kLessThan:
            
            [query whereKey:key lessThan:value];
            break;
            
        case kLessThanOrEqualTo:
            
            [query whereKey:key lessThanOrEqualTo:value];
            break;
            
        case kGreaterThan:
            
            [query whereKey:key greaterThan:value];
            break;
            
        case kGreaterThanOrEqualTo:
            
            [query whereKey:key greaterThanOrEqualTo:value];
            break;
            
        case kHasPrefix:
            
            [query whereKey:key hasPrefix:value];
            break;
            
        case kMathesRegEx:
            
            [query whereKey:key matchesRegex:value modifiers:@"i"];
            break;
            
        default:
            break;
    }
    
    
    NSArray *results = [query findObjects];
    
    return [results mutableCopy];
}


+ (void)getDataFrom:(NSString *)table
              where:(NSString *)key
             clause:(WhereClauseOption)clause
              value:(id)value
         completion:(CompletionWithArrayBlock)completion
{
    PFQuery *query = [PFQuery queryWithClassName:table];
    
    switch (clause) {
            
        case kEqualTo:
            
            [query whereKey:key equalTo:value];
            break;
            
        case kNotEqualTo:
            
            [query whereKey:key notEqualTo:value];
            break;
            
        case kLessThan:
            
            [query whereKey:key lessThan:value];
            break;
            
        case kLessThanOrEqualTo:
            
            [query whereKey:key lessThanOrEqualTo:value];
            break;
            
        case kGreaterThan:
            
            [query whereKey:key greaterThan:value];
            break;
            
        case kGreaterThanOrEqualTo:
            
            [query whereKey:key greaterThanOrEqualTo:value];
            break;
            
        case kHasPrefix:
            
            [query whereKey:key hasPrefix:value];
            break;
            
        case kContainedIn
            :
            
            [query whereKey:key containedIn:value];
            break;
            
        case kMathesRegEx:
            
            [query whereKey:key matchesRegex:value modifiers:@"i"];
            break;
            
        default:
            break;
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        completion(objects,error,nil);
        
    }];
}

+ (void)getDataFrom:(NSString *)table
          predicate:(NSPredicate *)predicate
         completion:(CompletionWithArrayBlock)completion
{
    PFQuery *query = [PFQuery queryWithClassName:table predicate:predicate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        completion(objects,error,nil);
        
    }];
}

+ (void)getDataFrom:(NSString *)table
              where:(NSString *)key
             clause:(WhereClauseOption)clause
              value:(id)value
            orderBy:(NSString *)order
         completion:(CompletionWithArrayBlock)completion
{
    PFQuery *query = [PFQuery queryWithClassName:table];
    [query orderByDescending:order];
    switch (clause) {
            
        case kEqualTo:
            
            [query whereKey:key equalTo:value];
            break;
            
        case kNotEqualTo:
            
            [query whereKey:key notEqualTo:value];
            break;
            
        case kLessThan:
            
            [query whereKey:key lessThan:value];
            break;
            
        case kLessThanOrEqualTo:
            
            [query whereKey:key lessThanOrEqualTo:value];
            break;
            
        case kGreaterThan:
            
            [query whereKey:key greaterThan:value];
            break;
            
        case kGreaterThanOrEqualTo:
            
            [query whereKey:key greaterThanOrEqualTo:value];
            break;
            
        case kHasPrefix:
            
            [query whereKey:key hasPrefix:value];
            break;
            
        case kContainedIn
            :
            
            [query whereKey:key containedIn:value];
            break;
            
        case kMathesRegEx:
            
            [query whereKey:key matchesRegex:value modifiers:@"i"];
            break;
            
        default:
            break;
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        completion(objects,error,nil);
        
    }];
}



+ (void)getDataFrom:(NSString *)table
        withColumns:(NSArray *)columns
              where:(NSString *)key
             clause:(WhereClauseOption)clause
              value:(id)value
         completion:(CompletionWithArrayBlock)completion
{
    PFQuery *query = [PFQuery queryWithClassName:table];
    
    [query selectKeys:columns];
    
    switch (clause) {
            
        case kEqualTo:
            
            [query whereKey:key equalTo:value];
            break;
            
        case kLessThan:
            
            [query whereKey:key lessThan:value];
            break;
            
        case kLessThanOrEqualTo:
            
            [query whereKey:key lessThanOrEqualTo:value];
            break;
            
        case kGreaterThan:
            
            [query whereKey:key greaterThan:value];
            break;
            
        case kGreaterThanOrEqualTo:
            
            [query whereKey:key greaterThanOrEqualTo:value];
            break;
            
        case kHasPrefix:
            
            [query whereKey:key hasPrefix:value];
            break;
            
        case kMathesRegEx:
            
            [query whereKey:key matchesRegex:value modifiers:@"i"];
            break;
            
        default:
            break;
    }
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        completion(objects,error,nil);
        
    }];
}

+ (void)deleteObject:(NSString *)object
           fromTable:(NSString *)table
          completion:(CompletionWithBoolBlock)completion
{
    PFObject *obj_Parse = [PFObject objectWithoutDataWithClassName:table
                                                          objectId:object];
    [obj_Parse deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        completion(succeeded,error,nil);
    }];
}

@end
