/******************************************************************************\
 * cti_wlm_test.c - An example program which takes advantage of the common
 *          tools interface which will gather information from the WLM about a
 *          previously launched job.
 *
 * Copyright 2012-2023 Hewlett Packard Enterprise Development LP.
 * SPDX-License-Identifier: Linux-OpenIB
 ******************************************************************************/

#include <errno.h>
#include <getopt.h>
#include <inttypes.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>

#include "common_tools_fe.h"

void
usage(char *name)
{
    fprintf(stdout, "USAGE: %s\n", name);
    fprintf(stdout, "Print out the workload manager cti_wlm_type_t for this system\n");
    fprintf(stdout, "using the common tools interface.\n\n");
    return;
}

int
main(int argc, char **argv)
{
    if (argc != 1) {
        usage(argv[0]);
        exit(1);
    }
    // values returned by the tool_frontend library.
    cti_wlm_type_t      mywlm;
    /*
     * cti_current_wlm - Obtain the current workload manager (WLM) in use on the
     *                   system.
     */
    mywlm = cti_current_wlm();

    fprintf(stdout, "CTI library was successfully initalized\n");

    // Print out the wlm type using the defined text for each WLM type.
    switch (mywlm) {
        case CTI_WLM_SLURM:
            fprintf(stdout, "%s WLM type.\n", CTI_WLM_TYPE_SLURM_STR);
            break;
        case CTI_WLM_ALPS:
            fprintf(stdout, "%s WLM type.\n", CTI_WLM_TYPE_ALPS_STR);
            break;
        case CTI_WLM_SSH:
            fprintf(stdout, "%s WLM type.\n", CTI_WLM_TYPE_SSH_STR);
            break;
        case CTI_WLM_PALS:
            fprintf(stdout, "%s WLM type.\n", CTI_WLM_TYPE_PALS_STR);
            break;
        case CTI_WLM_FLUX:
            fprintf(stdout, "%s WLM type.\n", CTI_WLM_TYPE_FLUX_STR);
            break;
        case CTI_WLM_MOCK:
            fprintf(stdout, "Mock WLM type.\n");
            break;

        case CTI_WLM_NONE:
            fprintf(stdout, "No supported workload manager detected\n");
            if (cti_error_str() != NULL) {
                fprintf(stdout, "%s\n", cti_error_str());
            }
            break;
    }

    return 0;
}
