//
//  DbController.m
//  iWish
//
//  Created by Suman Chatterjee on 21/04/2013.
//  Copyright (c) 2013 Suman Chatterjee. All rights reserved.
//

#import "DbController.h"
#import <sqlite3.h>


//It is assume initially there is only One Database

static NSString * DataBaseName = @"iWishDB.db";

const NSInteger   TABLE_NOT_CREATED       = 101;
const NSInteger   FAILED_TO_OPEN_TABLE    = 102;
const NSInteger   FAILED_TO_INSERT_ROW    = 103;
const NSInteger   TABLE_NOT_DROP          = 104;
const NSInteger   FAILED_TO_GET_DATA      = 105;
const NSInteger   FAILED_TO_DELETE_ROW    = 106;

//private implementation
@interface DbController()
{
    NSString* databasePath;
    sqlite3 *contactDB;
}

- (void) checkAndCreateDatabase:(NSString *) dbName;

@property (copy) CompletionBlock completionblock;
@property (copy) ResultBlock     resultblock;

@end

@implementation DbController

//static method to implement the class singleton object
+ (DbController*) shared
{
	static DbController* shared = nil;
	
    // singleton allocate
    if (shared == nil){
        shared = [[DbController alloc] init];
        [shared checkAndCreateDatabase:DataBaseName];
    }
    
	return shared;
}


//Function to creat the database if it is not exists 
- (void) checkAndCreateDatabase:(NSString *) dbName
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: dbName]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            sqlite3_close(contactDB);
            
        } else {
            
           NSLog(@"Failed to open/create database") ;
        }
    }
    
}

//Function to create the Table if it is not exists
- (void) CreateTableIfNotExists:(NSString *) tableName withColumn:(NSArray*) column withPrimaryKey:(NSString*) primaryKey withCompletionBlock:(CompletionBlock) completion
{
    
    const char *dbpath = [databasePath UTF8String];
    self.completionblock = completion;
    NSError * error = nil;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
         NSString * sqlCreate = [ NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( ", tableName];
        for(NSDictionary *col in column)
        {
            NSString * colName = [col objectForKey:@"columnname"];
            NSString * colType = [col objectForKey:@"Type"];
            sqlCreate = [NSString stringWithFormat:@"%@ %@ %@,", sqlCreate,colName,colType];
        }
        
        
        //remove the last ","
        sqlCreate = [sqlCreate substringToIndex:[sqlCreate length] - 1];
        
        if (primaryKey.length != 0)
            sqlCreate = [NSString stringWithFormat:@"%@ , primary key ( %@ )", sqlCreate,primaryKey];
        
        sqlCreate = [NSString stringWithFormat:@"%@ )", sqlCreate];
        
        
        char *errMsg;
        const char *sql_stmt = [sqlCreate cStringUsingEncoding:NSASCIIStringEncoding];
        if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
                error = [NSError errorWithDomain:@"Table Not Created" code:TABLE_NOT_CREATED userInfo:nil];
        }
        
        sqlite3_close(contactDB);
        
    }
    else
    {
            error = [NSError errorWithDomain:@"Failed to open/create database" code:FAILED_TO_OPEN_TABLE userInfo:nil];
    }
    //if table creation successful sen the completion block to the client;
    if(self.completionblock)
        self.completionblock(error);
}

// Function to insert rows in the table
- (void) insertIntoTable:(NSString*) Table withColumn:(NSArray*) column withCompletionBlock:(CompletionBlock) completion
{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSError *error = nil;
    self.completionblock = completion;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO %@ (",Table];
        //add the column name
        for(NSDictionary *col in column)
        {
            NSString * colName = [col objectForKey:@"columnname"];
            insertSQL = [NSString stringWithFormat:@"%@ %@,", insertSQL,colName];
        }
        insertSQL = [insertSQL substringToIndex:[insertSQL length] - 1];
        insertSQL = [NSString stringWithFormat:@"%@ ) VALUES ( ", insertSQL];
        
        //add values
        for(NSDictionary *col in column)
        {
            NSString * Value = [col objectForKey:@"Value"];
            insertSQL = [NSString stringWithFormat:@"%@ \"%@\",", insertSQL,Value];
        }
        
        insertSQL = [insertSQL substringToIndex:[insertSQL length] - 1];
        insertSQL = [NSString stringWithFormat:@"%@ )", insertSQL];

        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            error = [NSError errorWithDomain:@"Failed to add data in the table" code:FAILED_TO_INSERT_ROW userInfo:nil];

        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    else
    {
        error = [NSError errorWithDomain:@"Failed to open/create database" code:FAILED_TO_OPEN_TABLE userInfo:nil];
    }

    //if table creation successful sen the completion block to the client;
    if(self.completionblock)
        self.completionblock(error);
    
}

// Function to delete rows in the table
- (void) deleteFromTable:(NSString*) Table withWhareClause:(NSString*) clause withCompletionBlock:(CompletionBlock) completion
{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    NSError *error = nil;
    self.completionblock = completion;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        
        NSString *deleteSQL = [NSString stringWithFormat: @"DELETE FROM %@",Table];
        
        if (clause != nil)
         deleteSQL = [NSString stringWithFormat:@"%@  WHERE %@",deleteSQL,clause];

        const char *insert_stmt = [deleteSQL UTF8String];
        
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            error = [NSError errorWithDomain:@"Failed to delete rows in table" code:FAILED_TO_DELETE_ROW userInfo:nil];
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    else
    {
        error = [NSError errorWithDomain:@"Failed to open/create database" code:FAILED_TO_OPEN_TABLE userInfo:nil];
    }
    
    //if table creation successful sen the completion block to the client;
    if(self.completionblock)
        self.completionblock(error);
    
    
}


// Drop the existing table
- (void) dropTable:(NSString*) Table withCompletionBlock:(CompletionBlock) completion
{
    const char *dbpath = [databasePath UTF8String];
    self.completionblock = completion;
    NSError * error = nil;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString * sqlCreate = [ NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", Table];
        char *errMsg;
        const char *sql_stmt = [sqlCreate cStringUsingEncoding:NSASCIIStringEncoding];
        if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            error = [NSError errorWithDomain:@"Table Not Droped" code:TABLE_NOT_DROP userInfo:nil];
        }
        
        sqlite3_close(contactDB);
     }
    else
    {
        error = [NSError errorWithDomain:@"Failed to open/create database" code:FAILED_TO_OPEN_TABLE userInfo:nil];
    }
    //if table creation successful sen the completion block to the client;
    if(self.completionblock)
        self.completionblock(error);

}


// Select query - Full select which returns a NSARRY
- (void) selectDataFromTable:(NSString*) Table withColumn:(NSArray*) column withWhareClause:(NSString*) clause withCompletionBlock:(CompletionBlock) completion andResultBlock:(ResultBlock) result
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    NSMutableArray  *Result = [[NSMutableArray alloc] init];
    NSError * error = nil;
    self.completionblock = completion;
    self.resultblock = result;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL =   [NSString stringWithFormat: @"SELECT "];
        
        for(NSString * coulmname in column )
        {
            querySQL =   [NSString stringWithFormat: @"%@ %@,",querySQL,coulmname];
        }
        
        //remove the last ","
        querySQL = [querySQL substringToIndex:[querySQL length] - 1];
        
        // Add table name 
        querySQL =   [NSString stringWithFormat:@"%@ FROM %@", querySQL,Table];

   //     NSString *querySQL =   [NSString stringWithFormat: @"SELECT address, phone FROM contacts WHERE name=\"%@\"", self.name.text];
        
        if (clause.length > 0 )
            querySQL =   [NSString stringWithFormat:@"%@ where %@", querySQL,clause];
        
        const char *query_stmt = [querySQL UTF8String];
        NSString* resultString=@"";
        int count = 0;
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                for (int i = 0 ; i< column.count ; i++)
                {
                    NSString *col;
                   if (((const char *) sqlite3_column_text(statement, i) == NULL))
                       col = @"null";
                    else
                     col = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)];
                    resultString = [NSString stringWithFormat:@"%@%@,",resultString,col];
                }
                count ++;
                //remove the last ","
                resultString = [resultString substringToIndex:[resultString length] - 1];
                [Result addObject:resultString];
                resultString=@"";

              }
            }
        
       if (count == 0)
            error = [NSError errorWithDomain:@"No Match Fount" code:FAILED_TO_GET_DATA userInfo:nil];
        
            
            sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    
    if(self.completionblock)
        self.completionblock(error);
    if(self.resultblock)
        self.resultblock(Result);

}
@end
