# Program File: zadanie4.asm
# Author: Piotr Stêpieñ
# Cel programu: Konwertuje String na liczby w wybranym systemie liczbowym.
.data
str: .asciiz "31"
prompt1: .asciiz "specify the number system (2 <= number <= 10): "

.text
main:

li $v0,4
la $a0,prompt1		# wyswietlenie prompt1
syscall

li $v0,5		# odczytanie systemu liczbowego
syscall

move $t8,$v0		# przeniesienie do $t8

la $t0, str		# za³aduj adres str do $t0
li $v0,0		# zainicjuj $v0 = 0
li $v1,10		# zainicjuj $v1 = 10
lb $t1,($t0)		# load byte: $t1 = Memory($t0)

str2int:
addiu $t1,$t1,-48	# konwertuj znak na liczbê
mul $v0,$v0,$v1		# $v0 = $v0 * 10
addu $v0,$v0,$t1	# $v0 = $v0 + liczba
addiu $t0,$t0,1		# wska¿ nastêpny znak w pamiêci
lb $t1,($t0)		# load byte: $t1 = Memory($t0)
bnez $t1,str2int	# powrót do pêtli jeœli znak nie jest NULL

dalej:
move $a0,$v0		# przygotowanie wartoœci do u¿ycia funkcji konwertuj¹cej,
move $a1,$t8		# wartoœæ z systemu 10 na ten podany przez u¿tykownika

jal convert		# skok do funkcji konwertuj¹cej

li $v0,10		# koniec programu
syscall

convert:
#a0=wartosc = A
#a1=system liczbowy = B

addi $sp,$sp,-16	# przygotowanie miejsca w stosie

sw $s3,12($sp) 		# zapis licznika, aby wiedziec ile bylo iteracji

sw $s0,8($sp) 		# wartosci
sw $s1,4($sp) 		# system
sw $ra,0($sp)		# adres powrotu

add $s0,$zero,$a0
add $s1,$zero,$a1

beqz $s0,end		# warunek wyjscia z petli

div $t4,$s0,$s1 	# t4=A/B
rem $t3,$s0,$s1 	# t3=A%B
add $sp,$sp,-4
sw $t3,0($sp) 		# zapis $t3

add $a0,$zero,$t4 	# a0 = A/B
add $a1,$zero,$s1 	# a1 = B
addi $s3,$s3,1
jal convert        	# nastêpna iteracja

end:
lw $ra,0($sp)		# odczytanie adresu powrotnego
lw $s3,12($sp)
beqz $s3,done		# warunek wyjscia z petli

lw $a0,16($sp)		# wartosc do wypisania
li $v0,1		# wypisywanie wartoœci
syscall

done: 
addi $sp,$sp,20		# przywrócenie stosu
jr $ra   		# powrót
