# Cabrillo Lexer Parser
Lexer and parser for Cabrillo log format used for Amateur Radio contests (flex and bison)

Source code:   https://github.com/casasale/cabrillo_lexer_parser

Chile Contest Group https://www.chilecontest.com/
                    https://www.chilecontest.com/CE-WPX_Contest_Rules_English_V2.pdf

____________________________________________________
Goal:         Provide basic open infrastructure to organize Amateur Radio contests, e.g. for contests organized by the Chile Contest Group

____________________________________________________
How to examples:

make ; # Compile it

./cabrillo logs/WW_DIGI_2023_CA3TSK.cabrillo

./cabrillo logs/WW_DIGI_2025_CE3TSK.cabrillo

./cabrillo logs/CQ_WPX_SSB_2024_CB3A.cabrillo

____________________________________________________

- Author:       Tihomir CE3TSK
- Callsign:     CE3TSK
- Copyright:    Tihomir CE3TSK 2024-2026
- License:      GNU General Public License v3.0 (GNU GPLv3)
- License-URL:  https://www.gnu.org/licenses/gpl-3.0.html
- URL:          https://www.chilecontest.com

____________________________________________________
Timeline (Versions):
- 20250313 V0.3 Fixed a shift/reduce conflict
- 20240411 V0.2 Added missing comma support in operators, and prefixes to avoid collisions
- 20240406 V0.1 Initial version that parses the cabrillo log and prints out the details

____________________________________________________
This code was developed based on the details from https://wwrof.org/cabrillo/

____________________________________________________

# 73 from Chile de Tihomir CE3TSK
