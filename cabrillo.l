/*
    Description:    Lexer and Parser for Cabrillo log format used in Amateur Radio contests
    Version:        V0.1    20240406
    Author:         Tihomir Sokcevic
    Callsign:       CA3TSK
    Copyright:      Tihomir Sokcevic 2024
    License:        GNU General Public License v3.0 (GNU GPLv3)
    License-URL:    https://www.gnu.org/licenses/gpl-3.0.html
    Goal:           Provide basic open infrastructure to organize Amateur Radio contests, e.g.
                    for contests organized by the Chile Contest Group
    URL:            https://www.chilecontest.com
*/

%option noyywrap
%option nodefault


%{


/*
    Description:    Lexer and Parser for Cabrillo log format used in Amateur Radio contests
    Author:         Tihomir Sokcevic
    Callsign:       CA3TSK
    Copyright:      Tihomir Sokcevic 2024
    License:        GNU General Public License v3.0 (GNU GPLv3)
    License-URL:    https://www.gnu.org/licenses/gpl-3.0.html
    Goal:           Provide basic open infrastructure to organize Amateur Radio contests, e.g.
                    for contests organized by the Chile Contest Group
    URL:            https://www.chilecontest.com
*/

#include <stdio.h>
#include <stdlib.h>
#include "cabrillo.tab.h"

int iSTART_OF_LOG = 0;
int iEND_OF_LOG = 0;

void str_cat(char ** s, char * t) {
    if(!s || !t || !iSTART_OF_LOG){
        return;
    }

    if(!*s) {
        *s = (char *) calloc(strlen(t) + 64, sizeof(char));
        strcat(*s, t);
        return;
    }

    char * n = (char *) calloc(strlen(*s) + strlen(t) + 64, sizeof(char));
    strcat(n, *s);
    strcat(n, " ");
    strcat(n, t);
    free(*s);
    *s = n;
}

extern void yyerror(const char* s);

void duplicate_check(int max_count, int * prev_line) {
    if(iEND_OF_LOG) {
        return;
    }

    if(!prev_line) {
        yyerror("Unexpected internal error condition.");
        return;
    }

    if(!max_count && !*prev_line) {
        *prev_line = yylineno;
        return;
    }

    char buffer [50];
    char * s = NULL;

    if(max_count) {
        if(*prev_line <= max_count) {
           ++(*prev_line);
            return;
        }

        sprintf(buffer, "%02d", max_count);
        s = strdup("Maximum keyword entries amount is ");
    } else {
        sprintf(buffer, "%02d", *prev_line);
        s = strdup("Duplicate keyword previosuly used at line=");
    }

    str_cat(&s, buffer);

    yyerror(s);
}

int iCONTEST = 0;
int iCALLSIGN = 0;
int iCATEGORY_ASSISTED = 0;
int iCATEGORY_BAND = 0;
int iCATEGORY_MODE = 0;
int iCATEGORY_OPERATOR = 0;
int iCATEGORY_POWER = 0;
int iCATEGORY_STATION = 0;
int iCATEGORY_TIME = 0;
int iCATEGORY_TRANSMITTER = 0;
int iCATEGORY_OVERLAY = 0;
int iCATEGORY_CERTIFICATE = 0;
int iCLAIMED_SCORE = 0;
int iCLUB = 0;
int iCREATED_BY = 0;
int iEMAIL = 0;
int iGRID_LOCATOR = 0;
int iLOCATION = 0;
int iNAME = 0;
int iADDRESS = 0;       /* Up to 6 times */
int iADDRESS_CITY = 0;
int iADDRESS_STATE_PROVINCE = 0;
int iADDRESS_POSTALCODE = 0;
int iADDRESS_COUNTRY = 0;
int iOPERATORS = 0;
int iOFFTIME = 0;
int iDEBUG = 0;
int iSTATION_CALLSIGN = 0;


%}


%option bison-bridge
%option bison-locations
%option yylineno

whitespace                              [ \t\f\r]+
notwhitespace                           [^ \t\f\r\n]+

eol                                     "\r"?"\n"
callsign                                [a-zA-Z0-9]+[0-9][a-zA-Z0-9]*[a-zA-Z]
email                                   [a-zA-Z0-9\.\-\_]+"@"[a-zA-Z0-9\.\-\_]+"."[a-zA-Z0-9\.\-\_]+
date                                    [0-9][0-9][0-9][0-9]"-"[0-9][0-9]"-"[0-9][0-9]
maidenhead_grid4                        [a-rA-R][a-rA-R][0-9][0-9]
maidenhead_grid6                        [a-rA-R][a-rA-R][0-9][0-9][a-xA-X][a-xA-X]
maidenhead_grid8                        [a-rA-R][a-rA-R][0-9][0-9][a-xA-X][a-xA-X][0-9][0-9]
time                                    [0-9][0-9][0-9][0-9]
word                                    [a-zA-Z0-9\.\-\_]+


%%


"START-OF-LOG:"                         {duplicate_check(0, &iSTART_OF_LOG); yylval->str = 0; return KW_START_OF_LOG;}
"END-OF-LOG:"                           {iEND_OF_LOG = yylineno; return KW_END_OF_LOG;}


"CALLSIGN:"                             {duplicate_check(0, &iCALLSIGN); yylval->str = 0; return KW_CALLSIGN;}
"CONTEST:"                              {duplicate_check(0, &iCONTEST);yylval->str = 0; return KW_CONTEST;}

"CATEGORY-ASSISTED:"                    {duplicate_check(0, &iCATEGORY_ASSISTED); yylval->str = 0; return KW_CATEGORY_ASSISTED;}
"ASSISTED"|"NON-ASSISTED"               {str_cat(&yylval->str, yytext); return KW_CATEGORY_ASSISTED_VALUE;}

"CATEGORY-BAND:"                        {duplicate_check(0, &iCATEGORY_BAND); yylval->str = 0; return KW_CATEGORY_BAND;}
"ALL"|"160M"|"80M"                      {str_cat(&yylval->str, yytext); return KW_CATEGORY_BAND_VALUE;}
"40M"|"20M"|"15M"                       {str_cat(&yylval->str, yytext); return KW_CATEGORY_BAND_VALUE;}
"10M"|"6M"|"4M"                         {str_cat(&yylval->str, yytext); return KW_CATEGORY_BAND_VALUE;}
"2M"|"222"|"432"                        {str_cat(&yylval->str, yytext); return KW_CATEGORY_BAND_VALUE;}
"902"|"1.2G"|"2.3G"                     {str_cat(&yylval->str, yytext); return KW_CATEGORY_BAND_VALUE;}
"3.4G"|"5.7G"|"10G"                     {str_cat(&yylval->str, yytext); return KW_CATEGORY_BAND_VALUE;}
"24G"|"47G"|"75G"                       {str_cat(&yylval->str, yytext); return KW_CATEGORY_BAND_VALUE;}
"122G"|"134G"|"241G"                    {str_cat(&yylval->str, yytext); return KW_CATEGORY_BAND_VALUE;}
"Light"|"LIGHT"                         {str_cat(&yylval->str, yytext); return KW_CATEGORY_BAND_VALUE;}
"VHF-3-BAND"|"VHF-FM-ONLY"              {str_cat(&yylval->str, yytext); return KW_CATEGORY_BAND_VALUE;} /* ARRL */

"CATEGORY-MODE:"                        {duplicate_check(0, &iCATEGORY_MODE); yylval->str = 0; return KW_CATEGORY_MODE;}
"CW"|"DIGI"|"FM"|"RTTY"|"SSB"|"MIXED"   {str_cat(&yylval->str, yytext); return KW_CATEGORY_MODE_VALUE;}

"CATEGORY-OPERATOR:"                    {duplicate_check(0, &iCATEGORY_OPERATOR); yylval->str = 0; return KW_CATEGORY_OPERATOR;}
"SINGLE-OP"|"MULTI-OP"|"CHECKLOG"       {str_cat(&yylval->str, yytext); return KW_CATEGORY_OPERATOR_VALUE;}

"CATEGORY-POWER:"                       {duplicate_check(0, &iCATEGORY_POWER); yylval->str = 0; return KW_CATEGORY_POWER;}
"HIGH"|"LOW"|"QRP"                      {str_cat(&yylval->str, yytext); return KW_CATEGORY_POWER_VALUE;}

"CATEGORY-STATION:"                     {duplicate_check(0, &iCATEGORY_STATION); yylval->str = 0; return KW_CATEGORY_STATION;}
"DISTRIBUTED"|"FIXED"|"MOBILE"          {str_cat(&yylval->str, yytext); return KW_CATEGORY_STATION_VALUE;}
"PORTABLE"|"ROVER"|"ROVER-LIMITED"      {str_cat(&yylval->str, yytext); return KW_CATEGORY_STATION_VALUE;}
"ROVER-UNLIMITED"|"EXPEDITION"|"HQ"     {str_cat(&yylval->str, yytext); return KW_CATEGORY_STATION_VALUE;}
"SCHOOL"|"EXPLORER"                     {str_cat(&yylval->str, yytext); return KW_CATEGORY_STATION_VALUE;}

"CATEGORY-TIME:"                            {duplicate_check(0, &iCATEGORY_TIME); yylval->str = 0; return KW_CATEGORY_TIME;}
"6-HOURS"|"8-HOURS"|"12-HOURS"|"24-HOURS"   {str_cat(&yylval->str, yytext); return KW_CATEGORY_TIME_VALUE;}

"CATEGORY-TRANSMITTER:"                 {duplicate_check(0, &iCATEGORY_TRANSMITTER); yylval->str = 0; return KW_CATEGORY_TRANSMITTER;}
"ONE"|"TWO"|"LIMITED"|"UNLIMITED"|"SWL" {str_cat(&yylval->str, yytext); return KW_CATEGORY_TRANSMITTER_VALUE;}

"CATEGORY-OVERLAY:"                     {duplicate_check(0, &iCATEGORY_OVERLAY); yylval->str = 0; return KW_CATEGORY_OVERLAY;}
"CLASSIC"|"ROOKIE"|"TB-WIRES"           {str_cat(&yylval->str, yytext); return KW_CATEGORY_OVERLAY_VALUE;}
"YOUTH"|"NOVICE-TECH"|"YL"              {str_cat(&yylval->str, yytext); return KW_CATEGORY_OVERLAY_VALUE;}

"CATEGORY-CERTIFICATE:"                 {duplicate_check(0, &iCATEGORY_CERTIFICATE); yylval->str = 0; return KW_CATEGORY_CERTIFICATE;}
"YES"|"NO"                              {str_cat(&yylval->str, yytext); return KW_CATEGORY_CERTIFICATE_VALUE;}


"CLAIMED-SCORE:"                        {duplicate_check(0, &iCLAIMED_SCORE); yylval->str = 0; return KW_CLAIMED_SCORE;}
"CLUB:"                                 {duplicate_check(0, &iCLUB); yylval->str = 0; return KW_CLUB;}
"CREATED-BY:"                           {duplicate_check(0, &iCREATED_BY); yylval->str = 0; return KW_CREATED_BY;}
"EMAIL:"                                {duplicate_check(0, &iEMAIL); yylval->str = 0; return KW_EMAIL;}
"GRID-LOCATOR:"                         {duplicate_check(0, &iGRID_LOCATOR); yylval->str = 0; return KW_GRID_LOCATOR;}
"LOCATION:"                             {duplicate_check(0, &iLOCATION); yylval->str = 0; return KW_LOCATION;}
"NAME:"                                 {duplicate_check(0, &iNAME); yylval->str = 0; return KW_NAME;}

"ADDRESS:"                              {duplicate_check(6, &iADDRESS); yylval->str = 0; return KW_ADDRESS;}     /* Can be up to 6 address entries */
"ADDRESS-CITY:"                         {duplicate_check(0, &iADDRESS_CITY); yylval->str = 0; return KW_ADDRESS_CITY;}
"ADDRESS-STATE-PROVINCE:"               {duplicate_check(0, &iADDRESS_STATE_PROVINCE); yylval->str = 0; return KW_ADDRESS_STATE_PROVINCE;}
"ADDRESS-POSTALCODE:"                   {duplicate_check(0, &iADDRESS_POSTALCODE); yylval->str = 0; return KW_ADDRESS_POSTALCODE;}
"ADDRESS-COUNTRY:"                      {duplicate_check(0, &iADDRESS_COUNTRY); yylval->str = 0; return KW_ADDRESS_COUNTRY;}
"OPERATORS:"                            {duplicate_check(0, &iOPERATORS); yylval->str = 0; return KW_OPERATORS;}
"OFFTIME:"                              {duplicate_check(0, &iOFFTIME); yylval->str = 0; return KW_OFFTIME;}
"SOAPBOX:"                              {yylval->str = 0; return KW_SOAPBOX;}     /* Can be many entries */
"DEBUG:"                                {duplicate_check(0, &iDEBUG); yylval->str = 0; return KW_DEBUG;}
"X-QSO:"                                {yylval->str = 0; return KW_X_QSO;}
"X-"[^Q][^S][^O].*                      {yylval->str = 0; return KW_COMMENT;}     /* Can be many entries */
"QSO:"                                  {yylval->str = 0; return KW_QSO;}


"\r\n"                                  {return T_NEWLINE;}
"\n"                                    {return T_NEWLINE;}


{maidenhead_grid6}                      {str_cat(&yylval->str, yytext); return T_MAIDENHEAD_GRID;}
{maidenhead_grid4}                      {str_cat(&yylval->str, yytext); return T_MAIDENHEAD_GRID;}
{maidenhead_grid8}                      {str_cat(&yylval->str, yytext); return T_MAIDENHEAD_GRID;}

{email}                                 {str_cat(&yylval->str, yytext); return T_EMAIL;}

{callsign}                              {str_cat(&yylval->str, yytext); return T_CALLSIGN;}

[0-9]+                                  {str_cat(&yylval->str, yytext); return T_NUMBER;}

[a-zA-Z0-9\-]+                          {str_cat(&yylval->str, yytext); return T_CONTEST;}

{date}{whitespace}{time}{whitespace}{date}{whitespace}{time}    {str_cat(&yylval->str, yytext); return T_OFFTIME;}


{notwhitespace}                         {str_cat(&(yylval->str), yytext); return T_WORD;}

[ \t\f]+                                {/* Do nothing */}

.                                       {return *yytext;}

<<EOF>>                                 {static int once = 0; return once++ ? YY_NULL : T_NEWLINE ;}   /* Handle last line without new line */


%%
