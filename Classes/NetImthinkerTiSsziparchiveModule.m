/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "NetImthinkerTiSsziparchiveModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation NetImthinkerTiSsziparchiveModule

#pragma mark Internal

-(id)moduleGUID
{
	return @"0569ee0d-ebd6-4675-b3f3-a23c852423ea";
}

-(NSString*)moduleId
{
	return @"net.imthinker.ti.ssziparchive";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// [super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
	}
}

#pragma mark SSZipArchive proxy methods

- (void)archive:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    NSString *target = args[@"target"];
    NSArray *files = args[@"files"];
    NSMutableArray *formatFiles = [[NSMutableArray alloc] init];
    BOOL overwrite = [TiUtils boolValue:args[@"overwrite"] def:NO];
    
    NSURL *targetURL = [NSURL URLWithString:target];
    target = [[targetURL path] stringByStandardizingPath];
    
    for (id filePath in files) {
        targetURL = [NSURL URLWithString:filePath];
        [formatFiles addObject:[[targetURL path] stringByStandardizingPath]];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existFile = [fileManager fileExistsAtPath:target];
    BOOL archiveResult;
    
    if (existFile) {
        if (overwrite) {
            // Over write
            NSError *error;
            BOOL result = [fileManager removeItemAtPath:target error:&error];
            if (result) {
                NSLog(@"[DEBUG] ZIP module (archive) :: File delete is success");
                archiveResult = [SSZipArchive createZipFileAtPath:target withFilesAtPaths:formatFiles];
            } else {
                NSLog(@"[ERROR] ZIP module (archive) :: File delete is failure (%@)", error.description);
                archiveResult = NO;
            }
        } else {
            NSLog(@"[ERROR] ZIP module (archive) :: File is already exist");
            archiveResult = NO;
        }
    } else {
        // New
        archiveResult = [SSZipArchive createZipFileAtPath:target withFilesAtPaths:formatFiles];
    }
    
    if ([self _hasListeners:@"archive"]) {
        [self fireEvent:@"archive" withObject:@{@"success": NUMBOOL(archiveResult),
                                                @"filename": [[target componentsSeparatedByString:@"/"] lastObject]}];
    }
}

- (void)extract:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    NSString *target = args[@"target"];
    NSString *destination = args[@"destination"];
    NSString *password;
    ENSURE_ARG_OR_NIL_FOR_KEY(password, args, @"password", NSString);
    BOOL overwrite = [TiUtils boolValue:args[@"overwrite"] def:NO];
    
    NSURL *targetURL = [NSURL URLWithString:target];
    NSURL *destinationURL = [NSURL URLWithString:destination];
    target = [[targetURL path] stringByStandardizingPath];
    destination = [[destinationURL path] stringByStandardizingPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existFile = [fileManager fileExistsAtPath:target];
    BOOL extractResult = NO;
    
    NSError *error;
    if (existFile) {
        extractResult = [SSZipArchive unzipFileAtPath:target
                                        toDestination:destination
                                            overwrite:overwrite
                                             password:password
                                                error:&error
                                             delegate:self];
    } else {
        NSLog(@"[ERROR] ZIP module (extract) :: File is not exist");
    }
    
    if ([self _hasListeners:@"extract"]) {
        NSString *errorMessage;
        if (error) {
            errorMessage = [error description];
        } else {
            errorMessage = @"";
        }
        [self fireEvent:@"extract" withObject:@{@"success": NUMBOOL(extractResult),
                                                @"error": errorMessage,
                                                @"filename": args[@"target"]}];
    }
}

#pragma mark SSZipArchive delegate methods

- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
	// NSLog(@"*** zipArchiveWillUnzipArchiveAtPath: `%@` zipInfo:", path);
}


- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
	// NSLog(@"*** zipArchiveDidUnzipArchiveAtPath: `%@` zipInfo: unzippedPath: `%@`", path, unzippedPath);
}


- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo {
	// NSLog(@"*** zipArchiveWillUnzipFileAtIndex: `%ld` totalFiles: `%ld` archivePath: `%@` fileInfo:", fileIndex, totalFiles, archivePath);
}


- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo {
	// NSLog(@"*** zipArchiveDidUnzipFileAtIndex: `%ld` totalFiles: `%ld` archivePath: `%@` fileInfo:", fileIndex, totalFiles, archivePath);
}
@end
