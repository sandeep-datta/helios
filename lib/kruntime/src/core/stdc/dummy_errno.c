//Dummy errno declaration
//Added by Sandeep Datta

#include "errno.h"

static int _errno = 0;

int * __errno(void)
{
    return &_errno;
}
