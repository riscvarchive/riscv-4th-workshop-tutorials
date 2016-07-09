/*
  (C) COPYRIGHT 2016 TECHNOLUTION B.V., GOUDA NL
  =======          I                   ==          I    =
     I             I                    I          I
|    I   ===   === I ===  I ===   ===   I  I    I ====  I   ===  I ===
|    I  /   \ I    I/   I I/   I I   I  I  I    I  I    I  I   I I/   I
|    I  ===== I    I    I I    I I   I  I  I    I  I    I  I   I I    I
|    I  \     I    I    I I    I I   I  I  I   /I  \    I  I   I I    I
|    I   ===   === I    I I    I  ===  ===  === I   ==  I   ===  I    I
|                 +---------------------------------------------------+
+----+            |  +++++++++++++++++++++++++++++++++++++++++++++++++|
     |            |             ++++++++++++++++++++++++++++++++++++++|
     +------------+                          +++++++++++++++++++++++++|
                                                        ++++++++++++++|
                                                                 +++++|
 */

#include <stdio.h>

void payload(void);
void delay(int time);


/**
 * Show hacked jumping on the screen, while setting both lights
 * to green.
 *
 * This should be the first function in this file, as this will be
 * the entry point of the download.
 */
void payload(void){

    const char * hacked = "\n"
    "##     ##    ###     ######  ##    ## ######## ########  \n"
    "##     ##   ## ##   ##    ## ##   ##  ##       ##     ## \n"
    "##     ##  ##   ##  ##       ##  ##   ##       ##     ## \n"
    "######### ##     ## ##       #####    ######   ##     ## \n"
    "##     ## ######### ##       ##  ##   ##       ##     ## \n"
    "##     ## ##     ## ##    ## ##   ##  ##       ##     ## \n"
    "##     ## ##     ##  ######  ##    ## ######## ########  \n";


    for(;;){
        for(int a = 0; a < 10; a++){
            printf("\f");
            for(int i = 0; i < a; i++){
                printf("\n");
            }
            printf("%s",hacked);
            delay(100);
        }
        for(int a = 10; a > 0; a--){
            printf("\f");
            for(int i = 0; i < a; i++){
                printf("\n");
            }
            printf("%s",hacked);
            delay(100);
        }
    }
}

/**
 * make a delay function that forces both lights to 'green'
 */
void delay(int time)
{
    for(int i = 0; i < time; i++){
        vTaskDelay(1);
        setLeds(0x9700, 0x700);
    }
}

