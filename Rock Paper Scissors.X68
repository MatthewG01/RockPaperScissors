*-----------------------------------------------------------
* Title      : Rock Paper Scissors
* Written by : Matthew Gazzard
* Date       : 03/04/2021
* Description: A program that allows a user to play a game of rock, paper, scissors against the computer
*-----------------------------------------------------------
            ORG    $1000

start:      move.b  #14, d0
            lea     title, a1          ; display program title
            trap    #15
            
            move.b  #14, d0            ; display welcome message
            lea     welcomeMessage, a1
            trap    #15
* Put program code here
challengerName:        
            move.b  #14, d0            ; ask challenger name
            lea     askName, a1
            trap    #15
            
            lea     playerName, a1
            move.b  #2, d0              ; store challenger name 
            trap    #15

checkName   move.b  #14, d0
            lea     playerName, a1
            trap    #15
            
            
            move.b  #14, d0             ; confirm challenger name
            lea     confirmName, a1
            trap    #15
            
            move.b  #5, d0
            trap    #15
            
            cmp.b   #$59, d1            ; begin game if player says entered name is correct  
            beq     beginGame
            
            cmp.b   #$4E, d1            ; if player name was not correct, branch back to ask name again
            beq     challengerName
            
            move.b  #14, d0
            lea     invalidResponse, a1 ; if player enters an invalid character (not Y or N), a message displays warning them and player is asked to confirm name again
            trap    #15
            bra     checkName
                               
            
beginGame   move.w #$FF00,d1            ; clears the console screen
            move.b #11,d0
            trap #15
            
            move.b  #14, d0
            lea     playerName, a1      ; outputs player name to console
            trap    #15
            
            move.b  #14, d0
            lea     challengeMessage, a1  ; outputs challenge message on the same line as player name to form a complete sentence
            trap    #15
            
            move.b	#8,d0               ; generate computer move by using computer time to generate a random number. (Adapted from Tutorial 2 code from Lab 8) 
	        trap	#15
	        and.l	#$FFFF,d1	        ; prevent overflow in divu 
	        divu	#3,d1	            ; time count / 3
	        swap	d1	                ; swap upper and lower words of D1 to put remainder in low word
	        addq.w	#1,d1	            ; d1.w contains number from 1 to 3
	        move	d1,d2

playerMove  move.b  #14, d0             ; ask player to pick rock, paper or scissors
            lea     gameStart, a1       
            trap    #15
            
            move.b  #4, d0              ; read player choice
	        trap    #15
	        
	        cmpi    #3, d1              ; check to make sure number is not bigger than 3
	        bgt     invalid
	        
	        cmpi    #1, d1              ; check to make sure number is not smaller than 1
	        blt     invalid
	        
	        cmp     d2, d1              ; compare computer move to player move to determine if game is a draw
	        beq     draw
            
            cmpi    #1, d2              ; if computer picked rock, branch to compRock
            beq     compRock
            
            cmpi    #2, d2              ; if computer picked paper, branch to compPaper
            beq     compPaper
            
            cmpi    #3, d2              ; if computer picked scissors, branch to compSci
            beq     compSci
            
	        
	        
invalid     move.b  #14, d0             ; if player enters invalid number (anything that isn't 1, 2 or 3), a message displays warning them and player gets to choose again
            lea     invalidNumber, a1
            trap    #15
            
            bra     playerMove
            
compRock    move.b  #14, d0
            lea     opponentRock, a1    ; tells player computer chose rock
            trap    #15
            cmpi    #2, d1              
            beq     playerWin           ; if player chose paper, they win
            
            bra     playerLose          ; if player didn't chose paper, they lose

compPaper   move.b  #14, d0
            lea     opponentPaper, a1   ; tells player computer chose paper
            trap    #15
            cmpi    #3, d1              
            beq     playerWin           ; if player chose scissors, they win
            
            bra     playerLose          ; if player didn't chose scissors, they lose

compSci     move.b  #14, d0
            lea     opponentSci, a1     ; tells player computer chose scissors
            trap    #15
            cmpi    #1, d1              
            beq     playerWin           ; if player chose rock, they win
            
            bra     playerLose          ; if player didn't chose rock, they lose
            
playerWin   move.b  #14, d0
            lea     winnerAscii,a1      ; displays "WINNER" in ASCII
            trap    #15
            
            move.b  #14, d0             ; display game win message
            lea     gameWin, a1
            trap    #15
            
            bra     replay      

playerLose  move.b  #14, d0             ; displays "LOSER" in ASCII
            lea     loserAscii,a1
            trap    #15
            
            move.b  #14, d0             ; display game lose message
            lea     gameLose, a1
            trap    #15
            
            bra     replay

draw        move.b  #14, d0             ; displays "DRAW" in ASCII
            lea     drawAscii, a1
            trap    #15
            
            move.b  #14, d0             ; display game draw message
            lea     gameDraw, a1
            trap    #15
            
            bra     replay
            
replay      move.b  #14, d0             ; ask player if they wish to play again
            lea     playAgain, a1
            trap    #15
            move.b  #5, d0
            trap    #15
            
            cmp.b   #$59, d1            ; begin game if player wants to play again 
            beq     beginGame
            
            cmp.b   #$4E, d1            ; end game if player does not want to play again
            beq     end
            
            move.b  #14, d0
            lea     invalidResponse, a1 ; if player enters an invalid character (not Y or N), a message displays warning them and player is asked to confirm if they wish to play again
            trap    #15
            
            bra     replay

            SIMHALT             ; halt simulator

* Put variables and constants here
CR              EQU     $0D
LF              EQU     $0A

; ASCII art was generated using https://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20        

title           dc.b    ' ____   ___     __  __  _',CR,LF
                dc.b    '|    \ /   \   /  ]|  |/ ]',CR,LF
                dc.b    '|  D  )     | /  / |  . /',CR,LF
                dc.b    '|    /|  O  |/  /  |    \',CR,LF   
                dc.b    '|    \|     /   \_ |     \',CR,LF
                dc.b    '|  .  \     \     ||  .  |',CR,LF
                dc.b    '|__|\_|\___/ \____||__|\_|',CR,LF
                
                dc.b    '        ____   ____  ____   ___  ____',CR,LF  
                dc.b    '       |    \ /    ||    \ /  _]|    \',CR,LF 
                dc.b    '       |  o  )  o  ||  o  )  [_ |  D  )',CR,LF
                dc.b    '       |   _/|     ||   _/    _]|    / ',CR,LF
                dc.b    '       |  |  |  _  ||  | |   [_ |    \ ',CR,LF
                dc.b    '       |  |  |  |  ||  | |     ||  .  \',CR,LF
                dc.b    '       |__|  |__|__||__| |_____||__|\_|',CR,LF
                
                dc.b    '                 _____   __  ____  _____ _____  ___   ____    _____',CR,LF
                dc.b    '                / ___/  /  ]|    |/ ___// ___/ /   \ |    \  / ___/',CR,LF
                dc.b    '               (   \_  /  /  |  |(   \_(   \_ |     ||  D  )(   \_',CR,LF 
                dc.b    '                \__  |/  /   |  | \__  |\__  ||  O  ||    /  \__  |',CR,LF
                dc.b    '                /  \ /   \_  |  | /  \ |/  \ ||     ||    \  /  \ |',CR,LF
                dc.b    '                \    \     | |  | \    |\    ||     ||  .  \ \    |',CR,LF
                dc.b    '                 \___|\____||____| \___| \___| \___/ |__|\_|  \___|',CR,LF,CR,LF,0
                
winnerAscii     dc.b    ' __    __  ____  ____   ____     ___  ____',CR,LF  
                dc.b    '|  |__|  ||    ||    \ |    \   /  _]|    \',CR,LF 
                dc.b    '|  |  |  | |  | |  _  ||  _  | /  [_ |  D  )',CR,LF
                dc.b    '|  |  |  | |  | |  |  ||  |  ||    _]|    /',CR,LF 
                dc.b    '|  |  |  | |  | |  |  ||  |  ||   [_ |    \',CR,LF 
                dc.b    ' \      /  |  | |  |  ||  |  ||     ||  .  \',CR,LF
                dc.b    '  \_/\_/  |____||__|__||__|__||_____||__|\_|',CR,LF,0
                                            


loserAscii      dc.b    ' _       ___   _____   ___  ____',CR,LF  
                dc.b    '| |     /   \ / ___/  /  _]|    \',CR,LF 
                dc.b    '| |    |     (   \_  /  [_ |  D  )',CR,LF
                dc.b    '| |___ |  O  |\__  ||    _]|    /',CR,LF 
                dc.b    '|     ||     |/  \ ||   [_ |    \',CR,LF 
                dc.b    '|     ||     |\    ||     ||  .  \',CR,LF
                dc.b    '|_____| \___/  \___||_____||__|\_|',CR,LF,0
                                  


drawAscii       dc.b    ' ___    ____    ____  __    __',CR,LF 
                dc.b    '|   \  |    \  /    ||  |__|  |',CR,LF
                dc.b    '|    \ |  D  )|  o  ||  |  |  |',CR,LF
                dc.b    '|  D  ||    / |     ||  |  |  |',CR,LF
                dc.b    '|     ||    \ |  _  ||  |  |  |',CR,LF
                dc.b    '|     ||  .  \|  |  | \      /',CR,LF 
                dc.b    '|_____||__|\_||__|__|  \_/\_/',CR,LF,0  
                               
                
welcomeMessage  dc.b    'Hello and welcome challenger!',CR,LF,0
askName         dc.b    CR,LF,CR,LF,'What is your name?: ',0
confirmName     dc.b    ' is your name? Y/N?: ',0
enterNewName    dc.b    CR,LF,'Enter a new name: ',0
playerName      ds.b    32

challengeMessage  dc.b    ', I will destroy you. I am the best at Rock, Paper, Scissors!',0     
gameStart       dc.b    CR,LF,CR,LF,'FIGHT! 1 (Rock), 2 (Paper) or 3 (Scissors)?: ',0
opponentRock    dc.b    CR,LF,'Computer picked Rock!',CR,LF,CR,LF,0
opponentPaper   dc.b    CR,LF,'Computer picked Paper!',CR,LF,CR,LF,0
opponentSci     dc.b    CR,LF,'Computer picked Scissors!',CR,LF,CR,LF,0
gameWin         dc.b    CR,LF,CR,LF,'I cannot believe it! A mere human defeated me?! This cannot be!',0
gameLose        dc.b    CR,LF,CR,LF,'I win! You suck!',0
gameDraw        dc.b    CR,LF,'A Draw?! You are craftier than you look!',0
playAgain       dc.b    CR,LF,CR,LF,'Would you like to play again? Y/N?: ',0

invalidNumber   dc.b    CR,LF,'Try entering a valid number next time!',0
invalidResponse dc.b    CR,LF,'Try entering a valid character next time!',CR,LF,CR,LF,0

end             stop    #$2000   

            END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
