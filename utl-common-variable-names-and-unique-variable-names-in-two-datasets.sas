%let pgm=utl-common-variable-names-and-unique-variable-names-in-two-datasets;

%stop_submission;

Common variable names and unique variable names in two datasets

SOAPBOX ON
   Proc compare cannot direcly list common variable names
   The utl_pop fcmp function pops words off a list and returns the shortened list
SOAPBOX OFF

CONTENTS

   1 sas proc sql
   2 r sql sqlite sqldf (should work in a large number od sql dialects supported by many langusges)

github
https://tinyurl.com/3mj2da2m
https://github.com/rogerjdeangelis/utl-common-variable-names-and-unique-variable-names-in-two-datasets


Related repo
PREVIOUS SIX SOLUTIONS

 1. Datastep and FCMP
 2. HASH by Bartosz Jablonski (need help with adding union)
 2.5 Bartosz Jablonski (recent addition - see end of message)
 3. R intersect and union
 4. Datastep view and proc sql (just intersect)
 5. Python (union and intersect - slightly different input)
 6.5  Rick's recent addition Rick Wicklin rick.wicklin@sas.com

https://tinyurl.com/yatup8u7
https://github.com/rogerjdeangelis/utl_how_to_find_the_union_and_intersection_of_words_in_two_strings_nlp

SAS Forum
https://tinyurl.com/yatdpaum
https://communities.sas.com/t5/SAS-Studio/How-to-find-the-union-and-intersection-of-two-string-combos/m-p/492517

Python Solution
http://forums.devshed.com/python-programming-11/compare-2-lists-words-strings-765278.html

/**************************************************************************************************************************/
/*   INPUT                   |                                                 |                                          */
/*   =====                   |                                                 |                                          */
/*    YEAR1    | YEAR2       | 1 SAS PROC SQL (VERY FLEXIBE)                   |  DSN     WANT                            */
/*    G        | G           | ==============                                  |                                          */
/*    E        | E           |                                                 |  YEAR1    CARS                           */
/*    N R    C | N R    R    | proc sql;                                       |  YEAR2    RISK                           */
/*    D A  A A | D A  A I    | create                                          |  both     GENDER                         */
/*    E C  G R | E C  G S    |   table want as                                 |  both     AGE                            */
/*    R E  E S | R E  E K    | select                                          |  both     RACE                           */
/*             |             |   case                                          |                                          */
/*    1 1 20 1 | 1 1 30 0    |     when count(distinct memname)=2              |                                          */
/*    2 4 30 2 | 1 1 50 1    |        then 'both'                              |                                          */
/*    3 5 40 1 | 1 2 60 2    |     else min(memname)                           |                                          */
/*    1 7 50 1 | 2 3 70 3    |   end as dsn                                    |                                          */
/*    2 9 60 3 | 2 4 40 4    |  ,name as want                                  |                                          */
/*    3 5 70 2 | 2 5 40 5    | from dictionary.columns                         |                                          */
/*                           | where                                           |                                          */
/*   options                 |   libname = 'WORK'                              |                                          */
/*    validvarname=upcase;   |   AND memname IN ('YEAR1', 'YEAR2')             |                                          */
/*   libname sd1 "d:/sd1";   | group by name                                   |                                          */
/*   data sd1.year1;         | order by dsn                                    |                                          */
/*   input gender            | ;quit;                                          |                                          */
/*         race              |                                                 |                                          */
/*         age               |--------------------------------------------------------------------------------------------*/
/*         cars;             | 2 R SQL SQLITE SQLDF                            |  R                                       */
/*   datalines;              | ====================                            |           DSN   WANT                     */
/*   1 1 20 1                |                                                 |                                          */
/*   2 4 30 2                | %utl_rbeginx;                                   |  1       both    AGE                     */
/*   3 5 40 1                | parmcards4;                                     |  2       both GENDER                     */
/*   1 7 50 1                | library(haven)                                  |  3       both   RACE                     */
/*   2 9 60 3                | library(sqldf)                                  |  4 year1_only   CARS                     */
/*   3 5 70 2                | source("c:/oto/fn_tosas9x.R")                   |  5 year2_only   RISK                     */
/*   ;;;;                    | year1<-read_sas("d:/sd1/year1.sas7bdat")        |                                          */
/*   run;quit;               | year2<-read_sas("d:/sd1/year2.sas7bdat")        |                                          */
/*                           | want <- sqldf("                                 |  SAS                                     */
/*   data sd1.year2;         |   with yr as (                                  |  DSN           WANT                      */
/*   input gender            |   select 'year1_only' as memname, name          |                                          */
/*         race              |     from pragma_table_info('year1')             |  both          AGE                       */
/*         age               |   union all                                     |  both          GENDER                    */
/*         risk;             |   select 'year2_only' as memname, name          |  both          RACE                      */
/*   datalines;              |     from pragma_table_info('year2')             |  year1_only    CARS                      */
/*   1 1 30 0                |   )                                             |  year2_only    RISK                      */
/*   1 1 50 1                | select                                          |                                          */
/*   1 2 60 2                |   case                                          |                                          */
/*   2 3 70 3                |     when count(distinct memname)=2              |                                          */
/*   2 4 40 4                |        then 'both'                              |                                          */
/*   2 5 40 5                |     else min(memname)                           |                                          */
/*   ;;;;                    |   end as dsn                                    |                                          */
/*   run;quit;               |  ,name as want                                  |                                          */
/*                           | from yr                                         |                                          */
/*                           | group by name                                   |                                          */
/*                           | order by dsn                                    |                                          */
/*                           |  ")                                             |                                          */
/*                           | want                                            |                                          */
/*                           | fn_tosas9x(                                     |                                          */
/*                           |       inp    = want                             |                                          */
/*                           |      ,outlib ="d:/sd1/"                         |                                          */
/*                           |      ,outdsn ="want"                            |                                          */
/*                           |      )                                          |                                          */
/*                           | ;;;;                                            |                                          */
/*                           | %utl_rendx;                                     |                                          */
/*                           |                                                 |                                          */
/*                           | proc print data=sd1.want;                       |                                          */
/*                           | run;quit;                                       |                                          */
/**************************************************************************************************************************/
/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
