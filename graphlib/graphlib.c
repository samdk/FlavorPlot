/*
 * =====================================================================================
 *
 *       Filename:  graphlib.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  02/12/2011 03:55:05
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Prasanna Gautam (mn), prasanna.gautam@trincoll.edu
 *        Company:  Trinity College
 *
 * =====================================================================================
 */


#include	<stdio.h>
#include	<stdlib.h>
#include	<search.h>

void test(char** data,int size){
  int i;
  for (i = 0; i < size; i++){
       
    //printf("%s\n",t[i]);
  }
}


  int
main ( int argc, char *argv[] )
{
  char *data[] = {"alpha", "bravo"};
  
  hcreate(40000);
  FILE *fp;
  fp = fopen("../round1.csv", "r");
  
  if (fp != NULL){
    char line[1024];
    while (fgets (line, sizeof(line),fp) != NULL){
      
    }
  }
  //test(data,2);
  return 0;
}				/* ----------  end of function main  ---------- */
