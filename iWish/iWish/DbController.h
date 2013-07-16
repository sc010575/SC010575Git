//
//  DbController.h
//  iWish
//
//  Created by Suman Chatterjee on 21/04/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock) (NSError* error);
typedef void (^ResultBlock) (NSArray* result);

@interface DbController : NSObject


+ (DbController*) shared;


//Function to create the Table if it is not exists
- (void) CreateTableIfNotExists:(NSString *) tableName withColumn:(NSArray*) column withPrimaryKey:(NSString*) primaryKey withCompletionBlock:(CompletionBlock) completion;

// Function to insert Data in the table
- (void) insertIntoTable:(NSString*) Table withColumn:(NSArray*) column withCompletionBlock:(CompletionBlock) completion;

// Drop the existing table
- (void) dropTable:(NSString*) Table withCompletionBlock:(CompletionBlock) completion;

// Select query - Full select which returns a NSARRY
- (void) selectDataFromTable:(NSString*) Table withColumn:(NSArray*) column withWhareClause:(NSString*) clause withCompletionBlock:(CompletionBlock) completion andResultBlock:(ResultBlock) result;

// Function to delete rows in the table
- (void) deleteFromTable:(NSString*) Table withWhareClause:(NSString*) clause withCompletionBlock:(CompletionBlock) completion;
;


@end
