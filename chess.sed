#n
# sed chess by Evgeny Stepanischev (http://bolknote.ru) Aug 2013
1s/.*/\
    @\
    figures()\
    board()\
    label(loop)\
        label(blackkingmove)\
            input()\
            move-white()\
            check-black-king-exists()\
            select-figures(K)\
            make-fake-kings()\
            select-figures(p)\
            label(pawnwhite)\
                iter-pawn()\
                break-if-end(pawnwhite)\
                delete-last-board()\
                store-only-iter()\
            back(pawnwhite)\
            select-figures(q)\
            label(queenwhite)\
                iter-queen()\
                break-if-end(queenwhite)\
                delete-last-board()\
                store-only-iter()\
            back(queenwhite)\
            select-figures(k)\
            label(kingwhitw)\
                iter-king()\
                break-if-end(kingwhite)\
                delete-last-board()\
                store-only-iter()\
            back(kingwhite)\
            select-figures(i)\
            label(bishopwhite)\
                iter-bishop()\
                break-if-end(bishopwhite)\
                delete-last-board()\
                store-only-iter()\
            back(bishopwhite)\
            select-figures(n)\
            label(knightwhite)\
                iter-knight()\
                break-if-end(knightwhite)\
                delete-last-board()\
                store-only-iter()\
            back(knightwhite)\
            select-figures(r)\
            label(rookwhite)\
                iter-rook()\
                break-if-end(rookwhite)\
                delete-last-board()\
                store-only-iter()\
            back(rookwhite)\
            check-mate()\
            break-if-end(blackkingmove)\
            move-black()\
            check-white-king-exists()\
            board()\
        back(blackkingmove)\
        board()\
        select-figures(K)\
        label(king)\
            iter-king()\
            break-if-end(king)\
            set-array()\
            estimate-white-pieces()\
            set-array()\
            estimate-black-pieces()\
            estimate-black-king()\
            sum-array()\
            sub-array()\
            delete-last-board()\
            store-iter()\
        back(king)\
        select-figures(P)\
        label(pawn)\
            iter-pawn()\
            break-if-end(pawn)\
            set-array()\
            estimate-white-pieces()\
            set-array()\
            estimate-black-pieces()\
            estimate-black-pawn()\
            sum-array()\
            sub-array()\
            delete-last-board()\
            store-iter()\
        back(pawn)\
        select-figures(Q)\
        label(queen)\
            iter-queen()\
            break-if-end(queen)\
            set-array()\
            estimate-white-pieces()\
            set-array()\
            estimate-black-pieces()\
            estimate-black-queen()\
            sum-array()\
            sub-array()\
            delete-last-board()\
            store-iter()\
        back(queen)\
        select-figures(I)\
        label(bishop)\
            iter-bishop()\
            break-if-end(bishop)\
            set-array()\
            estimate-white-pieces()\
            set-array()\
            estimate-black-pieces()\
            estimate-black-bishop()\
            sum-array()\
            sub-array()\
            delete-last-board()\
            store-iter()\
        back(bishop)\
        select-figures(N)\
        label(knight)\
            iter-knight()\
            break-if-end(knight)\
            set-array()\
            estimate-white-pieces()\
            set-array()\
            estimate-black-pieces()\
            estimate-black-knight()\
            sum-array()\
            sub-array()\
            delete-last-board()\
            store-iter()\
        back(knight)\
        select-figures(R)\
        label(rook)\
            iter-rook()\
            break-if-end(rook)\
            set-array()\
            estimate-white-pieces()\
            estimate-black-pieces()\
            sub-array()\
            delete-last-board()\
            store-iter()\
        back(rook)\
        find-best-move()\
        move-black()\
        board()\
        check-white-king-exists()\
        select-figures(k)\
        make-fake-kings()\
        select-figures(P)\
        label(pawnmoves)\
            iter-pawn()\
            break-if-end(pawnmoves)\
            delete-last-board()\
            store-only-iter()\
        back(pawnmoves)\
        select-figures(Q)\
        label(queenmoves)\
            iter-queen()\
            break-if-end(queenmoves)\
            delete-last-board()\
            store-only-iter()\
        back(queenmoves)\
        select-figures(K)\
        label(kingmoves)\
            iter-king()\
            break-if-end(kingmoves)\
            delete-last-board()\
            store-only-iter()\
        back(kingmoves)\
        select-figures(I)\
        label(bishopmoves)\
            iter-bishop()\
            break-if-end(bishopmoves)\
            delete-last-board()\
            store-only-iter()\
        back(bishopmoves)\
        select-figures(N)\
        label(knightmoves)\
            iter-knight()\
            break-if-end(knightmoves)\
            delete-last-board()\
            store-only-iter()\
        back(knightmoves)\
        select-figures(R)\
        label(rookmoves)\
            iter-rook()\
            break-if-end(rookmoves)\
            delete-last-board()\
            store-only-iter()\
        back(rookmoves)\
        check-mate()\
    back(loop)\
/


# Evaluation matrices are programmed from the book
# "Programming chess and other logic games" Evgeny Kornilov

# Reformatting commands
1s/ *//g; 1s/\n\n*/ /g; 1s/^ //

# Process the incoming team
1!{
    /^\([a-h][1-8]\) *\([a-h][1-8]\)$/ {
        s//\1 \2/
        # Add the values ​​obtained in front of a stack of execution
        G; s/\n/ /
        # Turn on the performance of teams
        b @
    }

    # A player wants to leave
    /^q/ q

    # Put any nonsense, erase and return stack commands
    i\
    [12H[J[1A
    s/.*//

    g
    b
}

:@
s/@\([^ ]* \)/\1@/

# Begin array
/@set-array()/ {
    s/^/ARRAY /
    b @
}

# Mark
/@label(/ {
    b @
}

# Move to the label
/@back(/ {
    s/label(\([^)]*\))\(.*\)@back(\1)/@label(\1)\2back(\1)/
    b @
}

# Out of the loop, if the top END
/@break-if-end(/ {
    /^END */{
        s///
        s/@break-if-end(\([^)]*\))\(.*\)back(\1)/break-if-end(\1)\2@back(\1)/
    }
    b @
}

# Input data
/@input()/ {
    h; b
}

# Delete the last copy of the board
/@delete-last-board()/ {
    s/\(.*\)Board:[^ ]* */\1/
    b @
}

# Overlapping boards
/@copy-board()/ {
    s/\(Board:[^ ]*\)/\1 \1/
    b @
}

# Generation of the initial state boards
/@figures()/ {
    # Format: XYFig
    # Coordinates of white here and then have to go below the black
    # BIG - black, small - white
    s/^/Board:\
a8Rb8Nc8Id8Qe8Kf8Ig8Nh8R\
a7Pb7Pc7Pd7Pe7Pf7Pg7Ph7P\
a6 b6 c6 d6 e6 f6 g6 h6 \
a5 b5 c5 d5 e5 f5 g5 h5 \
a4 b4 c4 d4 e4 f4 g4 h4 \
a3 b3 c3 d3 e3 f3 g3 h3 \
a2pb2pc2pd2pe2pf2pg2ph2p\
a1rb1nc1id1qe1kf1ig1nh1r /
# Need a space at the end!

#     s/^/Board:\
# a8 b8 c8 d8 e8Kf8 g8 h8r\
# a7 b7 c7 d7 e7 f7 g7 h7 \
# a6 b6 c6 d6 e6nf6 g6 h6 \
# a5 b5 c5 d5 e5 f5 g5 h5 \
# a4 b4 c4 d4 e4 f4 g4 h4 \
# a3 b3 c3 d3 e3 f3 g3 h3 \
# a2 b2 c2 d2 e2 f2 g2 h2k\
# a1 b1 c1 d1 e1 f1 g1 h1  /

    s/\n//g

    b @
}

# Output boards
/@board()/ {
    # Save the stack commands
    h
    # Remove all but the board (we are always the last board)
    s/.*Board://
    s/ .*$//
    # Decode board
    # Pawn, Queen, King, Bishop, Knight, Rook, Zero - psevdokorolʹ to determine the mats chess
    s/..z//g
    y/pqkinrPQKINR12345678abcd/♟♛♚♝♞♜♙♕♔♗♘♖987654323579/
    s/\([1-9e-h]\)\([1-9]\)\(.\)/[\2;\1H\3 /g

    # Brighten
    s/[8642];[37eg]H/&[48;5;209;37;1m/g
    s/[9753];[37eg]H/&[48;5;94;37;1m/g
    s/[8642];[59fh]H/&[48;5;94;37;1m/g
    s/[9753];[59fh]H/&[48;5;209;37;1m/g

    # Double figures
    s/e/11/g;s/f/13/g;s/g/15/g;s/h/17/g

    s/$/[0m[11H/
    # Print the board and return it as it was
    i\
[2J[1;3Ha b c d e f g h\
8\
7\
6\
5\
4\
3\
2\
1\
\
Enter the command
    p
    g

    b @
}

# Make progress on a user-entered data
/@move-white()/ {
    # Guard basic regex (they need to be carefully protected from malfunctions that,
    # else sed will give an error and stops)
    # We clean everything but the board and the first two values
    h; s/\([^ ]*\) \([^ ]*\).*Board:\([^ ]*\).*/\1 \2 \3/
    
    # Select the cells
    s/\([^ ]*\) [^ ]* .*\(\1.\)/&(1:\2)/
    s/[^ ]* \([^ ]*\) .*\(\1.\)/&(2:\2)/
    # Now they are in the format:
    # Nomer_po_poryadku_vvoda: XYFigura
    s/.*(\(.....\)).*(\(.....\)).*/\1 \2/

    # Now check the following:
    # 1. that does not take someone else's, and not an empty shape
    /1:..[PQKINR ]/ {
        g; s/[^ ]* [^ ]* *//; b @
    }

    # 2. do not put in place of the figure
    /2:..[pqkinr]/ {
        g; s/[^ ]* [^ ]* *//; b @
    }

    # Procedure is as follows:
    # Specified coordinates found in the figures change each

    # If progress is ahead ...
    /2:.*1:/ {
        g
        #    1        2                3            4           5
        /\([^ ]*\) \([^ ]*\) \(.*Board:[^ ]*\)\2.\([^ ]*\)\1\([pqkinr]\)/ {
            s//\3\1 \4\2\5/
            b move-white::checkpawn
        }
    }

    # Move back
    g
    #     1         2            3                4          5
    s/\([^ ]*\) \([^ ]*\) \(.*Board:[^ ]*\)\1\([pqkinr]\)\([^ ]*\)\2./\3\2\4\5\1 /

    # Check to see if the pawn was on the 8th row, if so, it is necessary to convert
    # it to the queen (of course can be only one such pawn)
    :move-white::checkpawn
    s/\([a-h]8\)p/\1q/

    b @
}

# Number of remaining pieces
/@count-pieces()/ {
    h
    # Remove all but the board
    s/.*Board://
    s/ .*$//
    # Remove all but the white pieces
    s/[^pqkinrPQKINR]//g
    # Believe
    s/./1/g
    # Return stack commands
    G
    # G came after a line feed, remove it
    s/\n/ /

    b @
}

#Estimator available black pieces
/@estimate-black-pieces()/ {
    # Pawn - 100, elephant and horse - 300, Rook - 500, Queen - 900, King - 9000,
    # else 9000 - psevdofigura black to avoid overflow = 21900

    # Cleaning all the excess
    h; s/.*Board://; s/ .*$//

    # Remove all but counted figures
    s/[^PINRQK]//g

    # Count the number of * coefficient figure (queen Q - the only one, but may appear in another pawn)
    s/P/1/g; s/[NI]/111/g; s/R/11111/g; s/Q/111111111/g
    # King put forward to psevdofigure
    s/^\(.*\)K/HHHHHHHHH\1/
    # Black psevdofigura
    s/^/HHHHHHHHH/

    # Grouping hundreds of thousands of
    s/1111111111/H/g; s/HHHHHHHHHH/T/g

    # Insert a colon
    s/\(.\)\1*/&:/g
    # If there are no units to the end - another colon
    /1/ ! s/$/:/
    # If not hundreds, up to the last units or colon - even colon
    /H/ ! s/[1:]/:&/

    y/HT/11/; s/$/:B/
    # Add to the saved stack
    G; s/\n/ /

    b @
}

# Estimator available white pieces
/@estimate-white-pieces()/ {
    # Pawn - 100, elephant and horse - 300, Rook - 500, Queen - 900, King - 9000

    # Cleaning all the excess
    h; s/.*Board://; s/ .*$//
    # Remove all but counted figures
    s/[^pinrqk]//g
    # Count the number of * coefficient figure (queen q - the only one, but may appear in another pawn)
    s/p/1/g; s/[ni]/111/g; s/r/11111/g; s/q/111111111/g

    # King put forward
    s/^\(.*\)k/HHHHHHHHH\1/

    # Grouping hundreds of thousands of
    s/1111111111/H/g; s/HHHHHHHHHH/T/g

    # Insert a colon
    s/\(.\)\1*/&:/g
    # If there are no units to the end - another colon
    /1/ ! s/$/:/
    # If not hundreds, up to the last units or colon - even colon
    /H/ ! s/[1:]/:&/

    y/HT/11/; s/$/:B/
    # Add to the saved stack
    G; s/\n/ /

    b @
}

# For debugging output of the current stack
/@log()/ {
    l
    q
}

/@l()/ {
    h
    l
    w chess.log
    g
}

# Estimator for the position of black pawns
/@estimate-black-pawn()/ {
    # Cleaning all the excess
    h; s/.*Board://; s/ .*$//
    # Leaving only black and white pawns, re-encoding them into understandable coordinates
    # Now pawns written like this: XTsvet (where Color - Black or White), separated by a space
    s/[a-h][1-8][^Pp]//g; y/Ppabcdefgh/BW12345678/; s/\([1-8]\)[1-8]/ \1/g

    # → Step 1
    # Find the black pawns on the vertical who are white, whites are the coordinates
    # Always after the coordinates of black
    :estimate-black-pawn::black
    /\([1-8]\)B\(.*\1\)W/ {
        s//\1b\2W/
        b estimate-black-pawn::black
    }

    # → Step 2.1
    # Translate the coordinates of a sequence of length X
    :estimate-black-pawn::x
    /[2-8]/ {
        s/[2-8]/1&/g
        y/2345678/1234567/

        b estimate-black-pawn::x
    }

    # → Step 2.2
    # Find a pawn, not screened out in Phase 1, in which the adjacent line on the left are white
    :estimate-black-pawn::left
    /\( 1*\)B\(.*\11\)W/ {
        s//\1b\2W/
        b estimate-black-pawn::left
    }

    # → Step 2.3
    # Find a pawn, not screened out in Phase 2, in which on the next line on the right are white
    :estimate-black-pawn::right
    / 1\(1*\)B\(.* \1\)W/ {
        s// 1\1b\2W/
        b estimate-black-pawn::right
    }

    # As a result, W - white pawns, b - black, B - free black pawns
    # Get rid of non-free and white pawns    s/ [^ ]*[Wb]//g

    # → Step 3
    # Consider the cost of the free black pawns
    s/ 1B//; s/ 11B/ ::11111B/; s/ 111B/ :1:B/; s/ 1111B/ :1:11111B/; s/ 11111B/ :11:B/
    s/ 111111B/ :111:B/; s/ 1111111B/ 1:1111:B/; s/ 11111111B//

    # → Step 4
    # Saves received, ship stack back, cut out the board and leave the black pawns with coordinates
    G; h; s/.*Board://; s/ .*$//; s/[a-h][1-8][^p]//g

    # Evaluate the positions of all the pawns
    s/.[81]p/::B/g

    s/[abcfgh]7p/::1111B/g; s/[de]7p/::B/g

    s/[ah][65]p/::111111B/g; s/[bg][65]p/::11111111B/g; s/[cf]6p/::11B/g; s/[de]6p/:1:B/g

    s/[bg]5p/:1:11B/g; s/[cf]5p/:1:111111B/g; s/[de]5p/:11:1111B/g

    s/[ah]4p/::11111111B/g; s/[bg]4p/:1:11B/g; s/[cf]4p/:1:111111B/g; s/[de]4p/:11:1111B/g

    s/[ah][32]p/:1:11B/g; s/[bg][32]p/:1:111111B/g; s/[cf][32]p/:11:1111B/g; s/[de][32]p/:111:11B/g

    # Insert spaces between the estimates
    s/B/& /g; s/^/ /

    # → Step 5
    # Return the stored evaluation, we remove the remnants of the stack
    G; s/\n\(.*\)\n.*/ \1/

    # Add to the saved stack, we clean our garbage, which we piled up -
    # Second line there are estimates
    G; s/\n.*\n/ /

    b @
}

# Estimator for the position of the black king
/@estimate-black-king()/ {
    h; s/.*Board://; s/ .*$//

    # Allocate King
    s/[a-h][1-8][^K]//g

    # Consider the weight (the matrix of the game)
    s/[ah][18]./::/
    
    s/[de][54]./:111:111111/
    
    s/[cf][54]./:111:/; s/[de][63]./:111:/

    s/[bg][54]./:11:1111/; s/[de][72]./:11:1111/; s/[cf][63]./:11:1111/

    s/[de][18]./:1:11111111/; s/[ah][54]./:1:11111111/; s/[cf][72]./:1:11111111/; s/[bg][63]./:1:11111111/

    s/[bg][72]./:1:11/; s/[ah][63]./:1:11/; s/[cf][81]./:1:11/

    s/[a-h][1-9]./::111111/

    G; s/\n/B /

    b @
}

# Estimator for the position of the black knight
/@estimate-black-knight()/ {
    h; s/.*Board://; s/ .*$//

    # Select horses
    s/[a-h][1-8][^N]//g

    # Believe their weight
    s/[ah][18]./::B/g
    
    s/[de][54]./:111:11B/g
    
    s/[cf][54]./:11:11111111B/g; s/[de][63]./:11:11111111B/g

    s/[cf][36]./:11:1111B/g

    s/[bg][54]./:11:B/g; s/[de][72]./:11:B/g; s/[cf][63]./:11:B/g

    s/[de][18]./:1:B/g; s/[ah][54]./:1:B/g; s/[cf][72]./:1:B/g; s/[bg][63]./:1:B/g

    s/[bg][72]./::11111111B/g; s/[ah][63]./::11111111B/g; s/[cf][81]./::11111111B/g

    s/[a-h][1-9]./::1111B/g

    s/B/& /g; G; s/ *\n/ /

    b @
}

# Estimator for the position of the black bishop
/@estimate-black-bishop()/ {
    h; s/.*Board://; s/ .*$//

    # Highlight of elephants
    s/[a-h][1-8][^I]//g

    # Believe their weight
    s/[a-h][81]./:::1:1111B/g; s/[ah][1-8]./:::1:1111B/g

    s/[bg][72]./:::11:11B/g; s/[c-f][3-6]/:::11:11B/g

    s/[a-h][1-9]./:::1:11111111B/g

    s/B/& /; G; s/\n/ /

    b @
}

# Estimator for the position of the black queen (queen)
/@estimate-black-queen()/ {
    h; s/.*Board://; s/ .*$//

    # Distinguish the enemy king and queen
    s/[a-h][1-8][^Qk]//g

    # If one of the figures on the field not return
    /Q/,/k/ ! {
        g; b @
    }

    # King pushed forward
    s/\(.*\)\(..k\)\(.*\)/\2\1\3/

    # If we have a second queen, then put it through a separator
    # In front of him and sculpt King
    s/\(..k\)\(..Q\)\(..Q\)/ \1\2\# \1\3/

    # Remove the figure, the coordinates of the numbers, we arrange spaces around numbers to limit
    y/abcdefgh/12345678/; s/\([1-9]\)\(.\)./\1 \2 /g

    #  Group the coordinates, you get X1 X2 Y1 Y2 (on two lines)
    # We captured by three values, but will not confusion as use spaces,
    # And between pairs of numbers - "lattice"
    s/\([1-8]\) \([1-8]\) \([1-8]\)/\1 \3 \2/g

    # Translate the coordinates of a sequence of length coordinate values
    :estimate-black-queen::xy
    /[2-8]/ {
        s/[2-8]/1&/g
        y/2345678/1234567/

        b estimate-black-queen::xy
    }

    # Should be able to (8 - the greatest distance):
    # 8 - (XM-Xm) + 8 - (YM-Ym) => 16-XM+Xm-YM+Ym => 16-(XM+YM)+(Xm+Ym)

    # Sort - a large coordinate ahead
    s/ \(11*\) \(\111*\)/ \2 \1/g

    #4 numbers obtained for each pair of figures: XM Xm YM Ym, you need to put them in pairs,
    # Second deuce portable ahead and add up to 16
    s/\(11*\) \(11*\) \(11*\) \(11*\)/1111111111111111\2\4 \1\3/g

    # Subtract the second coordinate of the first
    s/\(11*\)\(1*\) \1/\2/g

    # Ciesla to combine the two figures
    s/[# ]//g

    # Grouping hundreds of thousands of
    s/1111111111/H/g; s/HHHHHHHHHH/T/g

    # Insert a colon
    s/\(.\)\1*/&:/g
    # If there are no units to the end - another colon
    /1/ ! s/$/:/
    # If not hundreds, up to the last units or colon - even colon
    /H/ ! s/[1:]/:&/

    y/HT/11/

    G; s/\n/B /

    b @
}

# Sum up the numbers on the stack until it encounters a word ARRAY
/@sum-array()/ {
    h
    /ARRAY.*/ {
        s///
        s/$/ ::::::S/

        :sum-array::shift
        /[1:][1:]*B/ {
            # Addition of discharge
            :sum-array::sum
            /11*B/ {
                s/\(11*\)B\(.*\)\(1*\)S/B\2\1\3S/
                s/:1111111111\(1*\)S/1:\1S/

                b sum-array::sum
            }

            # Shift discharge
            s/:B/B/g; s/:\(1*\)S/S \1:/

            b sum-array::shift
        }

        s/:\(1*\)S/S \1:/; s/[^1:]//g
        G; s/ARRAY/#&/; s/:\n.*#ARRAY */B /
    }

    b @
}

# Subtraction of numbers on the stack from the first, until a word ARRAY
/@sub-array()/ {
    / *ARRAY.*/ {
        h; s///
        # Is replaced with the first of a letter to distinguish
        s/B */M /

        # In front of each number must stop
        s/^/:/; s/ / :/g

        # From the first day of shooting LSB
        s/:\(1*\)\(M.*\)/:\2 :\1#S/
        :sub-array::loop

        # Now go through the junior ranks of the remaining numbers
        :sub-array::minus
        /:\(11*\)\(B.*\) :\1\(1*\)#S/ {
            s//:\2 :\3#S/
            b sub-array::minus
        }

        # Significant bits to subtract left?
        /:11*B/ {
            # Transfer the bits to be subtracted Jr.
            :sub-array::cy
            # If there is nothing to carry, everything turns out the number is less than zero,
            # Return a zero exit
            /1.*M/ ! {
                s/.*/:::B/
                b sub-array::end
            }

            s/\(.*\)1:\(.*M\)/\1:1111111111\2/

            /1M/ ! b sub-array::cy

            # Add to the subtrahend
            s/:\(1*\)\(M.*\) \(:.*\)#S/:\2 \3\1#S/

            b sub-array::minus
        }

        # Cut away all the empty category now, those who do not have any left, remove
        s/:\([BM]\)/\1/g; s/ :*B//g

        # Take the next digit
        s/:\(1*\)\(M.*\) \([^ ]*\)#S/:\2 :\1#S \3S/

        # If there is that subtract, subtract
        /B/ b sub-array::loop

        # Remove superfluous normaliziruem
        s/[#MS ]//g; s/://

        :sub-array::end

        G; s/ARRAY/#&/; s/\n.*#ARRAY */B /
    }

    b @
}

# Selection of this figure (returns a string)
# XYF__XYF__ where F - the name of the figure, __ - a place in the enumeration position
/@select-figures(.)/ {
    h
    # Remove all unnecessary data from the parameter marker mark
    s/@select-figures(\(.\))\(.*\)/\2 Selected:\1/
    s/.*Board://
    s/ .*Selected:/ Selected:/

    # Highlight of the boards that have user
    :select-figures::select
    /\([a-h][0-9]\)\(.\)\(.* Selected:\2\)/ {
        s//\3\1\2__/
        b select-figures::select
    }

    # Remove the marker and mutilated board
    s/.*Selected:.//

    # Return stack ago
    G; s/\n/END /
    b @
}

/@iter-knight()/ {
    # Remove the horse that finished the course
    s/^...XX//
    # Exit if there is nothing to go
    /^END/ b @

    # Select the first horse
    h; s/\(.....\).*/\1/

    # Encoding moves: __ - has not been made, XX - made all possible
    # Left, Down, Up, Right, first written in the course of two cells, for example:
    # LU - left into two, one on top

    /__/ {
        s//LU/
        # Shift the coordinate of X-2, Y+1, 0 - a sign that progress is impossible
        y/abcdefgh/00abcdef/
        y/12345678/23456780/

        b common::go
    }

    /LU/ {
        s//UL/
        # X-1, Y+2
        y/abcdefgh/0abcdefg/
        y/12345678/34567800/

        b common::go
    }

    /UL/ {
        s//UR/
        # X+1, Y+2
        y/abcdefgh/bcdefgh0/
        y/12345678/34567800/

        b common::go
    }

    /UR/ {
        s//RU/
        # X+2, Y+1
        y/abcdefgh/cdefgh00/
        y/12345678/23456780/

        b common::go
    }

    /RU/ {
        s//RD/
        # X+2, Y-1
        y/abcdefgh/cdefgh00/
        y/12345678/01234567/

        b common::go
    }

    /RD/ {
        s//DR/
        # X+1, Y-2
        y/abcdefgh/bcdefgh0/
        y/12345678/00123456/

        b common::go
    }

    /DR/ {
        s//DL/
        # X-1, Y-2
        y/abcdefgh/0abcdefg/
        y/12345678/00123456/

        b common::go
    }

    /DL/ {
        s//XX/
        # X-2, Y-1
        y/abcdefgh/00abcdef/
        y/12345678/01234567/

        b common::go
    }

    b common::go
}

# King goes to one cell anywhere N
# Code to the cardinal W E
# __ → NN → EN → EE → SE → SS → WS → WW → NW → XX      S
/@iter-king()/ {
    # Remove the king, who finished the course
    s/^...XX//
    # Exit if there is nothing to go
    /^END/ b @

    # Highlight of the first (and only) King
    h; s/\(.....\).*/\1/

    # Change the current selected position to the next
    s/$/ __NNENEESESSWSWWNWXX/
    s/\(..\) \(.*\1\)\(..\)/\3 \2\3/; s/ .*//

    # Replace koordinty, according to the selected position

    # Y+1
    /N/ y/12345678/23456780/
    # Y-1
    /S/ y/12345678/01234567/
    # X-1
    /W/ y/abcdefgh/0abcdefg/
    # X+1
    /E/ y/abcdefgh/bcdefgh0/

    b common::go
}

# Rook goes vertically or horizontally on any number of turns,      N
# If no one is on the way W     E
# Walks starting from the current position to the specified direction   S
/@iter-rook()/ {
    # Remove the boat, which finished the course
    s/^...XX//
    # Exit if there is nothing to go
    /^END/ b @

    # Select the first boat
    h; s/\(.....\).*/\1/

    # Our first direction - east, then go to the following areas
    /__/ s/\(\(.\).*\)__/\1E\2/
    /E0/ s/\(\(.\).*\)E./\1W\2/
    /W0/ s/\(.\(.\).*\)W./\1N\2/
    /N0/ s/\(.\(.\).*\)N./\1S\2/
    s/S0/XX/

    /E/ y/abcdefgh/bcdefgh0/
    /W/ y/abcdefgh/0abcdefg/
    
    /S/ y/12345678/01234567/
    /N/ y/12345678/23456780/

    # Rewrite the state in the coordinates of the selected shape as the figure of the progress will be gone
    /[SN]/ s/\(.\).\(..\(.\)\)/\1\3\2/
    /[WE]/ s/.\(...\(.\)\)/\2\1/

    /[0X]/ ! {
        # Return stack, remove everything after and before the board on the stack
        s/$/#/; G; s/\n.*\(Board:[^ ]*\).*/\1/

        # If the selected position psevdokorol, more on what we do not pay attention
        /^\(..\).*\1z/ ! {
            # Check, whether or not in the selected position has its own shape, if necessary, stop scan immediately
            s/^\(..\)R\(.\).*\(\1[PQKINR]\).*/00R\20#\3/
            s/^\(..\)r\(.\).*\(\1[pqkinr]\).*/00r\20#\3/

            # If there is an alien figure, then you can move and go for it - there is no
            s/^\(..\)R\(.\).*\(\1[pqkinr]\).*/\1R\20#\3/
            s/^\(..\)r\(.\).*\(\1[PQKINR]\).*/\1r\20#\3/
        }
        s/#.*//
    }

    b common::go
}

# Elephant (the officer) runs diagonally, provided that the path is clear figures
# Walk starting from the current location, refer to the directions: ↘ (v), ↖ (^), ↗ (+), ↙ (-)
# Attempt to use Unicode here periodically led to the departure sed utility
# Symbol stroke looks like: ↙8 - moved away from the current position to the 8 steps
/@iter-bishop()/ {
    # Remove the elephant, who finished the course
    s/^...XX//
    # Exit if there is nothing to go
    /^END/ b @

    # Highlight of the first elephant
    h; s/\(.....\).*/\1/

    # If you must move to the next direction
    /^....[0_]/ {
        # Change the current selected position to the next
        s/$/ __v①v0^①^0+①+0-①-0XX/
        s/\(..\) \(.*\1\)\(..\)/\3 \2\3/; s/ .*//
        b iter-bishop::changed
    }
    # Else going on in the chosen direction
    y/①②③④⑤⑥⑦⑧/②③④⑤⑥⑦⑧0/
    :iter-bishop::changed

    # Translate the decimal number to a number of arrows, while maintaining the current state 
    H
    :iter-bishop::tobin
    /[0X]/ ! {
        y/①②③④⑤⑥⑦⑧/0①②③④⑤⑥⑦/
        s/.$/&→/
        b iter-bishop::tobin
    }

    :iter-bishop::minus
    # Compute the coordinates
    /→/ {
        s///

        # X-1
        /[\-\^]/ y/abcdefgh/0abcdefg/
        # X+1
        /[+v]/ y/abcdefgh/bcdefgh0/
        # Y-1
        /[\-v]/ y/12345678/01234567/
        # Y+1
        /[+\^]/ y/12345678/23456780/

        b iter-bishop::minus
    }

    # Returns the same state as it was, we now have: the stack, \n, the initial state, \n, calculated
    # With a broken number stroke

    # We clean the stack extra data - send them to the repository
    H; x; s/\n/#/; h; s/#.*//

    # Swap, now in storage, we clean the stack, and we have: the original \n spoiled
    x; s/.*#//

    # Transfer the coordinates of spoiled the home (the RAR, we calculated the coordinates of course)
    # Destroy the tainted state
    s/..\(.*\)\n\(..\).*/\2\1/

    /[0X]/ ! {
        # Return stack, remove everything after and before the board on the stack
        s/$/#/; G; s/\n.*\(Board:[^ ]*\).*/\1/
        # If psevdokorol selected position, no matter what we do not pay more attention
        /^\(..\).*\1z/ ! {
            # Check, whether or not in the selected position has its own shape, if necessary, stop scan immediately
            s/^\(..\)I\(.\).*\(\1[PQKINR]\).*/00I\20#\3/
            s/^\(..\)i\(.\).*\(\1[pqkinr]\).*/00i\20#\3/

            # If there is an alien figure, then you can move and go for it - there is no
            s/^\(..\)I\(.\).*\(\1[pqkinr]\).*/\1I\20#\3/
            s/^\(..\)i\(.\).*\(\1[PQKINR]\).*/\1i\20#\3/
        }
        s/#.*//
    }

    b common::go
}


# Black pawns are able to walk on 4m areas:
# 1) for 1 turn (DO, Direction One)
# 2) by 2 until the middle of the board, if the field in front of it is not occupied (DT, Direction Two)
# 3) down the left, if there is an alien figure (DL, Direction Left)
# 4) down to the right if there is an alien figure (DR, Direction Right)
# In addition, a pawn, reaching the edge of the board has the right to turn into any shape (except the king)
/@iter-pawn()/ {
    # Remove the pawn who finished the course
    s/^...XX//
    # Exit if there is nothing to go
    /^END/ b @

    # Select the first pawn
    h; s/\(.....\).*/\1/

    # See if the black pawn on the seventh horizontally, you can make a long course, or do short
    /^\(.\)7P__/ {
        # In fact, the very course
        s//\15PDT/
        b iter-pawn::checkpiece
    }

    # See if the white pawn on the second rank, it can be a long course, or do short
    /^\(.\)2p__/ {
        # In fact, the very course
        s//\14pDT/
        b iter-pawn::checkpiece
    }

    # Else, we move in directions
    s/$/ __DODLDRXXDTDO/
    s/\(..\) \(.*\1\)\(..\)/\3 \2\3/; s/ .*//

    /D/ y/12345678/01234567/

    /[RL]/ {
        /L/ y/abcdefgh/0abcdefg/
        /R/ y/abcdefgh/bcdefgh0/
        # For these moves is absolutely necessary alien figure in the cell where we go
        # Return the board
        G; s/\n.*\(Board:[^ ]*\).*/ \1/

        # Check, if not, then do not go there
        # z - «ghost king" fake web form to test the Shah and the mat
        /^\(..\)P.*\1[pqkinrz]/ ! s/^../00/
        /^\(..\)p.*\1[PQKINRz]/ ! s/^../00/

        # Clean up after a board
        s/ *Board:.*//

        b common::go
    }

    :iter-pawn::checkpiece
    # Pawn can not walk straight, if there is a figure
    # Return the board
    G; s/\n.*\(Board:[^ ]*\).*/ \1/

    # If psevdokorol on the way, we do not pay attention to him
    /^\(..\).*\1z/ ! {
        # Check if there is a figure, either, if there is, we can not go
        /^\(..\).*\1[pqkinrPQKINR]/ {
            s/^../00/
        }
    }

    # Clean up after a board
    s/ *Board:.*//

    b common::go
}

# Queen (Queen) runs diagonally, horizontally, in a vertical, provided that the path is clear figures
# Walk starting from the current location, refer to the directions: ↘ (v), ↖ (^), ↗ (+), ↙ (-), ← (<), → (>), ↓ (,), ↑ (')
# Attempt to use Unicode here periodically led to the departure sed utility
# Symbol stroke looks like: ↙ 8 - moved away from the current position to the 8 steps
/@iter-queen()/ {
    # Remove the elephant, who finished the course
    s/^...XX//
    # Exit if there is nothing to go
    /^END/ b @

    # Highlight of the first elephant
    h; s/\(.....\).*/\1/

    # If you must move to the next direction
    /^....[0_]/ {
        # Change the current selected position to the next
        s/$/ __v①v0^①^0+①+0-①-0<①<0>①>0,①,0'①'0XX/
        s/\(..\) \(.*\1\)\(..\)/\3 \2\3/; s/ .*//
        b iter-queen::changed
    }
    # Else going on in the chosen direction
    y/①②③④⑤⑥⑦⑧/②③④⑤⑥⑦⑧0/
    :iter-queen::changed

    # Translate the decimal number to a number of arrows, while maintaining the current state 
    H
    :iter-queen::tobin
    /[0X]/ ! {
        y/①②③④⑤⑥⑦⑧/0①②③④⑤⑥⑦/
        s/.$/&→/
        b iter-queen::tobin
    }

    :iter-queen::minus
    # Compute the coordinates
    /→/ {
        s///

        # X-1
        /[\-\^<]/ y/abcdefgh/0abcdefg/
        # X+1
        /[+v>]/ y/abcdefgh/bcdefgh0/
        # Y-1
        /[\-v,]/ y/12345678/01234567/
        # Y+1
        /[+\^\']/ y/12345678/23456780/

        b iter-queen::minus
    }

    # Returns the same state as it was, we now have: the stack, \n, the initial state, \n, calculated
    # With a broken number stroke

    # We clean the stack extra data - send them to the repository
    H; x; s/\n/#/; h; s/#.*//

    # Swap, now in storage, we clean the stack, and we have: the original \n spoiled
    x; s/.*#//

    # Transfer the coordinates of spoiled the home (the RAR, we calculated the coordinates of course)
    # Destroy the tainted state
    s/..\(.*\)\n\(..\).*/\2\1/

    /[0X]/ ! {
        # Return stack, remove everything after and before the board on the stack
        s/$/#/; G; s/\n.*\(Board:[^ ]*\).*/\1/

        # If this position is psevdofigura, Spahr more
        /^\(..\)[Qq].*\1z/ ! {
            # Check, whether or not in the selected position has its own shape, if necessary, stop scan immediately
            s/^\(..\)Q\(.\).*\(\1[PQKINR]\).*/00Q\20#\3/
            s/^\(..\)q\(.\).*\(\1[pqkinr]\).*/00q\20#\3/

            # If there is an alien figure, then you can move and go for it - there is no
            s/^\(..\)Q\(.\).*\(\1[pqkinr]\).*/\1Q\20#\3/
            s/^\(..\)q\(.\).*\(\1[PQKINR]\).*/\1q\20#\3/
        }
        s/#.*//
    }

    b common::go
}

# Move the position and the amount at the end of the stack,
# We shift the position of the counter figures
/@store-iter()/ {
    # If it was impossible to go clean out the trash
    /^[^ ]*B  *0..../ {
        s///
        b @
    }

    # (Position estimation) (figure run) counter position (the current figure), all the rest →
    # Current figure, the rest of the sum, the course from the course where →
    s/\([^ ]*\) *\(...\)..\(...\)\([^ ]*END *.*\)/\3\4 \1(\3→\2)/
    b @
}

# Move pozitsiyuv end of the stack (without the weight of the body)
# We shift the position of the counter figures
/@store-only-iter()/ {
    # If it was impossible to go clean out the trash
    /^0..../ {
        s///
        b @
    }

    # (Speed ​​figure), the counter position (the current figure), all the rest →
    # Current figure, everything else, Move: move to
    s/^\(...\)..\(...\)\([^ ]*END *.*\)/\2\3 Move:\1/
    b @
}

# Calculate the best move of the above
/@find-best-move()/ {
    # If the estimates (with more than one)?
    /[1:][1:]*B/ {
        h
        # Remove unnecessary
        s//Moves:&/; s/.*Moves:/ /

        # Normalized number
        s/ / :::::/g; s/ :*\(1*:1*:1*:1*:1*:1*B\)/ \1/g

        y/B/:/

        :find-best-move::cut
        # See if there is a number with a non significant bit
        / 1/ {
            # If so, remove those who feared before discharge empty
            s/ :[^ ]*//g
            # Now cut off from each one digit at a senior level
            s/ 1/ /g
            b find-best-move::cut
        }
        # Move through the discharge, is there still a number of bits?
        s/ :/ /g
        /:/ b find-best-move::cut

        # If there were a few highs, leaving only the first
        s/^ *\([^ ]*\).*/\1/
        # Return the data to the main stack
        G; s/\n/ /

        # Mark the place where we find estimates
        s/[1:][1:]*B/Moves: &/

        # Now, if the stack on entry form (XYF → XYF), appends it to the evaluation of
        s/^\(([^)]*\)\(.* \)\([1:][1:]*B\1\)/\3\2/

        # Remove unnecessary now estimates
        s/ *Moves:.*//
        # Now on the stack entry form Est (XYF → XYF), or such records were not (if it was not possible moves in the figure)
    }

    b @
}

# Black's move, according to the data found
/@move-black()/ {
    # Remove from a position where we will walk a figure that would have stood there, remove it
    s/\([1:][1:]*B(\(..\)\(.\)→\(..\).).*Board:.*\)\4./\1\2 /
    # Change the coordinates of the pieces, which go
    s/[1:][1:]*B(\(..\)\(.\)→\(..\).) *\(.*Board:.*\)\1\2/\4\3\2/
    # If it pawn on the first rank, makes her his queen, it can only be one
    s/\([a-h]1\)P/\1Q/

    b @
}

# Create a second board and create fake kings in it, in the positions where the king could go to
/@make-fake-kings()/ {
    # Copy the King with the coordinate at the end of
    s/\(...\)[^ ]* *\(.*\)/\2 King:\1__/

    h

    :make-fake-kings::loop
    /XX/ ! {
        # Remove all but the king
        s/.*King:\(.....\).*/\1/

        # Change the current selected position to the next (HR - turn on the spot)
        s/$/ __NNENEESESSWSWWNWXX/
        s/\(..\) [^ ]*\1\(..\).*/\2/

        # Replace koordinty, according to the selected position

        # Y+1
        /N/ y/12345678/23456780/
        # Y-1
        /S/ y/12345678/01234567/
        # X-1
        /W/ y/abcdefgh/0abcdefg/
        # X+1
        /E/ y/abcdefgh/bcdefgh0/

        H; g

        # Rewrite the selected position itself in the position of the first figure (the figure where the king is now)
        s/\(King:...\)..\(.*..[kK]\(..\)\)$/\1\3\2/

        #  On the second board in the specified position (if it is not worth its same figure, you need to put
        # Pseudo-King (z)
        /.*\([^0][^0][kK]\)..$/ {
            x
            s//\1 &/

            # Put an end to the white board psevdokorolya ...
            /^\(..\)k \(Board:[^ ]*\)\1[^pqinrk]/ s/^\(..\) Board:[^ ]*/&\1z/
            # Black psevodokorolya
            /^\(..\)K \(Board:[^ ]*\)\1[^PQKINR]/ s/^\(..\) Board:[^ ]*/&\1z/
            # (In the place where we supposedly put psevdokorolya should not stand his own figure)
            # If it was not there, but now the two cells have the same coordinate

            # Remove the coordinates of the King at the top of the stack, we have set for inspections
            s/^... //

            x
        }

        b make-fake-kings::loop
    }

    # Replace newlines with spaces in the stack King
    s/\n/ /g  

    b @
}

# Check and checkmate the king Shah
/@check-mate()/ {
    # First, we clean off the board psevdokoroley
    s/\(Board:[^ z]*\)..z[^ ]*/\1/

    # Second, keep a stack and leave only the moves and the possible location of the Kings
    h; s/.*King:\(..\(.\)\)/\2ing:\1/

    # There is a threat to the king?
    /[Kk]ing:\(..\).*Move:\1/ {
         # This is the Shah, now we have to loop through all the items and see if there where the king to go,
         # If not, it mat

         :check-mate::loop
         /\(..\)[kK].. *\(.*\)Move:\1./ {
            s//\2/

            b check-mate::loop
         }

         /^k/ {
             # Let's see whether there was progress King
             /[^0][^0]k[^X0][^X0]/ ! {
                i\
                You checkmate, you lose

                q
             }
             i\
             You Shah

             b check-mate::cleanup
        }

        # Let's see whether there was progress King
        /[^0][^0]K[^X0][^X0]/ ! {
            i\
            I checkmate, I lost

            q
        }

        # We clean the moves of other figures
        s/ *Move:.*//

        # Shapes move into the first king of the side
        s/.*\([^0 ][^0 ]K\)[^0 ][^0 ].*\([^ ][^ ]K\)XX.*/(\2→\1)/
        
        # Put it on top of the stack
        H; x; s/\(.*\)\n\(([^)]*)\)/1B\2 \1/; x

        b check-mate::cleanup
    }

    # Put a label that moves is not required
    x; s/^/END /; x

    :check-mate::cleanup
    # Restore the stack and remove it from unnecessary

    g; s/ *King:.*//
    b @
}

# Possible on the progress of black white king ate?
/@check-white-king-exists()/ {
    /Board:[^ ]*k/ ! {
        i\
        You checkmate, you lose

        q  
    }

    b @
}

# Possible on the course of the white black king ate?
/@check-black-king-exists()/ {
    /Board:[^ ]*K/ ! {
        i\
        I checkmate, I lost

        q  
    }

    b @
}

/@ *$/ {
    q
}

b @

# Walking figure
:common::go
# Return stack
G; s/\n//
# Rewrite where we used to go to the current figure
# XYFPPXYF.. → XYF__XYPP
s/\(...\)\(..\)\(...\)../\1__\3\2/

# Data about the shapes and the board, remove the rest
s/^\([^ ]*END\).*\(Board:[^ ]*\).*/\1 \2/

# If the field is expected to phantom king, that we do not pay attention to the rest of
/^\(..\).*\1z/ ! {
    # Do not look at the proposed field of our own figures
    s/^\(..\)\([PQKINR].*\1[PQKINR]\)/00\2/
    s/^\(..\)\([pqkinr].*\1[pqkinr]\)/00\2/
}

# If the second coordinate zero, put a zero in the first
s/^.0/00/

# If you can go here, go
/^0/ ! {
    # XY XY stroke current figure, always walk on the far board
    # Change the coordinates of the figure that walks
    s/\(\(...\)__\(...\).*Board:.*\)\3/\1\2/

    # Change the coordinates of the place where we go, eating on the way figure
    s/\(..\)\(.__\)\(..\)\(.*Board:.*\)\1./\1\2\3\4\3 /

    # If it pawn on the first rank, change it to the queen, it can be
    # Only one and only one board
    s/\([a-h]1\)P/\1Q/
}

# Return stack, removing it from the second (remaining) stack isolated figures
G; s/\n[^ ]* */ /

# Adding and changing our last board seats
s/\(Board:[^ ]*\)\(.*\)\(Board:[^ ]*\)/\3\2\1/

b @