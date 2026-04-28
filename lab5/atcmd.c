#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>

#include "morse_codes.h"
#include "pico/stdlib.h"

#define LINE_SIZE  80

//#define SIMPLE_AT
#define LOCAL_ECHO_AT

#ifdef SIMPLE_AT
bool local_echo = false;
#else
bool local_echo = true;
#endif
int dot_time = 100;

void parse_cmd(char *cmd);
void morse_symbol(char c, int dot_length);
void morse_send(const char *str, int dot_length);

int main() {

    // Initialize chosen serial port
    stdio_init_all();
    //stdio_set_translate_crlf(&stdio_usb, false); // disable cr-lf translation
    gpio_init(20);
    gpio_set_dir(20, true);
    gpio_put(20, false);

    char rcv[LINE_SIZE];
    int pos = 0;
    int prev = 0;
    while(true){
        int ch = getchar_timeout_us(5000000);
        if(ch != PICO_ERROR_TIMEOUT) {
            if(local_echo) {
                if (!(ch == '\n' && prev == '\r')) putchar(ch); // don't print LF if previous was CR to avoid double LF
                if (ch == '\r') putchar('\n'); // always follow CR with LF
            }
            prev = ch;
            //printf("%02X ",ch);
            if(ch == '\r' || ch == '\n') {
                // crude command parser
                if(strlen(rcv) > 0) {
                    //printf("\n[%s]\n",rcv);
                    parse_cmd(rcv);
                }
                // clear
                rcv[0] = '\0';
                pos = 0;
            }
            else {
                if(ch == 127) { /* backspace handling */
                    if(pos > 0) {
                        --pos;
                    }
                }
                else {
                    //if(isspace(ch)) ch = ' '; // convert all white space to spaces
                    rcv[pos++] = ch; 
                    if(pos >= LINE_SIZE) --pos;
                }
                rcv[pos] = '\0';
            }
        }
        else {
            // timeout
            //rcv[0] =  '\0';
            //pos = 0;
        }
    }
}

#ifdef SIMPLE_AT
void parse_cmd(char *cmd) {
    if(strncmp(cmd, "AT", 2) == 0 || strncmp(cmd, "at", 2) == 0) {
        char *par = cmd + 2;
        if(par[0] == '\0') {
            printf("OK\n");
        }
        else if(strncmp("+SEND=\"", par, 7) == 0 && strchr(par + 7, '\"') != NULL) {
            par += 7;
            par[strcspn(par, "\"")] = '\0';
            printf("SENT=\"");
            for(int i = 0; par[i] != '\0'; ++i) {
                putchar(isalnum((int)par[i]) ? toupper((int)par[i]) : (isspace((int)par[i]) ? ' ' : 'X'));
            }
            printf("\"\nOK\n");
        }
        else {
            printf("INVALID\n");
            //printf("AT: %s\n", par);
        }
    }
    else {
        printf("ERROR\n");
    }
}
#endif

#ifdef LOCAL_ECHO_AT
void parse_cmd(char *cmd) {
    if(strncmp(cmd, "AT", 2) == 0 || strncmp(cmd, "at", 2) == 0) {
        char *par = cmd + 2;
        int value = 0;
        switch(par[0]) {
            case 0:
                printf("OK\n");
                break;
            case 'E':
            case 'e':
                if(sscanf(par+1, "%d", &value)==1) {
                    local_echo = (bool) value;
                    printf("OK\n");
                }
                else if(par[1] == '\0') {
                    printf("%s\nOK\n", local_echo ? "ON" : "OFF");
                }
                else {
                    printf("INVALID\n");
                }
                break;
            case 'W':
            case 'w':
                if(sscanf(par+1, "%d", &value)==1 && value >= 10 && value <= 1000) {
                    dot_time = value;
                    printf("OK\n");
                }
                else if(par[1] == '\0') {
                    printf("%d\nOK\n", dot_time);
                }
                else {
                    printf("INVALID\n");
                }
                break;
            default:
                if( (strncmp("+SEND=\"", par, 7) == 0 || strncmp("+send=\"", par, 7) == 0)
                    && strchr(par + 7, '\"') != NULL) {
                    char cnv[LINE_SIZE] = "";
                    par += 7;
                    for(int i = 0; par[i] != '\0' && par[i] != '\"'; ++i) {
                        char chs[2] = {0,0};
                        chs[0] = isalnum((int)par[i]) ? toupper((int)par[i]) : (isspace((int)par[i]) ? ' ' : 'X');
                        strcat(cnv, chs);
                    }
                    morse_send(cnv, dot_time);
                    printf("SENT=\"%s\"\nOK\n", cnv);
                }
                else {
                    printf("INVALID\n");
                }
                break;
        }
    }
    else {
        printf("ERROR\n");
    }
}
#endif

void morse_symbol(char c, int dot_length)
{
    int k = 0;
    int i = 0;
    bool match = false;

    if(c == ' ') {
        gpio_put(20, 0);
        // add four more to get standard word gap (we have a gap of three at the end of previous letter)
        sleep_ms(DOT * dot_length * 4);
    }
    else {
        do {
            // linear search for morse code
            for(k = 0; ITU_morse[k].symbol != 0; k++) {
                if(ITU_morse[k].symbol == c) {
                    for(i = 0; ITU_morse[k].code[i] != 0; i++) {
                        gpio_put(20, 1);
                        sleep_ms(ITU_morse[k].code[i] * dot_length);
                        gpio_put(20, 0);
                        sleep_ms(DOT * dot_length); // intra character gap
                    }
                    sleep_ms(2 * DOT * dot_length); // add two more to get short gap at the end of letter
                    match = true;
                    break;
                }
            }
            c = 'X'; // this will be used on the second round if no match was found
        } while(!match);
    }
}


void morse_send(const char *str, int dot_length)
{
    int i;

    for(i = 0; str[i] != 0; i++) {
        morse_symbol(toupper((int)str[i]), dot_length);
    }

}
