

#import <Foundation/Foundation.h>
//#import <QSCore/QSObject.h>


NSString *formattedContactName(NSString *firstName,NSString *lastName,NSString *middleName,NSString *suffix,NSString *prefix);
@interface QSContactObjectHandler : NSObject

- (BOOL)loadChildrenForObject:(QSObject *)object;
@end

@interface QSObject (ContactHandling)
+ (id)objectWithPerson:(ABPerson *)person;
+ (id)objectWithString:(NSString *)string name:(NSString *)aName type:(NSString *)aType;
- (id)initWithString:(NSString *)string name:(NSString *)aName type:(NSString *)aType;
    //--NSString *formalName(NSString *title,NSString *firstName,NSString *middleName,NSString *lastName,NSString *suffix);
    //NSMutableString *formalName=
- (NSString *)nameForRecord:(ABRecord *)record;
- (id)initWithPerson:(ABPerson *)person;
- (void)loadContactInfo;
- (BOOL)useDefaultIMFromPerson:(ABPerson *)person;
- (BOOL)useDefaultEmailFromPerson:(ABPerson *)person;
@end