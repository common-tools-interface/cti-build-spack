/*********************************************************************************\
 * cti_callback_test.h - Header file for the cti_callback_test.
 *
 * Copyright 2011-2020 Hewlett Packard Enterprise Development LP.
 * SPDX-License-Identifier: Linux-OpenIB
 ******************************************************************************/

#ifndef _CTI_CALLBACK_TEST_H
#define _CTI_CALLBACK_TEST_H

/* internal defines */
// Port declarations are arbitrary for now. This might cause problems in the future.
#define CALLBACK_PORT "13337"
#define BACKLOG 8192
#define BUFSIZE 32768

#define LAUNCHER  "./cti_callback_daemon"

/* struct typedefs */
typedef struct
{
    char *              cname;          // service node hostname
    pthread_t           listener;       // listener thread
    pthread_attr_t      attr;           // thread attributes
    pthread_mutexattr_t lock_attr;      // mutex lock attr
    pthread_mutex_t     lock;           // mutex lock for threads
    pthread_condattr_t  cond_attr;      // condition variable attr
    pthread_cond_t      cond;           // condition variable
} FrontEndNode_t;

typedef struct
{
    char *              node_cname;     // compute node hostname
} BackEndNode_t;

typedef struct
{
    int                 listenfd;       // fd for listener socket
    struct addrinfo     hints;          // hints object for call to getaddrinfo
    struct addrinfo     *listener;      // listener addrinfo object
    pthread_attr_t      attr;           // handler thread attributes
} listenThreadArgs_t;

typedef struct
{
    pthread_t           handlerTid;     // tid for the thread
    int                 cnodefd;        // fd for connected compute node
    struct sockaddr_in  cnode;          // sockaddr_in for the cnode socket
    socklen_t           len;            // length of the sockaddr_in object
} handlerThreadArgs_t;

/* function prototypes */
void *  callback_handler(void *);
void    handler_destroy(void *);
void *  callback_listener(void *);
int     callback_create(void);
void    callback_destroy(void *);

#endif /* _CTI_CALLBACK_TEST_H */
