dane    segment

polecenie       db      "Prosze wpisac cyfre w systemie szesnastkowym: $"
jeden		db	"    #   $", "   ##   $", "  # #   $", "    #   $", "    #   $", "    #   $", "  ####  $"
zero		db	"   ##   $", " #   #  $", "#     # $", "#     # $", "#     # $", " #   #  $", "  ##    $"
line		db	13, 10, "$"
zle		db	"Zly argument! $"

dane    ends

;wymiary 7 na 9
;        offset:
;    #   $0
;   ##   $9
;  # #   $18
;    #   $27
;    #   $36
;    #   $45
;  ####  $54


;        offset:
;   ##   $0
; #   #  $9
;#     # $18
;#     # $27
;#     # $36
; #   #  $45
;  ##    $54


assume  cs:code                          ;segmentem kodu jest segment "code"
                                         
code    segment
start:        
        				;inicjacja stosu
        mov     ax, seg w_stosu
        mov     ss, ax                  ;SS - Stack Segment
        mov     sp, offset w_stosu      ;SP - Stack Pointer

        mov     dx, offset polecenie    ;przeniesienie do dx offsetu etykiety polecenie
	mov     ax, seg polecenie       ;wypisanie stringu
        mov     ds, ax
        mov     ah, 9h
        int     21h
	call	newline

	;wyswietlanie petli F
	xor	bx, bx          ; tutaj przyrost offsetu
	mov	cx, 7		; bo mamy 7 linijek, licznik linijek

	xor	ax, ax		
	mov	ah, 8		;wczywanie znaku do al
	int	21h
	

	cmp	al, 'F'		;porownanie z F
	jz	petlaF		;jesli rowne to skocz do petli F
	cmp	al, 'f'		;tak samo, jesli to mala litera
	jz	petlaF
	jnz	jump1		;jesli warunki nie spelnione to sprawdz kolejne warunki 
				;czy pasuja do petliE

;jump1, jump2, ... potrzebne, bo jz i jnz nie dziala na dalekie odleglosci
;w ten sposob sztucznie skracam odleglosc 

petlaF:					; wyswietla 1111
	call	print_jeden		; wyswietla 4 razy pierwsza linijke w jedynce
	call	print_jeden
	call	print_jeden
	call	print_jeden	
	add	bx, 9		;do bx dodaje 9, a potem do offsetu przesuniecie o 9,
				;bo taka szerokosc ma cyfra
	call	newline		;nowa linija
	sub	cx, 1		;zmniejszenie licznika o 1
	jnz	petlaF			;jesli licznik != 0 to przeskakuje do petla15
	jmp	koniec		;zeby nie wykonywaly sie kolejne petle skocz na koniec

jump1:				;sprawdzamy czy zawartosc al pasuje do petli E

	cmp	al, 'E'
	jz	petlaE
	cmp	al, 'e'
	jz	petlaE
	jnz	jump2		;jesli wartosc spod al nie pasuje do petli E to ja przeskakujemy
				;i sprawdzamy czy zawartosc al pasuje do petli D, i tak dalej

petlaE:					;wyswietla 1110
	call	print_jeden		;4 razy pierwsza linijka 1,1,1,0
	call	print_jeden
	call	print_jeden
	call	print_zero
	call	sterowanie_petla	;zmiejsza licznik, dodaje przesuniecie offsetu
	jnz	petlaE			;jesli != 0 to przeskocz do peta14
	jmp	koniec
	
jump2:

	cmp	al, 'D'
	jz	petlaD
	cmp	al, 'd'
	jz	petlaD
	jnz	jump3

petlaD:					;wyswietla 1101
	call	print_jeden	
	call	print_jeden
	call	print_zero
	call	print_jeden
	call	sterowanie_petla
	jnz	petlaD
	jmp	koniec

jump3:


	cmp	al, 'C'
	jz	petlaC
	cmp	al, 'c'
	jz	petlaC
	jnz	jump4


petlaC:					;wyswietla 1100
	call	print_jeden	
	call	print_jeden
	call	print_zero
	call	print_zero
	call	sterowanie_petla
	jnz	petlaC
	jmp	koniec

jump4:


	cmp	al, 'B'
	jz	petlaB
	cmp	al, 'b'
	jz	petlaB
	jnz	jump5


petlaB:					;wyswietla 1011
	call	print_jeden	
	call	print_zero
	call	print_jeden
	call	print_jeden
	call	sterowanie_petla
	jnz	petlaB
	jmp	koniec

jump5:


	cmp	al, 'A'
	jz	petlaA
	cmp	al, 'a'
	jz	petlaA
	jnz	jump6

petlaA:					;wyswietla 1010
	call	print_jeden	
	call	print_zero
	call	print_jeden
	call	print_zero
	call	sterowanie_petla
	jnz	petlaA
	jmp	koniec

jump6:

	cmp	al, '9'
	jz	petla9
	jnz	jump7

petla9:					;wyswietla 1001
	call	print_jeden	
	call	print_zero
	call	print_zero
	call	print_jeden
	call	sterowanie_petla
	jnz	petla9
	jmp	koniec


jump7:

	cmp	al, '8'
	jz	petla8
	jnz	jump8
petla8:					;wyswietla 1000
	call	print_jeden	
	call	print_zero
	call	print_zero
	call	print_zero
	call	sterowanie_petla
	jnz	petla8
	jmp	koniec


jump8:
	cmp	al, '7'
	jz	petla7
	jnz	jump9

petla7:					;wyswietla 0111
	call	print_zero	
	call	print_jeden
	call	print_jeden
	call	print_jeden
	call	sterowanie_petla
	jnz	petla7
	jmp	koniec

jump9:
	cmp	al, '6'
	jz	petla6
	jnz	jump10
petla6:					;wyswietla 0110
	call	print_zero	
	call	print_jeden
	call	print_jeden
	call	print_zero
	call	sterowanie_petla
	jnz	petla6
	jmp	koniec

jump10:

	cmp	al, '5'
	jz	petla5
	jnz	jump11

petla5:					;wyswietla 0101
	call	print_zero	
	call	print_jeden
	call	print_zero
	call	print_jeden
	call	sterowanie_petla
	jnz	petla5
	jmp	koniec

jump11:

	cmp	al, '4'
	jz	petla4
	jnz	jump12

petla4:					;wyswietla 0100
	call	print_zero	
	call	print_jeden
	call	print_zero
	call	print_zero
	call	sterowanie_petla
	jnz	petla4
	jmp	koniec

jump12:

	cmp	al, '3'
	jz	petla3
	jnz	jump13

petla3:					;wyswietla 0011
	call	print_zero	
	call	print_zero
	call	print_jeden
	call	print_jeden
	call	sterowanie_petla
	jnz	petla3
	jmp	koniec

jump13:

	cmp	al, '2'
	jz	petla2
	jnz	jump14

petla2:					;wyswietla 0010
	call	print_zero	
	call	print_zero
	call	print_jeden
	call	print_zero
	call	sterowanie_petla
	jnz	petla2
	jmp	koniec
jump14:

	cmp	al, '1'
	jz	petla1
	jnz	jump16

petla1:					;wyswietla 0001
	call	print_zero	
	call	print_zero
	call	print_zero
	call	print_jeden
	call	sterowanie_petla
	jnz	petla1
	jmp	koniec

jump16:

	cmp	al, '0'
	jz	petla0
	jnz	blad			;zadna petla nie nadaje sie, wiec 
					;wprowadzono zla wartosc

petla0:					;wyswietla 0000 
	call	print_zero	
	call	print_zero
	call	print_zero
	call	print_zero
	call	sterowanie_petla
	jnz	petla0
	jmp	koniec			
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

blad:				
	mov	ax, seg zle
	mov	ds, ax
	mov	dx, offset zle
	mov	ah, 9
	int	21h
	call	koniec

print_jeden:			;wyswietla linijke jedynki
	mov	ax, seg jeden	;segment w ds
	mov	ds, ax
	lea	dx, jeden	;offset jeden w dx
	add	dx, bx		;dodanie przesuniecia w offsecie, zeby bylo widac kolejna linijke
				;a nie ciagle ta sama
	mov	ah, 9
	int	21h		;wypisanie linijki
	ret

print_zero:			;analogicznie do jedynki
	mov	ax, seg zero
	mov	ds, ax
	lea	dx, zero
	add	dx, bx

	mov	ah, 9
	int	21h
	ret

print:				;wyswietla zawartosc DS:DX do znku $
	mov	ah, 9
	int	21h	
	ret

newline:			;wyswietla nowa linijke
	mov	ax, seg line
	mov	ds, ax
	mov	dx, offset line
	mov	ah, 9
	int	21h
	ret

sterowanie_petla:		;do petli wyswietlajacej baner
	add	bx, 9		;do bx dodaje 9, a potem do offsetu przesuniecie o 9,
				;bo taka szerokosc ma cyfra
	call	newline		;nowa linija
	sub	cx, 1		;zmniejszenie licznika o 1
	ret

koniec:	
	mov	ah, 04ch
	int	21h

code    ends

stos    segment stack                   ;segment stosu
        dw      200 dup(?)
        w_stosu dw ?
stos    ends

end     start
