# Tihomir Sokcevic CA3TSK Cabrillo Lexer_Parser
Lexer and parser for Cabrillo log format used for Amateur Radio contests (flex and bison)

Source code:   https://github.com/casasale/cabrillo_lexer_parser

Chile Contest Group https://www.chilecontest.com/

____________________________________________________
Goal:         Provide basic open infrastructure to organize Amateur Radio contests, e.g. for contests organized by the Chile Contest Group

____________________________________________________
How to examples:

make ; # Compile it

./cabrillo < logs/WW_DIGI_2023_CA3TSK.cabrillo  ; # Redirect a log file to the executable

./cabrillo < logs/CQ_WPX_SSB_2024_CB3A.cabrillo

____________________________________________________

- Version:      V0.1    20240406
- Author:       Tihomir Sokcevic
- Callsign:     CA3TSK
- Copyright:    Tihomir Sokcevic 2024
- License:      GNU General Public License v3.0 (GNU GPLv3)
- License-URL:  https://www.gnu.org/licenses/gpl-3.0.html
- URL:          https://www.chilecontest.com

____________________________________________________
Timeline (Versions):
- 20240406 V0.1 Initial version that parses the cabrillo log and prints out the details

____________________________________________________
This code was developed based on the details from https://wwrof.org/cabrillo/

____________________________________________________

# 73 de Tihomir CA3TSK, Chile
