#!/bin/bash
#Background Colors
E=$(tput sgr0);    R=$(tput setab 1); G=$(tput setab 2); Y=$(tput setab 3);
B=$(tput setab 4); M=$(tput setab 5); C=$(tput setab 6); W=$(tput setab 7);
function e() { echo -e "$E"; }
function x() { echo -n "$E  "; }
function r() { echo -n "$R  "; }
function g() { echo -n "$G  "; }
function y() { echo -n "$Y  "; }
function b() { echo -n "$B  "; }
function m() { echo -n "$M  "; }
function c() { echo -n "$C  "; }
function w() { echo -n "$W  "; }

#putpixels
function u() { 
    h="$*";o=${h:0:1};v=${h:1}; 
    for i in `seq $v` 
    do 
        $o;
    done 
}

img="\
x40 e1 x40 e1 x40 e1 x31 w2 x7 e1 x31 w2 x7 e1 x13 y9 x9 r2 x7 e1 x11 y3 x1 y5 x1 y3 x7 y2 x7 e1 x10 y1 x1 y1 x1 y7 x1 y1 x1 y1 x6 y2 x7 e1 x8 y4 x1 y4 r1 y4 x1 y4 x4 y2 x7 e1 x8 y3 r1 y2 x7 y2 r1 y3 x4 y2 x7 e1 x8 y1 x5 y7 x5 y1 x4 y2 x7 e1 x8 y5 x1 y3 r1 y3 x1 y5 x4 y2 x7 e1 x8 y4 r1 y1 x7 y1 r1 y4 x4 y2 x7 e1 x9 y1 x4 y7 x4 y1 x5 y2 x7 e1 x10 y4 x1 y2 r1 y2 x1 y4 x6 y2 x7 e1 x11 y2 r1 y1 x5 y1 r1 y2 x7 y2 x7 e1 x13 y1 x1 y5 x1 y1 x9 y2 x7 e1 x15 y5 x11 y2 x7 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40"

for n in $img
do
    u $n
done
e;
exit 0;
