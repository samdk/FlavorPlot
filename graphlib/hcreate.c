/*
 * =====================================================================================
 *
 *       Filename:  hcreate.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  02/12/2011 03:16:31
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Prasanna Gautam (mn), prasanna.gautam@trincoll.edu
 *        Company:  Trinity College
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <search.h>

char *data[] = { "alpha", "bravo", "charlie", "delta",
  "echo", "foxtrot", "golf", "hotel", "india", "juliet",
  "kilo", "lima", "mike", "november", "oscar", "papa",
  "quebec", "romeo", "sierra", "tango", "uniform",
  "victor", "whisky", "x-ray", "yankee", "zulu"
};
int main() {
  ENTRY e, *ep;
  int i;

  /* starting with small table, and letting it grow does not work */
  hcreate(30);
  for (i = 0; i < 24; i++) {
    e.key = data[i];
    /* data is just an integer, instead of a
     *          pointer to something */
    e.data = (void *)i;
    ep = hsearch(e, ENTER);
    /* there should be no failures */
    if (ep == NULL) {
      fprintf(stderr, "entry failed\n");
      exit(1);
    }
  }
  for (i = 22; i < 26; i++) {
    /* print two entries from the table, and
     *          show that two are not in the table */
    e.key = data[i];
    ep = hsearch(e, FIND);
    printf("%9.9s -> %9.9s:%d\n", e.key,
           ep ? ep->key : "NULL",
           ep ? (int)(ep->data) : 0);
  }
  return 0;
}

