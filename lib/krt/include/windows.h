#ifndef _WINDOWS_H
#define _WINDOWS_H
//Dummy windows.h

typedef struct CRITICAL_SECTIONtag{
}CRITICAL_SECTION;


void InitializeCriticalSection(CRITICAL_SECTION *csec);
void DeleteCriticalSection(CRITICAL_SECTION *csec);
void EnterCriticalSection(CRITICAL_SECTION *csec);
void LeaveCriticalSection(CRITICAL_SECTION *csec);

#endif
