## Chess, written in sed utility

### Launch
sed -f chess.sed

### Instruction
To start press Enter. To exit, press q, then Enter.

To make a move, enter a space, then Enter, for example: e2 e4. You go white.

### Implemented:
1. positional evaluation by one stroke and assessment figures
2. Detection of the Shah and the mat
3. passed pawn is converted to a queen

### Not implemented:
1. Affairs (introduced in the rules in XIV-XV centuries.)
2. passant (introduced in the XV century)
3. detection stalemate
4. control over the correctness of the progress of human

-- 
Eugene Stepanishev
