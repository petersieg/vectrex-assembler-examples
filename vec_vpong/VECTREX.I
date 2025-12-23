vec_snd_shadow  equ     $c800   ;shadow of sound chip registers (15 bytes)
vec_btn_state   equ     $c80f   ;current state of all joystick buttons
vec_prev_btns   equ     $c810   ;previous state of all joystick buttons
vec_buttons     equ     $c811   ;current toggle state of all buttons
vec_button_1_1  equ     $c812   ;current toggle state of stick 1 button 1
vec_button_1_2  equ     $c813   ;current toggle state of stick 1 button 2
vec_button_1_3  equ     $c814   ;current toggle state of stick 1 button 3
vec_button_1_4  equ     $c815   ;current toggle state of stick 1 button 4
vec_button_2_1  equ     $c816   ;current toggle state of stick 2 button 1
vec_button_2_2  equ     $c817   ;current toggle state of stick 2 button 2
vec_button_2_3  equ     $c818   ;current toggle state of stick 2 button 3
vec_button_2_4  equ     $c819   ;current toggle state of stick 2 button 4
vec_joy_resltn  equ     $c81a   ;joystick a/d resolution ($80=min $00=max)
vec_joy_1_x     equ     $c81b   ;joystick 1 left/right
vec_joy_1_y     equ     $c81c   ;joystick 1 up/down
vec_joy_2_x     equ     $c81d   ;joystick 2 left/right
vec_joy_2_y     equ     $c81e   ;joystick 2 up/down
vec_joy_mux     equ     $c81f   ;joystick enable/mux flags (4 bytes)
vec_joy_mux_1_x equ     $c81f   ;joystick 1 x enable/mux flag (=1)
vec_joy_mux_1_y equ     $c820   ;joystick 1 y enable/mux flag (=3)
vec_joy_mux_2_x equ     $c821   ;joystick 2 x enable/mux flag (=5)
vec_joy_mux_2_y equ     $c822   ;joystick 2 y enable/mux flag (=7)
vec_misc_count  equ     $c823   ;misc counter/flag byte, zero when not in use
vec_0ref_enable equ     $c824   ;check0ref enable flag
vec_loop_count  equ     $c825   ;loop counter word (incremented in wait_recal)
vec_brightness  equ     $c827   ;default brightness
vec_dot_dwell   equ     $c828   ;dot dwell time?
vec_pattern     equ     $c829   ;dot pattern (bits)
vec_text_hw     equ     $c82a   ;default text height and width
vec_text_height equ     $c82a   ;default text height
vec_text_width  equ     $c82b   ;default text width
vec_str_ptr     equ     $c82c   ;temporary string pointer for print_str
vec_counters    equ     $c82e   ;six bytes of counters
vec_counter_1   equ     $c82e   ;first  counter byte
vec_counter_2   equ     $c82f   ;second counter byte
vec_counter_3   equ     $c830   ;third  counter byte
vec_counter_4   equ     $c831   ;fourth counter byte
vec_counter_5   equ     $c832   ;fifth  counter byte
vec_counter_6   equ     $c833   ;sixth  counter byte
vec_riserun_tmp equ     $c834   ;temp storage word for rise/run
vec_angle       equ     $c836   ;angle for rise/run and rotation calculations
vec_run_index   equ     $c837   ;index pair for run
*                       $c839   ;pointer to copyright string during startup
vec_rise_index  equ     $c839   ;index pair for rise
*                       $c83b   ;high score cold-start flag (=0 if valid)
vec_riserun_len equ     $c83b   ;length for rise/run
*                       $c83c   ;temp byte
vec_rfrsh       equ     $c83d   ;refresh time (divided by 1.5mhz)
vec_rfrsh_lo    equ     $c83d   ;refresh time low byte
vec_rfrsh_hi    equ     $c83e   ;refresh time high byte
vec_music_work  equ     $c83f   ;music work buffer (14 bytes, backwards?)
vec_music_wk_a  equ     $c842   ;        register 10
*                       $c843   ;        register 9
*                       $c844   ;        register 8
vec_music_wk_7  equ     $c845   ;        register 7
vec_music_wk_6  equ     $c846   ;        register 6
vec_music_wk_5  equ     $c847   ;        register 5
*                       $c848   ;        register 4
*                       $c849   ;        register 3
*                       $c84a   ;        register 2
vec_music_wk_1  equ     $c84b   ;        register 1
*                       $c84c   ;        register 0
vec_freq_table  equ     $c84d   ;pointer to note-to-frequency table (normally $fc8d)
vec_max_players equ     $c84f   ;maximum number of players for select_game
vec_max_games   equ     $c850   ;maximum number of games for select_game
vec_adsr_table  equ     $c84f   ;storage for first music header word (adsr table)
vec_twang_table equ     $c851   ;storage for second music header word ('twang' table)
vec_music_ptr   equ     $c853   ;music data pointer
vec_expl_chana  equ     $c853   ;used by explosion_snd - bit for first channel used?
vec_expl_chans  equ     $c854   ;used by explosion_snd - bits for all channels used?
vec_music_chan  equ     $c855   ;current sound channel number for init_music
vec_music_flag  equ     $c856   ;music active flag ($00=off $01=start $80=on)
vec_duration    equ     $c857   ;duration counter for init_music
vec_music_twang equ     $c858   ;3 word 'twang' table used by init_music
vec_expl_1      equ     $c858   ;four bytes copied from explosion_snd's U-reg parameters
vec_expl_2      equ     $c859   ;
vec_expl_3      equ     $c85a   ;
vec_expl_4      equ     $c85b   ;
vec_expl_chan   equ     $c85c   ;used by explosion_snd - channel number in use?
vec_expl_chanb  equ     $c85d   ;used by explosion_snd - bit for second channel used?
vec_adsr_timers equ     $c85e   ;adsr timers for each sound channel (3 bytes)
vec_music_freq  equ     $c861   ;storage for base frequency of each channel (3 words)
*                       $c85e   ;scratch 'score' storage for display_option (7 bytes)
vec_expl_flag   equ     $c867   ;explosion_snd initialization flag?
*               $c868...$c876   ;unused?
vec_expl_timer  equ     $c877   ;used by explosion_snd
*                       $c878   ;unused?
vec_num_players equ     $c879   ;number of players selected in select_game
vec_num_game    equ     $c87a   ;game number selected in select_game
vec_seed_ptr    equ     $c87b   ;pointer to 3-byte random number seed (=$c87d)
vec_random_seed equ     $c87d   ;default 3-byte random number seed
                                ;
*    $c880 - $cbea is user ram  ;
                                ;
vec_default_stk equ     $cbea   ;default top-of-stack
vec_high_score  equ     $cbeb   ;high score storage (7 bytes)
vec_swi3_vector equ     $cbf2   ;swi2/swi3 interrupt vector (3 bytes)
vec_swi2_vector equ     $cbf2   ;swi2/swi3 interrupt vector (3 bytes)
vec_firq_vector equ     $cbf5   ;firq interrupt vector (3 bytes)
vec_irq_vector  equ     $cbf8   ;irq interrupt vector (3 bytes)
vec_swi_vector  equ     $cbfb   ;swi/nmi interrupt vector (3 bytes)
vec_nmi_vector  equ     $cbfb   ;swi/nmi interrupt vector (3 bytes)
vec_cold_flag   equ     $cbfe   ;cold start flag (warm start if = $7321)
                                ;
via_port_b      equ     $d000   ;via port b data i/o register
*       0 sample/hold (0=enable  mux 1=disable mux)
*       1 mux sel 0
*       2 mux sel 1
*       3 sound bc1
*       4 sound bdir
*       5 comparator input
*       6 external device (slot pin 35) initialized to input
*       7 /ramp
via_port_a      equ     $d001   ;via port a data i/o register (handshaking)
via_ddr_b       equ     $d002   ;via port b data direction register (0=input 1=output)
via_ddr_a       equ     $d003   ;via port a data direction register (0=input 1=output)
via_t1_cnt_lo   equ     $d004   ;via timer 1 count register lo (scale factor)
via_t1_cnt_hi   equ     $d005   ;via timer 1 count register hi
via_t1_lch_lo   equ     $d006   ;via timer 1 latch register lo
via_t1_lch_hi   equ     $d007   ;via timer 1 latch register hi
via_t2_lo       equ     $d008   ;via timer 2 count/latch register lo (refresh)
via_t2_hi       equ     $d009   ;via timer 2 count/latch register hi
via_shift_reg   equ     $d00a   ;via shift register
via_aux_cntl    equ     $d00b   ;via auxiliary control register
*       0 pa latch enable
*       1 pb latch enable
*       2 \                     110=output to cb2 under control of phase 2 clock
*       3  > shift register control     (110 is the only mode used by the vectrex rom)
*       4 /
*       5 0=t2 one shot                 1=t2 free running
*       6 0=t1 one shot                 1=t1 free running
*       7 0=t1 disable pb7 output       1=t1 enable pb7 output
via_cntl        equ     $d00c   ;via control register
*       0 ca1 control     ca1 -> sw7    0=irq on low 1=irq on high
*       1 \
*       2  > ca2 control  ca2 -> /zero  110=low 111=high
*       3 /
*       4 cb1 control     cb1 -> nc     0=irq on low 1=irq on high
*       5 \
*       6  > cb2 control  cb2 -> /blank 110=low 111=high
*       7 /
via_int_flags   equ     $d00d   ;via interrupt flags register
*               bit                             cleared by
*       0 ca2 interrupt flag            reading or writing port a i/o
*       1 ca1 interrupt flag            reading or writing port a i/o
*       2 shift register interrupt flag reading or writing shift register
*       3 cb2 interrupt flag            reading or writing port b i/o
*       4 cb1 interrupt flag            reading or writing port a i/o
*       5 timer 2 interrupt flag        read t2 low or write t2 high
*       6 timer 1 interrupt flag        read t1 count low or write t1 high
*       7 irq status flag               write logic 0 to ier or ifr bit
via_int_enable  equ     $d00e   ;via interrupt enable register
*       0 ca2 interrupt enable
*       1 ca1 interrupt enable
*       2 shift register interrupt enable
*       3 cb2 interrupt enable
*       4 cb1 interrupt enable
*       5 timer 2 interrupt enable
*       6 timer 1 interrupt enable
*       7 ier set/clear control
via_port_a_nohs equ     $d00f   ;via port a data i/o register (no handshaking)

cold_start      equ     $f000   ;
warm_start      equ     $f06c   ;
init_via        equ     $f14c   ;
init_os_ram     equ     $f164   ;
init_os         equ     $f18b   ;
wait_recal      equ     $f192   ;
set_refresh     equ     $f1a2   ;
dp_to_d0        equ     $f1aa   ;
dp_to_c8        equ     $f1af   ;
read_btns_mask  equ     $f1b4   ;
read_btns       equ     $f1ba   ;
joy_analog      equ     $f1f5   ;
joy_digital     equ     $f1f8   ;
sound_byte      equ     $f256   ;
sound_byte_x    equ     $f259   ;
sound_byte_raw  equ     $f25b   ;
clear_sound     equ     $f272   ;
sound_bytes     equ     $f27d   ;
sound_bytes_x   equ     $f284   ;
do_sound        equ     $f289   ;
do_sound_x      equ     $f28c   ;
intensity_1f    equ     $f29d   ;
intensity_3f    equ     $f2a1   ;
intensity_5f    equ     $f2a5   ;
intensity_7f    equ     $f2a9   ;
intensity_a     equ     $f2ab   ;
dot_ix_b        equ     $f2be   ;
dot_ix          equ     $f2c1   ;
dot_d           equ     $f2c3   ;
dot_here        equ     $f2c5   ;
dot_list        equ     $f2d5   ;
dot_list_reset  equ     $f2de   ;
recalibrate     equ     $f2e6   ;
moveto_x_7f     equ     $f2f2   ;
moveto_d_7f     equ     $f2fc   ;
moveto_ix_ff    equ     $f308   ;
moveto_ix_7f    equ     $f30c   ;
moveto_ix_a     equ     $f30e   ;
moveto_ix       equ     $f310   ;
moveto_d        equ     $f312   ;
reset0ref_d0    equ     $f34a   ;
check0ref       equ     $f34f   ;
reset0ref       equ     $f354   ;
reset_pen       equ     $f35b   ;
reset0int       equ     $f36b   ;
print_str_hwyx  equ     $f373   ;
print_str_yx    equ     $f378   ;
print_str_d     equ     $f37a   ;
print_list_hw   equ     $f385   ;
print_list      equ     $f38a   ;
print_list_chk  equ     $f38c   ;
print_ships_x   equ     $f391   ;
print_ships     equ     $f393   ;
mov_draw_vlc_a  equ     $f3ad   ;count y x y x ...
mov_draw_vl_b   equ     $f3b1   ;y x y x ...
mov_draw_vlcs   equ     $f3b5   ;count scale y x y x ...
mov_draw_vl_ab  equ     $f3b7   ;y x y x ...
mov_draw_vl_a   equ     $f3b9   ;y x y x ...
mov_draw_vl     equ     $f3bc   ;y x y x ...
mov_draw_vl_d   equ     $f3be   ;y x y x ...
draw_vlc        equ     $f3ce   ;count y x y x ...
draw_vl_b       equ     $f3d2   ;y x y x ...
draw_vlcs       equ     $f3d6   ;count scale y x y x ...
draw_vl_ab      equ     $f3d8   ;y x y x ...
draw_vl_a       equ     $f3da   ;y x y x ...
draw_vl         equ     $f3dd   ;y x y x ...
draw_line_d     equ     $f3df   ;y x y x ...
draw_vlp_ff     equ     $f404   ;pattern y x pattern y x ... $01
draw_vlp_7f     equ     $f408   ;pattern y x pattern y x ... $01
draw_vlp_scale  equ     $f40c   ;scale pattern y x pattern y x ... $01
draw_vlp_b      equ     $f40e   ;pattern y x pattern y x ... $01
draw_vlp        equ     $f410   ;pattern y x pattern y x ... $01
draw_pat_vl_a   equ     $f434   ;y x y x ...
draw_pat_vl     equ     $f437   ;y x y x ...
draw_pat_vl_d   equ     $f439   ;y x y x ...
draw_vl_mode    equ     $f46e   ;mode y x mode y x ... $01
print_str       equ     $f495   ;
random_3        equ     $f511   ;
random          equ     $f517   ;
init_music_buf  equ     $f533   ;
clear_x_b       equ     $f53f   ;
clear_c8_ram    equ     $f542   ;never used by gce carts?
clear_x_256     equ     $f545   ;
clear_x_d       equ     $f548   ;
clear_x_b_80    equ     $f550   ;
clear_x_b_a     equ     $f552   ;
dec_3_counters  equ     $f55a   ;
dec_6_counters  equ     $f55e   ;
dec_counters    equ     $f563   ;
delay_3         equ     $f56d   ;30 cycles
delay_2         equ     $f571   ;25 cycles
delay_1         equ     $f575   ;20 cycles
delay_0         equ     $f579   ;12 cycles
delay_b         equ     $f57a   ;5*b + 10 cycles
delay_rts       equ     $f57d   ;5 cycles
bitmask_a       equ     $f57e   ;
abs_a_b         equ     $f584   ;
abs_b           equ     $f58b   ;
rise_run_angle  equ     $f593   ;
get_rise_idx    equ     $f5d9   ;
get_run_idx     equ     $f5db   ;
get_rise_run    equ     $f5ef   ;
rise_run_x      equ     $f5ff   ;
rise_run_y      equ     $f601   ;
rise_run_len    equ     $f603   ;
rot_vl_ab       equ     $f610   ;
rot_vl          equ     $f616   ;
rot_vl_mode_a   equ     $f61f   ;
rot_vl_mode     equ     $f62b   ;
rot_vl_dft      equ     $f637   ;
xform_run_a     equ     $f65b   ;
xform_run       equ     $f65d   ;
xform_rise_a    equ     $f661   ;
xform_rise      equ     $f663   ;
move_mem_a_1    equ     $f67f   ;
move_mem_a      equ     $f683   ;
init_music_chk  equ     $f687   ;
init_music      equ     $f68d   ;
init_music_x    equ     $f692   ;
select_game     equ     $f7a9   ;
clear_score     equ     $f84f   ;
add_score_a     equ     $f85e   ;
add_score_d     equ     $f87c   ;
strip_zeros     equ     $f8b7   ;
compare_score   equ     $f8c7   ;
new_high_score  equ     $f8d8   ;
obj_will_hit_u  equ     $f8e5   ;
obj_will_hit    equ     $f8f3   ;
obj_hit         equ     $f8ff   ;
explosion_snd   equ     $f92e   ;
draw_grid_vl    equ     $ff9f   ;
                                ;
music1  equ $fd0d               ;
music2  equ $fd1d               ;
music3  equ $fd81               ;
music4  equ $fdd3               ;
music5  equ $fe38               ;
music6  equ $fe76               ;
music7  equ $fec6               ;
music8  equ $fef8               ;
music9  equ $ff26               ;
musica  equ $ff44               ;
musicb  equ $ff62               ;
musicc  equ $ff7a               ;
musicd  equ $ff8f               ;
