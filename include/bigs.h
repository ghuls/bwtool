#ifndef BIGS_H
#define BIGS_H

#ifndef HASH_H
#include "hash.h"
#endif

#ifndef FAVS_H
#include "favs.h"
#endif

#ifndef METABIG_H
#include "metaBig.h"
#endif

struct perBaseWig
{
    struct perBaseWig *next;    /* next in list */
    char *chrom;               /* just like a bed */
    int chromStart;            /* just like a bed */
    int chromEnd;              /* just like a bed */
    char *name;
    int score;
    char strand[2];
    int label;                 /* for clustering */
    int len;                   /* same as chromEnd - chromStart */
    double *data;              /* array of per-base data extracted */
    unsigned total_coverage;   /* total number of bases in subsections */
    struct bed *subsections;   /* list of subsections to use with 0-based coords i.e. */
                               /* actual coordinate is chromStart + subsection->chromStart */
    struct bed6 *orig_bed;     
};

struct perBaseMatrix
/* used in bwtool matrix and aggregate */
{
    struct perBaseMatrix *next;  
    int nrow;
    int ncol; 
    struct perBaseWig **array;
    double **matrix;         /* 2D array to simplify access into the array->data arrays  */
                             /* it's very important to reinitialize this to if pbm->array */
                             /* is sorted */
};

struct starts
/* used in phasogram and distogram */
{
    struct starts *next;

    unsigned num_pos_starts;
    unsigned num_neg_starts;
    int *pos_starts;
    int *pos_counts;
    int *neg_starts;
    int *neg_counts;
};

struct middles
/* strand-ignorant version of starts struct used in stackreads */
{
    struct middles *next;
    unsigned num_mids;
    int *mids;
    int *counts;
    int *ave_sizes;
};

enum wigOutType
{
    invalidOut = 0,
    bedGraphOut = 1,
    varStepOut = 2,
    fixStepOut = 3,
};

enum wigOutType get_wig_out_type(char *option);
/* scan the option and return it */

int perBaseWigLabelCmp(const void *a, const void *b);
/* for sorting after clustering */

struct perBaseWig *alloc_perBaseWig(char *chrom, int start, int end);
/* simply allocate the perBaseWig. not a super necessary function. */

struct perBaseWig *perBaseWigClone(struct perBaseWig *pbw);
/* Clone the structure exactly */

void perBaseWigFree(struct perBaseWig **pRegion);
/* Free-up a perBaseWig */

void perBaseWigFreeList(struct perBaseWig **pList);
/* Free up a list of perBaseWigs */

struct perBaseWig *perBaseWigLoadContinue(struct bbiFile *bbi, char *chrom, int start, int end);
/* load a perBaseWig from a wig/bigWig that's already open */

struct perBaseWig *perBaseWigLoad(char *wigFile, char *chrom, int start, int end);
/* Load all the regions from a wig or bigWig into a list of arrays basically. */


struct perBaseWig *perBaseWigLoadSingleContinue(struct metaBig *mb, char *chrom, 
						int start, int end, boolean reverse);
/* Load all the regions into one perBaseWig, but with gaps filled  */
/* in with NA value */

struct perBaseWig *perBaseWigLoadSingle(char *wigFile, char *chrom, int start, int end, boolean reverse);
/* Load all the regions into one perBaseWig, but with gaps filled  */
/* in with NA value */

struct perBaseMatrix *load_perBaseMatrix(struct metaBig *mb, struct bed6 *regions);
/* loading a wig matrix from a metaBig with regions all the same size.  It should be noted */
/* that the regions may include negative and out-of-bounds coordinates.  Out-of-bounds data is */
/* NA in the matrix. */ 

void perBaseMatrixAddOrigRegions(struct perBaseMatrix *pbm, struct bed6 *orig_regions);
/* add the original bed information for retrieval later.  it's really important */
/* that this is in the same order as the pbws in the array  */

void free_perBaseMatrix(struct perBaseMatrix **ppMat);
/* freeing up a wig matrix */

void perBaseWigOutput(struct perBaseWig *pbwList, FILE *output, enum wigOutType wot, 
		      int decimals, char *track_line, boolean nohead, boolean condense);
/* Output wiggle. */ 

void perBaseWigOutputNASkip(struct perBaseWig *pbwList, FILE *output, enum wigOutType wot, 
			    int decimals, char *track_line, boolean nohead, boolean condense);
/* Output wiggle skipping NA regions (recommended). */ 

struct starts *metaBig_get_starts(struct metaBig *mb, char *chrom, unsigned start, unsigned end);
/* return starts struct used with the phasogram/distogram programs */

struct middles *beds_to_middles(struct bed6 *bedList);
/* minimal information for stacking middles */

struct middles *metaBig_get_middles(struct metaBig *mb, char *chrom, unsigned start, unsigned end);
/* return middles struct used with stackreads program */

struct metaBig *metaBigOpen_favs(char *filename, char *sectionsBed, char *favs_file);
/* open the file based on favorites.txt */

struct bbiFile *bigWigFileOpen_favs(char *filename, char *favs_file);
/* open the file based on favorites.txt */

void startsFreeList(struct starts **pList);
/* free a list of starts */

void middlesFreeList(struct middles **pList);
/* free a list of middles */

#endif
