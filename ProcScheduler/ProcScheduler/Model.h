//
//  Model.h
//  ProcScheduler
//
//  Created by Ankush Jain on 29/03/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef void (^CompletionWithBoolBlock) (BOOL responseBool, NSError *responseError, NSString *object);
typedef void (^CompletionWithArrayBlock) (NSArray *responseArray, NSError *responseError, NSString *object);
typedef void (^CompletionWithObjectBlock) (PFObject *responseObject, NSError *responseError);

//Where Clause Options
typedef enum
{
    kEqualTo,
    kNotEqualTo,
    kLessThan,
    kLessThanOrEqualTo,
    kGreaterThan,
    kGreaterThanOrEqualTo,
    kHasPrefix,
    kContainedIn,
    kMathesRegEx,
    
} WhereClauseOption;

@protocol ModelDelegate <NSObject>

- (void)completeSerciveCall;

@end


@interface Model : NSObject
+ (Model *)getInstance;

+ (PFUser *)getCurrentUser;

+ (PFFile *)createPFFileFromData:(NSData *)data withName:(NSString *)name;


+ (void)getParseObjectWithId:(NSString *)object
                     inTable:(NSString *)table
                  completion:(CompletionWithObjectBlock)completion;


+ (int)getRowCountFromTable:(NSString *)table;

+ (PFObject *)createParseObjectOfTable:(NSString *)table;

+ (void)insertObjectWithTable:(NSString *)table
                       values:(NSDictionary *)values
                   completion:(CompletionWithBoolBlock)completion;

+ (void)updateObject:(NSString *)object
             inTable:(NSString *)table
              values:(NSDictionary *)values
          completion:(CompletionWithBoolBlock)completion;

+ (void)updateAllObjects:(NSArray *)objectArray
                 inTable:(NSString *)table
              completion:(CompletionWithBoolBlock)completion;



+ (void)getDataFrom:(NSString *)table
               rows:(NSInteger)numberofrows
          withLimit:(NSInteger)skiprows
            orderBy:(NSString *)order
         completion:(CompletionWithArrayBlock)completion;


+ (void)getDataFrom:(NSString *)table
               rows:(NSInteger)numberofrows
          withLimit:(NSInteger)skiprows
            orderBy:(NSString *)order
          ascending:(BOOL)ascending
         completion:(CompletionWithArrayBlock)completion;


+ (void)getDataFrom:(NSString *)table
            orderBy:(NSString *)order
         completion:(CompletionWithArrayBlock)completion;

+ (void)getDataFrom:(NSString *)table
              where:(NSString *)key
             clause:(WhereClauseOption)clause
              value:(id)value
         completion:(CompletionWithArrayBlock)completion;


+ (void)getDataFrom:(NSString *)table
        withColumns:(NSArray *)columns
              where:(NSString *)key
             clause:(WhereClauseOption)clause
              value:(id)value
         completion:(CompletionWithArrayBlock)completion;


+ (void)getDataFrom:(NSString *)table
              where:(NSString *)key
             clause:(WhereClauseOption)clause
              value:(id)value
            orderBy:(NSString *)order
         completion:(CompletionWithArrayBlock)completion;


+ (void)getDataFrom:(NSString *)table
          predicate:(NSPredicate *)predicate
         completion:(CompletionWithArrayBlock)completion;


+ (void)deleteObject:(NSString *)object
           fromTable:(NSString *)table
          completion:(CompletionWithBoolBlock)completion;
@end
