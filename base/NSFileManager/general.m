#include "Testing.h"
#include "ObjectTesting.h"
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSFileManager.h>
#include <Foundation/NSProcessInfo.h>
#include <Foundation/NSPathUtilities.h>

int main()
{
  CREATE_AUTORELEASE_POOL(arp);
  NSFileManager *mgr = [NSFileManager defaultManager];
  NSString *dir = @"NSFileManagerTestDir"; 
  NSString *str1,*str2;
  pass(mgr != nil && [mgr isKindOfClass: [NSFileManager class]],
       "NSFileManager understands +defaultManager");

/* remove test directory if it exists */
  {
    BOOL exists,isDir;
    exists = [mgr fileExistsAtPath: dir isDirectory: &isDir];
    if (exists)
      {
        [mgr removeFileAtPath: dir handler: nil];
      }
  }
  pass([mgr fileAttributesAtPath: dir traverseLink: NO] == nil,
    "NSFileManager returns nil for attributes of non-existent file");


  {
    NSDictionary *attr;
    BOOL isDir;
    pass([mgr createDirectoryAtPath: dir attributes: nil],
         "NSFileManager can create a directory");
    pass([mgr fileExistsAtPath: dir isDirectory: &isDir] &&
         isDir == YES,
	 "exists and is a directory");
    pass([mgr fileAttributesAtPath: dir traverseLink: NO] != nil,
      "NSFileManager returns non-nil for attributes of existing file");
    attr = [mgr fileAttributesAtPath: dir traverseLink: NO];
    pass(attr != nil,
      "NSFileManager returns non-nil for attributes of existing file");
    pass([NSUserName() isEqual: [attr fileOwnerAccountName]],
      "newly created file is owned by current user");
  }
  
  pass([mgr changeCurrentDirectoryPath: dir],
       "NSFileManager can change directories");
  
  
  {
    NSString *dir1 = [mgr currentDirectoryPath];
    pass(dir1 != nil && [[dir1 lastPathComponent] isEqualToString: dir],
         "NSFileManager can get current dir");
  }
  
  str1 = @"A string";
  pass([mgr createFileAtPath: @"NSFMFile" 
                    contents: [str1 dataUsingEncoding: 1]
		  attributes: nil],
       "NSFileManager creates a file");
  pass([mgr fileExistsAtPath: @"NSFMFile"],"-fileExistsAtPath: agrees");
  
  {
    NSData *dat1 = [mgr contentsAtPath: @"NSFMFile"];
    str2 = [[NSString alloc] initWithData: dat1 encoding: 1];
    pass([str1 isEqualToString: str2], "NSFileManager file contents match");
  }
  
  pass([mgr copyPath: @"NSFMFile"
              toPath: @"NSFMCopy"
	     handler: nil], 
       "NSFileManager copies a file");
  pass([mgr fileExistsAtPath: @"NSFMCopy"],"-fileExistsAtPath: agrees");
  {
    NSData *dat1 = [mgr contentsAtPath: @"NSFMCopy"];
    str2 = [[NSString alloc] initWithData: dat1 encoding: 1];
    pass([str1 isEqual: str2],"NSFileManager copied file contents match");
  }
  
  pass([mgr movePath: @"NSFMFile"
              toPath: @"NSFMMove"
	     handler: nil],
       "NSFileManager moves a file");
  pass([mgr fileExistsAtPath: @"NSFMMove"], 
       "NSFileManager move destination exists");
  pass(![mgr fileExistsAtPath: @"NSFMFile"], 
       "NSFileManager move source doesn't exist"); 
  {
    NSData *dat1 = [mgr contentsAtPath: @"NSFMMove"];
    str2 = [[NSString alloc] initWithData: dat1 encoding: 1];
    pass([str1 isEqualToString: str2],"NSFileManager moved file contents match");
  }

  if ([[NSProcessInfo processInfo] operatingSystem]
    != NSWindowsNTOperatingSystem)
    {
      pass([mgr createSymbolicLinkAtPath: @"NSFMLink" pathContent: @"NSFMMove"],
       "NSFileManager creates a symbolic link");
  
      pass([mgr fileExistsAtPath: @"NSFMLink"], "link exists");
  
      pass([mgr removeFileAtPath: @"NSFMLink" handler: nil], 
       "NSFileManager removes a symbolic link");
  
      pass(![mgr fileExistsAtPath: @"NSFMLink"],
       "NSFileManager removed link doesn't exist");
  
      pass([mgr fileExistsAtPath: @"NSFMMove"],
       "NSFileManager removed link's target still exists");
    }
  
  pass([mgr removeFileAtPath: @"NSFMMove" handler: nil], 
       "NSFileManager removes a file"); 
 
  pass(![mgr fileExistsAtPath: @"NSFMMove"],
       "NSFileManager removed file doesn't exist");
  
  pass([mgr isReadableFileAtPath: @"NSFMCopy"], 
       "NSFileManager isReadableFileAtPath: works");
  pass([mgr isWritableFileAtPath: @"NSFMCopy"],
       "NSFileManager isWritableFileAtPath: works");
  pass([mgr isDeletableFileAtPath: @"NSFMCopy"],
       "NSFileManager isDeletableFileAtPath: works");
  pass(![mgr isExecutableFileAtPath: @"NSFMCopy"],
       "NSFileManager isExecutableFileAtPath: works");
  
  TEST_EXCEPTION([mgr removeFileAtPath: @"." handler: nil];, 
                 NSInvalidArgumentException, YES,
		 "NSFileManager -removeFileAtPath: @\".\" throws exception");

  pass([mgr createDirectoryAtPath: @"subdir" attributes: nil],
       "NSFileManager can create a subdirectory");
  
  pass([mgr changeCurrentDirectoryPath: @"subdir"], 
       "NSFileManager can move into subdir");
  
  TEST_EXCEPTION([mgr removeFileAtPath: @"." handler: nil];, 
                 NSInvalidArgumentException, YES,
		 "NSFileManager -removeFileAtPath: @\".\" throws exception");
       
  TEST_EXCEPTION([mgr removeFileAtPath: @".." handler: nil];, 
                 NSInvalidArgumentException, YES,
		 "NSFileManager -removeFileAtPath: @\"..\" throws exception");
/* clean up */ 
  {
    BOOL exists,isDir;
    [mgr changeCurrentDirectoryPath: [[[mgr currentDirectoryPath] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]];
    exists = [mgr fileExistsAtPath: dir isDirectory: &isDir];
    if (exists || isDir)
      {
        pass([mgr removeFileAtPath: dir handler: nil],
	     "NSFileManager removes a directory");
        pass(![mgr fileExistsAtPath: dir],"directory no longer exists");
      }
    
    isDir = NO;
  }
  
  DESTROY(arp);
  return 0;
}
