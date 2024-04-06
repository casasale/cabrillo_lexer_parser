
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

extern int yylex(void*, void*);

extern int yyparse();
extern FILE* yyin;
extern char *yytext;
extern int yylineno;

void yyerror(const char* s);

#define STR_FREE(p)	{if(p){free(p); p = NULL;}}


%}


%locations

%union{
  char * str;
}

%define parse.error verbose
%define api.pure


%token<str> T_MAIDENHEAD_GRID
%token<str> T_EMAIL
%token<str> T_CONTEST
%token<str> T_CALLSIGN
%token<str> T_STATION_CALLSIGN
%token<str> T_WORD
%token<str> T_NUMBER
%token<str> T_OFFTIME

%token T_NEWLINE T_END

%token KW_START_OF_LOG KW_END_OF_LOG KW_COMMENT 
%token KW_CALLSIGN KW_CONTEST

%token KW_CATEGORY_ASSISTED
%token<str>  KW_CATEGORY_ASSISTED_VALUE

%token KW_CATEGORY_BAND 
%token<str> KW_CATEGORY_BAND_VALUE

%token KW_CATEGORY_MODE 
%token<str> KW_CATEGORY_MODE_VALUE

%token KW_CATEGORY_OPERATOR 
%token<str> KW_CATEGORY_OPERATOR_VALUE

%token KW_CATEGORY_POWER 
%token<str> KW_CATEGORY_POWER_VALUE

%token KW_CATEGORY_STATION 
%token<str> KW_CATEGORY_STATION_VALUE

%token KW_CATEGORY_TIME 
%token<str> KW_CATEGORY_TIME_VALUE

%token KW_CATEGORY_TRANSMITTER
%token<str> KW_CATEGORY_TRANSMITTER_VALUE

%token KW_CATEGORY_OVERLAY
%token<str> KW_CATEGORY_OVERLAY_VALUE

%token KW_CATEGORY_CERTIFICATE
%token<str> KW_CATEGORY_CERTIFICATE_VALUE


%token KW_CLAIMED_SCORE KW_CLUB KW_CREATED_BY KW_EMAIL KW_GRID_LOCATOR KW_LOCATION
%token KW_NAME KW_ADDRESS KW_ADDRESS_CITY KW_ADDRESS_STATE_PROVINCE
%token KW_ADDRESS_POSTALCODE KW_ADDRESS_COUNTRY
%token KW_OPERATORS KW_OFFTIME KW_SOAPBOX KW_DEBUG
%token KW_QSO KW_X_QSO


%start log


%%


log: log_start log_header_items log_qso_items log_end
;

log_start:	KW_START_OF_LOG sentence T_NEWLINE {printf("YY KW_START_OF_LOG: %s\n", yylval.str); STR_FREE(yylval.str);}
;

sentence:
			|	sentence T_WORD
			|	sentence T_CALLSIGN
			|	sentence T_EMAIL
			|	sentence T_MAIDENHEAD_GRID
			|	sentence T_CONTEST
			|	sentence T_NUMBER
;

operators:	T_CALLSIGN
			|	operators T_CALLSIGN
			|	operators T_STATION_CALLSIGN
;


log_end:	KW_END_OF_LOG T_NEWLINE {printf("YY KW_END_OF_LOG:\n"); exit(0);}
;


log_header_items:
			| log_header_items KW_CALLSIGN T_CALLSIGN T_NEWLINE  								{printf("YY KW_CALLSIGN: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_CONTEST contest T_NEWLINE 									{printf("YY KW_CONTEST: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_CATEGORY_ASSISTED KW_CATEGORY_ASSISTED_VALUE T_NEWLINE  		{printf("YY KW_CATEGORY_ASSISTED: %s\n", yylval.str); STR_FREE(yylval.str);}
			| log_header_items KW_CATEGORY_BAND KW_CATEGORY_BAND_VALUE T_NEWLINE  				{printf("YY KW_CATEGORY_BAND: %s\n", yylval.str); STR_FREE(yylval.str);}
			| log_header_items KW_CATEGORY_MODE KW_CATEGORY_MODE_VALUE T_NEWLINE  				{printf("YY KW_CATEGORY_MODE: %s\n", yylval.str); STR_FREE(yylval.str);}
			| log_header_items KW_CATEGORY_OPERATOR KW_CATEGORY_OPERATOR_VALUE T_NEWLINE  		{printf("YY KW_CATEGORY_OPERATOR: %s\n", yylval.str); STR_FREE(yylval.str);}
			| log_header_items KW_CATEGORY_POWER KW_CATEGORY_POWER_VALUE T_NEWLINE  			{printf("YY KW_CATEGORY_POWER: %s\n", yylval.str); STR_FREE(yylval.str);}
			| log_header_items KW_CATEGORY_STATION KW_CATEGORY_STATION_VALUE T_NEWLINE  		{printf("YY KW_CATEGORY_STATION: %s\n", yylval.str); STR_FREE(yylval.str);}
			| log_header_items KW_CATEGORY_TIME KW_CATEGORY_TIME_VALUE T_NEWLINE  				{printf("YY KW_CATEGORY_TIME: %s\n", yylval.str); STR_FREE(yylval.str);}
			| log_header_items KW_CATEGORY_TRANSMITTER KW_CATEGORY_TRANSMITTER_VALUE T_NEWLINE  {printf("YY KW_CATEGORY_TRANSMITTER: %s\n", yylval.str); STR_FREE(yylval.str);}
			| log_header_items KW_CATEGORY_OVERLAY KW_CATEGORY_OVERLAY_VALUE T_NEWLINE  		{printf("YY KW_CATEGORY_OVERLAY: %s\n", yylval.str); STR_FREE(yylval.str);}
			| log_header_items KW_CATEGORY_CERTIFICATE KW_CATEGORY_CERTIFICATE_VALUE T_NEWLINE	{printf("YY KW_CATEGORY_CERTIFICATE: %s\n", yylval.str); STR_FREE(yylval.str);}	/* LAST ENUM */
			| log_header_items KW_CLAIMED_SCORE number T_NEWLINE 								{printf("YY KW_CLAIMED_SCORE: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_CLUB sentence T_NEWLINE 										{printf("YY KW_CLUB: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_CREATED_BY sentence T_NEWLINE 								{printf("YY KW_CREATED_BY: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_EMAIL T_EMAIL T_NEWLINE 										{printf("YY KW_EMAIL: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_GRID_LOCATOR grid_locator T_NEWLINE 							{printf("YY KW_GRID_LOCATOR: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_LOCATION sentence T_NEWLINE 									{printf("YY KW_LOCATION: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_NAME sentence T_NEWLINE 										{printf("YY KW_NAME: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_ADDRESS sentence T_NEWLINE 									{printf("YY KW_ADDRESS: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_ADDRESS_CITY sentence T_NEWLINE 								{printf("YY KW_ADDRESS_CITY: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_ADDRESS_STATE_PROVINCE sentence T_NEWLINE						{printf("YY KW_ADDRESS_STATE_PROVINCE: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_ADDRESS_POSTALCODE sentence T_NEWLINE							{printf("YY KW_ADDRESS_POSTALCODE: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_ADDRESS_COUNTRY sentence T_NEWLINE							{printf("YY KW_ADDRESS_COUNTRY: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_OPERATORS operators T_NEWLINE									{printf("YY KW_OPERATORS: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_OFFTIME offtime T_NEWLINE 									{printf("YY KW_OFFTIME: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_SOAPBOX sentence T_NEWLINE 									{printf("YY KW_SOAPBOX: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_DEBUG sentence T_NEWLINE 										{printf("YY KW_DEBUG: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_header_items KW_COMMENT sentence T_NEWLINE 									{printf("YY KW_COMMENT:\n"); STR_FREE(yylval.str);}
;


contest:
			| T_CALLSIGN
			| T_CONTEST
			| T_NUMBER
;

grid_locator:
			| T_MAIDENHEAD_GRID
;

number:
			| T_NUMBER
;

offtime:
			| T_OFFTIME
;

log_qso_items: 
			| log_qso_items KW_QSO sentence T_NEWLINE 				{printf("YY KW_QSO: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_qso_items KW_X_QSO sentence T_NEWLINE 			{printf("YY KW_X_QSO: %s\n", yylval.str ); STR_FREE(yylval.str);}
			| log_qso_items KW_COMMENT sentence T_NEWLINE 			{printf("YY KW_COMMENT:\n"); STR_FREE(yylval.str);}
;


%%


int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Error: Line=%02d : %s\n", yylineno, s);
	exit(1);
}

