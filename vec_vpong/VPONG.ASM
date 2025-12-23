; this game was written on 08.02.1998 by christopher salomon
; it is public domain
;
; comments and vectrex talk are welcome
; my email: chrissalo@aol.com
;
;
; followin command line was used to assemble:
;
; c:>as09.exe -h0 -l -cti vpong.asm >error
;
; i used the 6809 assembler:
; as09 [1.11].
; copyright 1990-1994, frank a. vorstenbosch, kingswood software.
; available at:
; http://www.falstaff.demon.co.uk/cross.html
;
;
;
; load rom function names...
                include "VECTREX.I"
; user variable definitions
;$c890
user_ram        equ     $c890
music_active    equ     user_ram
paddle_pos      equ     music_active + 2
paddle_y        equ     paddle_pos
paddle_x        equ     paddle_y + 1
paddle_speed_y  equ     paddle_x + 1
paddle_speed_x  equ     paddle_speed_y + 1

ball_pos        equ     paddle_speed_x + 1
ball_y          equ     ball_pos
ball_x          equ     ball_y + 1
ball_speed_y    equ     ball_x + 1
ball_speed_x    equ     ball_speed_y + 1   ; speed like $hl, low for every round
ball_speed_y_hi equ     ball_speed_x + 1
ball_speed_x_hi equ     ball_speed_y_hi+ 1
ball_speed_y_reset equ  ball_speed_x_hi + 1
ball_speed_x_reset equ  ball_speed_y_reset+ 1
ball_available  equ     ball_speed_x_reset + 1   ; high for when next round

game_level      equ     ball_available + 1
paddle_check    equ     game_level + 1
paddle_increase equ     paddle_check + 1
court1_scale2   equ     paddle_increase + 1
paddle_intensity equ    court1_scale2 + 1
court1_intensity equ    paddle_intensity + 1
difficult_counter equ   court1_intensity +1
difficulty      equ     difficult_counter + 1
game_over_intensity equ difficulty + 1
game_over_scaley equ    game_over_intensity + 1
game_over_scalex equ    game_over_scaley + 1
game_over_ypos  equ    (((game_over_scalex + 2)/2)*2)
game_over_xpos  equ    game_over_ypos + 1

tmp             equ     game_over_xpos + 1
; see bottom of file for further addresses!

; user defines
; vectrex coordinates use range from -128 to +127
; these top and bottom values are in scale factor $ff
false            equ  (lo(0))
true             equ  (lo(1))
screen_top       equ  (lo($7f))
screen_bottom    equ  (lo(-$80))
screen_left      equ  (lo(-$80))
screen_right     equ  (lo($7f))
screen_center    equ  (lo(0))

normal_text_size equ $f160
score_text_size  equ $fb30
letter_width     equ (lo(16))
letter_hight     equ (lo(16))

paddle_width     equ (lo(20))
paddle_hight     equ (lo(5))

paddle_x_right   equ (lo(screen_right-paddle_width-$10))
paddle_x_left    equ (lo(screen_left+$11))

paddle_init_xpos equ (lo(screen_center-(paddle_width/2)))   ; center
paddle_init_ypos equ (lo(screen_bottom+($12)))              ; bottom of screen plus court1 modification
paddle_init_pos  equ (paddle_init_ypos*256+paddle_init_xpos)
paddle_init_speed equ (lo(2))
paddle_init_increase equ (lo(3))
paddle_intensity_init equ (lo($7f))

size_of_wall1    equ (lo($70))
court1_xpos      equ (screen_left+$10)
court1_ypos      equ (screen_bottom+$10)
court1_pos       equ (court1_ypos*256+(court1_xpos))
court1_compensate equ (0*256+(-size_of_wall1))
court1_intensity_init equ (lo($7f))

ball_size        equ (lo(5))
ball_init_ypos   equ (lo($6a))
ball_x_right     equ (lo(screen_right-ball_size-$10))
ball_x_left      equ (lo(screen_left+$11))

score_ypos       equ (screen_top-8)
score_xpos       equ (screen_left+8)
level_ypos       equ (screen_top-8)
level_xpos       equ (lo(0-30))
balls_ypos       equ (screen_top-8)
balls_xpos       equ (screen_right-60)
max_speed        equ (lo(10))

paddle_scale_init equ (lo($7f))
court1_scale_init1 equ (lo($ff))
court1_scale_init2 equ (lo($7f))
difficult_threshold equ (lo(5))
balls_per_game   equ (lo('5'))
;***************************************************************************

                org     0
; start of vectrex memory with cartridge name...
                db      "g GCE 1998", $80  ; 'g' is copyright sign
                dw      music7             ; music from the rom
                db      $f8, $50, $20, $c8 ; hight, width, rel x, rel y (from 0,0)
                db      "VECTREX PONG", $80; some game information, ending with $80
                db      $f8, $50, -$0, -$70 ; hight, width, rel x, rel y (from 0,0)
                db      "g CHRISTOPHER SALOMON", $80; some game information, ending with $80
                db      0                  ; end of game header
;***************************************************************************
; here the cartridge program starts off
entry_point:
new_game:
                jsr     init_screen        ; startup screen
                jsr     init_vars          ; initialize game variables
main_loop:
                jsr     do_my_sound        ; do own sound stuff
                jsr     wait_recal         ; sets dp to d0, and pos at 0, 0
                jsr     do_sound           ; play sound via rom
                jsr     draw_court         ; draw the court
                ; note: the paddle drawing could be optimized,
                ; since the bottom line of the paddle should
                ; have the same y position as there would be
                ; left after drawing the court
                ; for now the pen position is moved back to zero
                ; and the paddle is drawn independently
                jsr     draw_paddle
                jsr     draw_ball
                jsr     draw_strings
                lda     no_balls           ; test for game over
                cmpa    #'0'               ; when balls are zero
                beq     game_lost          ; than game lost
                bra     main_loop          ; start another round
;***************************************************************************
game_lost:
                ; do some extro
                clra                       ; clear a
                sta     game_over_intensity; and store in intensity
                sta     game_over_scalex   ; scale x
                sta     game_over_scaley   ; scale y
                sta     game_over_ypos     ; pos y
                sta     game_over_xpos     ; pos x of game over string
                ; the next instructions initialize a new sound
                lda     #$01               ; load #1
                sta     vec_music_flag     ; set this as marker for music start
                ldu     #musicb            ; load a music structure
                stu     music_active       ; and store it to my own music active pointer
                                           ; next a do_my_sound and than do sound must be called
game_over_loop1:
                jsr     do_my_sound        ; do own sound stuff
                jsr     wait_recal         ; sets dp to d0, and pos at 0, 0
                jsr     do_sound           ; do sound stuff
                ; now print something on screen
                lda     game_over_scaley   ; prepare drawing of game over string
                ldb     game_over_scalex   ; load scaling stuff
                std     vec_text_hw        ; poke it to ram location
                lda     game_over_intensity; load intensity
                jsr     intensity_a        ; set it
                lda     game_over_ypos     ; load position
                ldb     game_over_xpos     ; to d (a,b) register
                ldu     #game_over_string  ; and the address of the string itself
                jsr     print_str_d        ; and draw it
                ; calculate new appearence
                lda     game_over_intensity; increase intensity
                adda    #3                 ; three per step
                sta     game_over_intensity; store it
                anda    #$1                ; every second step increase
                beq     no_y_scale_now     ; y scale of string
                lda     game_over_scaley   ; load it
                suba    #1                 ; increase it
                sta     game_over_scaley   ; save it
no_y_scale_now:
                lda     game_over_ypos     ; now look at the position of the
                adda    #2                 ; string, first y pos
                cmpa    #$70               ; increase it by two, but not to much
                blo     use_y              ;
                lda     #$70               ; maximum at $70
use_y:
                sta     game_over_ypos     ; store it
                lda     game_over_xpos     ; likewise treat x pos load it
                suba    #2                 ; decrease it
                cmpa    #-$70              ; till -$70
                bge     use_x              ;
                lda     #-$70              ; or use minimum of -$70
use_x:
                sta     game_over_xpos     ; store it
                lda     game_over_scalex   ; now do the x scaling
                adda    #3                 ; every round add 3
                sta     game_over_scalex   ; and store it
                lda     game_over_intensity; do all this
                cmpa    #$7f               ; till intensity is full
                blo     game_over_loop1    ; do the game loop
                jsr     read_btns          ; get button status once, since only
                                           ; differences are noticed
                lda     game_over_scalex   ; now do the x scaling
                suba    #3                 ; every round add 3
                sta     game_over_scalex   ; and store it
game_over_loop2:
                jsr     do_my_sound        ; do own sound stuff
                jsr     wait_recal         ; sets dp to d0, and pos at 0, 0
                jsr     do_sound           ; do sound stuff
                jsr     intensity_7f       ; draw at full brightness
                ldd     #score_text_size
                std     vec_text_hw        ; poke it to ram location
                lda     #-$20              ; load position
                ldb     #-$30              ; to d (a,b) register
                ldu     #score_only_string
                jsr     print_str_d        ; and draw it
                lda     game_over_scaley   ; prepare drawing of game over string
                ldb     game_over_scalex   ; load scaling stuff
                std     vec_text_hw        ; poke it to ram location
                lda     game_over_ypos     ; load position
                ldb     game_over_xpos     ; to d (a,b) register
                ldu     #game_over_string  ; and the address of the string itself
                jsr     print_str_d        ; and draw it
                jsr     read_btns          ; get button status
                cmpa    #$00               ; is a button pressed?
                beq     game_over_loop2    ; no, than stay in init_screen_loop
                ldu     #vec_high_score    ; 'OS' high score
                ldx     #no_score_string   ; own last score
                jsr     new_high_score     ; if own was higher, set 'OS' == own
                bra     new_game           ; start a new game
;***************************************************************************
; this routine calculates the new paddle position for only x movement
; expected:dp is allready pointing to d0
; expects coordinates at 0,0
; possibly changes 'paddle_pos'
; nothing is returned
draw_paddle:
                jsr     joy_digital        ; read joystick positions
                ldb     paddle_x           ; load old paddle pos to b
                lda     vec_joy_1_x        ; load joystick 1 position x to a
                beq     no_new_pos         ; no joystick input available
                bmi     pos_left           ; joystick moved to left
pos_right:
                cmpb    #paddle_x_right    ; is it at maximum right position?
                beq     no_new_pos         ; if so, do nothing
                addb    paddle_speed_x     ; increase position with speed faktor
                stb     paddle_x           ; and store new position
                cmpb    #paddle_x_right    ; compare it again to right border
                ble     new_pos_exit       ; if lower or same (right) than ok
                ldb     #paddle_x_right    ; otherwise use the right
                stb     paddle_x           ; border as new position
                bra     new_pos_exit       ; and exit joystick position routine
pos_left:
                cmpb    #paddle_x_left     ; is it at maximum left position?
                beq     no_new_pos         ; if so, do nothing
                subb    paddle_speed_x     ; decrease position with speed faktor
                stb     paddle_x           ; and store new position
                cmpb    #paddle_x_left     ; compare it again to left border
                bge     new_pos_exit       ; if higher or same (left) than ok
                ldb     #paddle_x_left     ; otherwise use the left
                stb     paddle_x           ; border as new position
new_pos_exit:
no_new_pos:
                ldd     paddle_pos         ; load current paddle position to d
                jsr     moveto_d           ; move to rel position d
                lda     paddle_intensity   ; load paddle brightness
                jsr     intensity_a        ; switch intensity, joy_digital destroys this
                ldx     #bottom_paddle     ; address of paddle vector list
                jsr     draw_vlcs          ; draw vector list
                rts
;***************************************************************************
; this routine draws the outer court
; expecting dp is allready pointing to d0
; expects coordinates at 0,0
; nothing is returned
draw_court:
                lda     court1_intensity   ; load court1 brightness
                jsr     intensity_a        ; switch intensity
                lda     court1_scale2      ; scale for placing firt point
                sta     via_t1_cnt_lo      ; move to time 1 lo, this means scaling
                ldd     #court1_pos        ; first coordinate of court 1
                jsr     moveto_d           ; move to rel position d
                ldx     #court1            ; address of court vector list
                jsr     draw_vlcs          ; draw vector list
                ldd     #court1_compensate ; compensates the 'open' court
                jsr     moveto_d           ; move to rel position d
                lda     court1_scale2      ; scale for placing firt point
                sta     via_t1_cnt_lo      ; move to time 1 lo, this means scaling
                ldb     #court1_xpos       ; goes back to
                negb                       ; position
                lda     #court1_ypos       ; before court
                nega                       ; was drawn
                jsr     moveto_d           ; move to rel position d
                rts
;***************************************************************************
; this routine moves the ball and draws it
; expecting dp is allready pointing to d0
; expects intensity set to 7f
; nothing is returned
; optimization could easily be done e.g. via direct addressing!
draw_ball:
                lda     ball_available     ; check if there is a ball
                cmpa    #false             ; allready in play
                bne     ball_is_available  ; if not
                jsr     get_new_ball       ; get a new ball
ball_is_available:                         ; now start moving + drawing
                ; now we change the y position
                lda     ball_speed_y_hi    ; load y speed hi counter
                beq     no_y_wait          ; if zero, change y pos now
                deca                       ; decreas high counter
                sta     ball_speed_y_hi    ; and store it again
                bra     y_change_done      ; go to where no y change will be done
no_y_wait:
                ldb     ball_y             ; change the y position
                addb    ball_speed_y       ; with the speed factor
                stb     ball_y             ; and store it back
                lda     ball_speed_y_reset ; reset the
                sta     ball_speed_y_hi    ; high counter
y_change_done:
                ; now we change the x position
                lda     ball_speed_x_hi    ; load x speed hi counter
                beq     no_x_wait          ; if zero, change x pos now
                deca                       ; decreas high counter
                sta     ball_speed_x_hi    ; and store it again
                bra     x_change_done      ; go to where no x change will be done
no_x_wait:
                ldb     ball_x             ; change the x position
                addb    ball_speed_x       ; with the speed factor
                stb     ball_x             ; and store it back
                lda     ball_speed_x_reset ; reset the
                sta     ball_speed_x_hi    ; high counter
x_change_done:
                ; now we check if the ball bounces off a wall
                lda     ball_speed_x       ; in what direction is the ball moving?
                bmi     check_left         ; negative, than we check left border
                cmpb    #ball_x_right      ; ball right out of bounds?
                ble     x_right_ok         ;
                neg     ball_speed_x       ; yes, than change direction
                ; the next instructions initialize a new sound
                lda     #$01               ; load #1
                sta     vec_music_flag     ; set this as marker for music start
                ldu     #ping2             ; load a music structure
                stu     music_active       ; and store it to my own music active pointer
                                           ; next a do_my_sound and than do sound must be called
check_left:
                cmpb    #ball_x_left       ; ball left out of bounds?
                bge     x_left_ok          ;
                neg     ball_speed_x       ; yes, than change direction
                ; the next instructions initialize a new sound
                lda     #$01               ; load #1
                sta     vec_music_flag     ; set this as marker for music start
                ldu     #ping2             ; load a music structure
                stu     music_active       ; and store it to my own music active pointer
                                           ; next a do_my_sound and than do sound must be called
x_left_ok:
x_right_ok:                                ; x position is ok
                lda     ball_speed_y       ; checking for bottom?
                bpl     check_for_upper_border ; or upper border?
                ; now we check if the ball is hit with paddle (bottom)
                ldb     ball_y             ; load y position
                lda     paddle_check       ; is ball allready lost?
                cmpa    #false             ; allready lost?
                beq     allready_lost      ; yep... than don't check again
                subb    #ball_size         ; we must look at the bottom edge of the ball
                cmpb    #paddle_init_ypos  ; compare to paddle y
                bge     nothing_happens    ; if not there, than go on
                lda     paddle_x           ; get the x pos of the paddle
                cmpa    ball_x             ; compare to x of ball
                bge     paddle_greater_ball; if paddle higher...
paddle_lesser_ball:                        ; here paddle smaller than ball
                adda    #paddle_width      ; check if we have hit the ball
                cmpa    ball_x             ; with the body of the paddle
                blt     paddle_not_there   ; no!
                neg     ball_speed_y       ; yep, reflected, change y speed
                bra     ball_reflected     ; and go on
paddle_greater_ball:                       ; paddle higher ball
                suba    #ball_size         ; take the size of the ball into account
                cmpa    ball_x             ; and check again
                bgt     paddle_not_there   ; oops, ball seems lost!
                neg     ball_speed_y       ; yep, reflected, change y speed
                bra     ball_reflected     ; and go on
paddle_not_there:
                lda     #false             ; this ball is now lost
                sta     paddle_check       ; next time we don't check the paddle
allready_lost:
                cmpb    #screen_bottom     ; will ball move off the screen?
                bgt     is_roll_over       ; not yet, than go on
get_lost:
                sta     ball_available     ; next time a ball is not available
                jsr     ball_lost          ; ball is now lost
                rts                        ; bye!
is_roll_over:
                tstb                       ; test for
                bmi     nothing_happens    ; rollover otherwise do nothing
                bra     get_lost           ; now restart
check_for_upper_border:
; now we check if we are at the upper border
                ldb     ball_y             ; load y position
                cmpb    #ball_init_ypos    ; compare upper
                ble     nothing_happens    ; if not there, than go on
                lda     #ball_init_ypos    ; otherwise use init position
                sta     ball_y             ; store it
                neg     ball_speed_y       ; and reflect, using opposite y speed
                ; the next instructions initialize a new sound
                lda     #$01               ; load #1
                sta     vec_music_flag     ; set this as marker for music start
                ldu     #ping2             ; load a music structure
                stu     music_active       ; and store it to my own music active pointer
                                           ; next a do_my_sound and than do sound must be called
nothing_happens:
draw_ball_on_screen:
                jsr     reset0ref          ; reset screen position
                ldd     ball_pos           ; load position of ball
                jsr     moveto_d_7f        ; move to rel position d and scale factor 7f
                ldx     #ball              ; address of ball vector list
                jsr     draw_vlc           ; draw vector list
                rts
ball_reflected:
                ldb     ball_x             ; load x position of ball again!
                addb    #(ball_size/2)     ; and get the center of it
                lda     paddle_x           ; load x position of paddle
                adda    #(paddle_width/2)  ; and get the center of it
                sta     tmp                ; store ball center
                subb    tmp                ; in a now the offset of the
                                           ; ball center to the center of
                                           ; the paddle
                                           ; should be abs(10)
                asrb                       ; only a quarter should remain
                asrb                       ;
                lda      difficulty        ; load difficulty setting
                mul                        ; multiply a*b
                addb     ball_speed_x      ; and modify the x speed accordingly
                stb      ball_speed_x      ; store it
                lda      #1                ; score 1 for reflecting
                ldx      #no_score_string  ; load score address
                jsr      add_score_a       ; add to score
                lda      #1                ; score 1 for reflecting
                ldx      #no_level_string  ; load level address
                jsr      add_score_a       ; add to level
                inc      game_level        ; add to level
                ; let's see if we can make it a bit more difficult!
                inc     difficult_counter  ; increase counter
                lda     difficult_counter  ; load it
                cmpa    #difficult_threshold ; and check if new difficult level is reached
                bne     no_difficult_change; no, not yet
                inc     difficulty         ; difficulty + 1
                clra                       ; difficult_counter to zero
                sta     difficult_counter  ; store it
                inc     ball_speed_y       ; y speed one up :-)
                lda     ball_speed_y       ; load speed to a
                cmpa    #max_speed         ; check if not too fast
                ble     no_speed_overflow  ; do nothing
                lda     #max_speed         ; store max_speed
                sta     ball_speed_y       ; to ball y speed
no_speed_overflow:
no_difficult_change:
                lda     ball_speed_x       ; load x speed
                cmpa    #0                 ; check for 0 speed
                bne     no_x_zero_speed    ; if none zero do nothing
                jsr     random             ; get random
                tfr     a,b                ; copy to b
                andb    #$1                ; look at first bit
                cmpb    #0                 ; test for zero
                beq     no_x_speed_change  ; do nothing if zero
                tsta                       ; positive or negative random?
                bpl     change_to_plus1    ; or plus
                lda     #-1                ; -1
                sta     ball_speed_x       ; store x speed
                bra     done_speed_change  ;
change_to_plus1:
                lda     #1                 ; 1
                sta     ball_speed_x       ; store x speed
no_x_speed_change:
no_x_zero_speed:
done_speed_change:
                lda     ball_speed_y       ; load y speed of ball
                cmpa    paddle_increase    ; and see if paddle should be faster
                blt     no_paddle_speed_change ; no, not yet
                inc     paddle_speed_x     ; go faster in x
                lda     paddle_increase    ; and new increase threshold
                adda    #2                 ; old plus 2
                sta     paddle_increase    ; and store
no_paddle_speed_change:
                ; the next instructions initialize a new sound
                lda     #$01               ; load #1
                sta     vec_music_flag     ; set this as marker for music start
                ldu     #ping1             ; load a music structure
                stu     music_active       ; and store it to my own music active pointer
                                           ; next a do_my_sound and than do sound must be called
                bra     draw_ball_on_screen
;***************************************************************************
; this routine initiates a new ball
; not finnished yet
; nothing is returned
get_new_ball:
                lda     #true              ; next time a ball is
                sta     ball_available     ; available
                sta     paddle_check       ; next time we check the paddle
                clra                       ; start in the middle of screen
                sta     ball_x             ; this is the next x position
                lda     #ball_init_ypos    ; start at top of screen
                sta     ball_y             ; this is the next y position
                lda     #-1                ; ball y speed ; allway negativ, since ball must
                                           ; move down!
                sta     ball_speed_y       ; not randomized yet
                lda     #0                 ; hi value for y speed for now
                sta     ball_speed_y_hi    ; allways zero
                sta     ball_speed_y_reset ; as is the reset value
                jsr     random             ; get random number to a
                anda    #($3)              ; only the 2 lower bits are needed
                tfr     a,b                ; copy it to a
                jsr     random             ; get random number to a
                tsta                       ; is it positive?
                bpl     positiv_x          ; if so use positiv x speed
                negb                       ; else negative
positiv_x:
                stb     ball_speed_x       ; now store the speed
                lda     #0                 ; hi value for x speed for now
                sta     ball_speed_x_hi    ; allways zero
                sta     ball_speed_x_reset ; as is the reset value
                rts
;***************************************************************************
ball_lost:
                ; the next instructions initialize a new sound
                lda     #$01               ; load #1
                sta     vec_music_flag     ; set this as marker for music start
                ldu     #ball_lost_sound   ; load a music structure
                stu     music_active       ; and store it to my own music active pointer
                                           ; next a do_my_sound and than do sound must be called
                lda     court1_scale1      ; just for the loop, might do a bra as a jump into the loop
lost_loop:
                sta     court1_scale1      ; store the last changed court 1 scale factor
                jsr     do_my_sound        ; do own sound stuff
                jsr     wait_recal         ; sets dp to d0, and pos at 0, 0
                jsr     do_sound           ; play sound via rom
                jsr     draw_court         ; draw the court
                jsr     draw_paddle        ; draw paddle
                jsr     draw_strings       ; draw strings (not scaled, should i?)
                lda     court1_scale2      ; load scale value2 of court (for positioning)
                suba    #3                 ; decrease it
                sta     court1_scale2      ; and write it back
                lda     bottom_paddle_scale; load scale value of paddle
                suba    #3                 ; decrease it
                sta     bottom_paddle_scale; and write it back
                lda     court1_intensity   ; load intensity of court
                suba    #3                 ; decrease it
                sta     court1_intensity   ; and write it back
                lda     paddle_intensity   ; load intensity of paddle
                suba    #3                 ; decrease it
                sta     paddle_intensity   ; and write it back
                lda     court1_scale1      ; load scale value1 of court (for sizing)
                suba    #6                 ; decrease it
                bcc     lost_loop          ; and write it back
                dec     no_balls           ; one ball less
                jsr     init_new_ball_vars ; and reinit all destroyed variables
                rts
;***************************************************************************
; this routine initializes the game variables
; nothing is expected and nothing is returned
init_vars:
                jsr     init_os            ; init os, should allready been done...
                ldu     #_copy_start       ; my 'ram' address (source)
                ldx     #copy_start        ; copy my 'ram' to vectrex ram (destination)
                lda     #(_copy_end-_copy_start) ; number of bytes to be copied, must be less than $81
                jsr     move_mem_a         ; and copy...
                lda     #false             ; no ball availabel
                sta     ball_available     ; upon startup
                lda     #1                 ; initial game level
                sta     game_level         ; upon startup
                ldx     #no_score_string   ; get the address of score string
                jsr     clear_score        ; clear score
                lda     #balls_per_game    ; balls 5
                sta     no_balls           ; and store five balls
                ldd     #paddle_init_pos   ; load init values
                std     paddle_pos         ; and store them...
init_new_ball_vars:
                ldx     #no_level_string   ; get level string
                jsr     clear_score        ; clear level string
                clra                       ; clear level number
                lda     #paddle_init_speed ; initial paddle speed x
                sta     paddle_speed_x     ; and store it
                lda     #paddle_init_speed ; initial paddle speed y
                sta     paddle_speed_y     ; and store it
                lda     #paddle_init_increase ; set paddle increase
                sta     paddle_increase    ; and store
                lda     #court1_scale_init1; init value for court scale 1
                sta     court1_scale1      ; scale for placing first point
                lda     #court1_scale_init2; init value for court scale 2
                sta     court1_scale2      ; scale for court size
                lda     #paddle_scale_init ; init value for paddle size
                sta     bottom_paddle_scale; paddle scale value
                lda     #paddle_intensity_init ; set the brightness
                sta     paddle_intensity   ; of the paddle
                lda     #court1_intensity_init ; set the brightness
                sta     court1_intensity   ; of the court
                clra                       ; difficult to zero
                sta     difficult_counter  ; store it
                inca                       ; difficulty to 1
                sta     difficulty         ; store it
                rts
;***************************************************************************
; this routine draws the initial screen
; with information about the game
; nothing is expected and nothing is returned
init_screen:
                jsr     read_btns          ; get button status once, since only
                                           ; differences are noticed
                ldd     #normal_text_size  ; load default text height & width
                std     vec_text_hw        ; poke it to ram location
                jsr     intensity_7f       ; draw at full brightness
                ; the next 5 instructions initialize a new sound
                jsr     dp_to_c8           ; set dp...
                lda     #$01               ; load #1
                sta     vec_music_flag     ; set this as marker for music start
                ldu     #music4            ; load a music structure
                stu     music_active       ; and store it to my own music active pointer
                                           ; next a do_my_sound and than do sound must be called
init_screen_loop:
                jsr     do_my_sound        ; do own sound stuff
                jsr     wait_recal         ; sets dp to d0, and pos at 0, 0
                jsr     do_sound           ; do sound stuff
                ldu     #game_name         ; load text start to u
                                           ; get a=y, b=x (d=ab) coordinate
                lda     #(letter_hight/2)  ; center text y
                ldb     #(-(letter_width*11)/2) ; center text x
                jsr     print_str_d        ; print the string
                jsr     read_btns          ; get button status
                cmpa    #$00               ; is a button pressed?
                beq     init_screen_loop   ; no, than stay in init_screen_loop
exit_init_screen:                          ; otherwise proceed
                rts
;***************************************************************************
; expecting dp is allready pointing to d0
; prints 'score', 'hits' and 'balls'
draw_strings:
                jsr     intensity_7f       ; draw at full brightness
                jsr     reset0ref          ; reset screen position
                ldu     #score_string      ; load text start to u
                                           ; get a=y, b=x (d=ab) coordinate
                jsr     print_list_hw      ; print the string
                rts
;***************************************************************************
; leaves with dp set to c8
; expects music to be initialized
; and pointer in music_active
do_my_sound:
                jsr     dp_to_c8           ; set dp to c8
                ldu     music_active       ; get active music
                jsr     init_music_chk     ; and init new notes
                rts
;***************************************************************************
game_name:
                db   "VECTREX PONG", $80
game_over_string:
                db   "GAME OVER", $80
;***************************************************************************
ball:
                db    3                    ; 4 vectors are drawn
                db    0,   ball_size       ; next point relativ (y,x)
                db   ball_size,    0       ; next point relativ (y,x)
                db    0,  -ball_size       ; next point relativ (y,x)
                db  -ball_size,    0       ; next point relativ (y,x)
;***************************************************************************
; note: ping1 and ping2 stolen from patriots, hope you don't mind John!
ping1:
                fdb     $fd69
                fdb     $fd79
                fcb     $20,$0a
                fcb     0, $80
;***************************************************************************
ping2:
                fdb     $fd69
                fdb     $fd79
                fcb     $0a,$0a
                fcb     0, $80
;***************************************************************************
ball_lost_sound:
                fdb     $fe66,$feb6
                fcb     $07, $12
                fcb     $07, $06
                fcb     $00, $3c
                fcb     $18, $80
;***************************************************************************
; entries following must be copied to vectrex ram...
; start of 'my ram'
_copy_start:
;***************************************************************************
_score_string:
                db   hi(score_text_size)
                db   lo(score_text_size)
                db   score_ypos, score_xpos
_score_only_string:
                db   "SCORE:"
_no_score_string:
                db   "000000", $80
_level_string:
                db   hi(score_text_size)
                db   lo(score_text_size)
                db   level_ypos, level_xpos
                db   "HITS:"
_no_level_string:
                db   "000000", $80
_balls_string:
                db   hi(score_text_size)
                db   lo(score_text_size)
                db   balls_ypos, balls_xpos
                db   "BALLS:"
_no_balls:
                db    balls_per_game,$80
_string_list_end:
                db   0
;***************************************************************************
_bottom_paddle:
                db    3                    ; 4 vectors are drawn
_bottom_paddle_scale:
                db    paddle_scale_init    ; 4 size of paddle
                db    0,   paddle_width    ; next point relativ (y,x)
                db   paddle_hight,    0    ; next point relativ (y,x)
                db    0,  -paddle_width    ; next point relativ (y,x)
                db  -paddle_hight,    0    ; next point relativ (y,x)
;***************************************************************************
_court1:
                db    2                    ; 3 vectors are drawn
_court1_scale1:
                db    court1_scale_init2   ; size of court
                db    size_of_wall1,     0 ; next point relativ (y,x)
                db      0,   size_of_wall1 ; next point relativ (y,x)
                db   -size_of_wall1,     0 ; next point relativ (y,x)
;***************************************************************************
_copy_end:
;***************************************************************************
; stupid assembler, these defines must be made after the above
; labels
copy_start      equ     ((tmp/2)*2 + 100)
score_string    equ     (copy_start)
score_only_string equ   (copy_start+(_score_only_string-_copy_start))
no_score_string equ     (copy_start+(_no_score_string-_copy_start))
level_string    equ     (copy_start+(_level_string-_copy_start))
no_level_string equ     (copy_start+(_no_level_string-_copy_start))
balls_string    equ     (copy_start+(_balls_string-_copy_start))
no_balls        equ     (copy_start+(_no_balls-_copy_start))
bottom_paddle   equ     (copy_start+(_bottom_paddle-_copy_start))
bottom_paddle_scale equ (copy_start+(_bottom_paddle_scale-_copy_start))
court1          equ     (copy_start+(_court1-_copy_start))
court1_scale1   equ     (copy_start+(_court1_scale1-_copy_start))
;***************************************************************************
                end entry_point
;***************************************************************************
