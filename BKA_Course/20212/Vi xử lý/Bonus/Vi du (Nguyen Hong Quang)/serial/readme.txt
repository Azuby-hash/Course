
    Here's a bunch of routines that I use on and off.  Hopefully,
some of these will be generically useful.  For sure, there are some
are completely useless to most people, such as the routines that
convert to base 36.

    I'll be happy to answer any questions about them, either via
e-mail or via the list-server.

        - John

    There are routines to:

UTIL_ADCAD      - Add Acc to DPTR, sets CY
UTIL_ADCBAD     - Add B/A to DPTR, sets CY
UTIL_SUBBAD     - Subtracts Acc from DPTR, sets CY
UTIL_SUBBBAD        - Subtracts B/A from DTPR, sets CY
UTIL_INC16      - Increments 16 bit location in IRAM
UTIL_UCOMPARE16 - Compares DPTR to 16 bit IRAM value
UTIL_UCMPDPTRBA - Compares DPTR to B/A
UTIL_SHIFT4L        - Shfts a 16 bit IRAM value 4 bits left
UTIL_LDDPTRC        - Load DPTR from (DPTR) ROM
UTIL_LDDPTRD        - Load DPTR from (DPTR) XRAM
UTIL_STDPTRD        - Store R6/7 to (DPTR) XRAM
UTIL_DPTRR01        - Exchange R0/1 <-> DPTR
UTIL_DPTRR67        - Exchange R6/7 <-> DPTR
UTIL_DPTR2C     - 2s complelment DPTR
UTIL_DPTRDEC        -  DPTR = DPTR - 1, sets CY
UTIL_DPTRASR1       - Arithmetic shift right DPTR
UTIL_DPTRSHR1       - Shift DPTR right
UTIL_DPTRROL4       - Rotate DPTR left 4
UTIL_DPTRSHL4       - Shift DPTR left
UTIL_R3R7RL4        - Shift R3/4/5/6/7 4 bits left
UTIL_DPTRX10        - DPTR = DPTR * 10
UTIL_DPTRX100       - DPTR = DPTR * 100
UTIL_DPTRX1000      - DPTR = DPTR * 1000
UTIL_CALLFUNC       - Call function DPTR points to
UTIL_TOLOWER        - Convert Acc to lowercase
UTIL_TOUPPER        - Convert Acc to uppercase
UTIL_HEXTOBIN       - Convert ACSII hex to binary
UTIL_DECTOBIN       - Convert ASCII decimal to binary
UTIL_BCDTOBIN       - Convert BCD to binary
UTIL_ASC36TOBIN - Convert base 36 value to binary
UTIL_BINTOASC       - Convert binary to ASCII
UTIL_BINTOASC36 - Convert binary to ASCII base 36
UTIL_BINTOBCD       - Convert 8 bit binary to BCD
UTIL_BINTOBCD12 - Convert 12 bit binary to BCD
UTIL_BINTODEC       - Convert DPTR to signed string
UTIL_BINTOUDEC  - Convert DPTR to unsigned string
UTIL_VALDCDG        - Validate Acc for ASCII decimal
UTIL_VALHXDG        - Validate Acc for ASCII hex
UTIL_VALALPHA       - Validate Acc for A..Z, a..z, 0..9
UTIL_VALALPHAZ  - Validate string for A..Z, a..z, 0..9
UTIL_CNTDG      - Count ASCII decimal in string
UTIL_UDIV       - Unsigned divide
UTIL_UMOD       - Unsigned mod
UTIL_DIV        - Signed divide
UTIL_MOD        - Signed mod
UTIL_COPYXTOI       - Copy XRAM to IRAM, length
UTIL_COPYITOX       - Copy IRAM to XRAM, length
UTIL_COPYCTODL  - Copy ROM to XRAM, length
UTIL_COPYCTODZ  - Copy ROM to XRAM, string
UTIL_COPYDTODL  - Copy XRAM to XRAM, length
UTIL_COPYDTODZ  - Copy XRAM to XRAM, string
UTIL_PUT_ETX        - Replace 0x00 with ETX in string
UTIL_FIND_ETX       - Locate ETX in string
UTIL_TRIM       - Remove trailing spaces
UTIL_STRLEN     - Return length of string

John C. Wren, KD4DTS
jcwren@atlanta.com
770-840-9200 x2417 (W)
