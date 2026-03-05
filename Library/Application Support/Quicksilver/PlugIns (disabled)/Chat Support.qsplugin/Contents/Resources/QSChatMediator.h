/*
 * Brian's first change
 */

#import <Foundation/Foundation.h>

typedef enum _QSChatType {	
	QSChatInitType		= 1, // Plain chat initiaton
	QSChatTextType		= 2, // Send text
	QSChatFileType		= 3, // Send file
	QSChatAudioType		= 4, // Start audio chat
	QSChatVideoType		= 5, // Start video chat
	QSChatRoomType      = 6, // Invite to chat room
} QSChatType;

/* Associated info for each type is:
QSChatInitType:   nil
QSChatTextType:   message to be sent
QSChatFileType:   array of file paths
QSChatAudioType:	any relevant argument (nil)
QSChatVideoType:	any relevant argument (nil)
QSChatRoomType:   name of the room (@"AIM.qsdevmeeting")
*/

enum {
	QSChatInitMask		= 1 << QSChatInitType,
	QSChatTextMask		= 1 << QSChatTextType,
	QSChatFileMask		= 1 << QSChatFileType,
	QSChatAudioMask 	= 1 << QSChatAudioType,
	QSChatVideoMask		= 1 << QSChatVideoType,
	QSChatRoomMask    	= 1 << QSChatRoomType,
	QSChatAnyMask		= 0xffffffffU
};

// this will work for groups and meta contacts
#define QSIMMultiAccountType @"qs.im.multi" 

NSString *preferredChatMediatorID();
#define kQSChatMediators @"QSChatMediators"

@protocol QSChatMediator
// Returns a mask

+ (int)			supportedChatTypes;
+ (NSArray *)	supportedAccountTypes;

- (int)capabilitiesOfAccount:(NSString *)accountID; 

- (BOOL)initiateChat:(QSChatType)serviceType withAccounts:(NSArray *)accountIDs info:(id)info;

	// Status and Icon
	// gets a flat list of available accounts as QSObjects for populating the third field of an indirect action
	// this is not neccesarily the same as the children of the chat app (e.g. iChat.app)
- (NSArray *) availableAccounts;
	// format of accountID: @"%@.%@" or @"%@:%@" ? (with serviceID, userID)
	// example "AIM.eventualbuddha". I'm in favor of @"%@.%@"
- (BOOL)accountIsAvailable:(NSString *)accountID;
- (NSString *) statusForAccount:(NSString *)accountID;
	//- (NSImage *) imageForAccount;
@end
