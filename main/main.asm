# Lig-4-em-Assembly-Mips
.data
matriz: .word 0:64 #--crio uma matriz [8] [8] cheia de 0
jogada_invalida: .asciiz "\n Jogada inválida, escolha outro valor\n"
empatou: .asciiz "Toda as colunas foram prenchidas, EMPATE "
jogador: .asciiz "\n Jogador, esecolha uma coluna!\n"
vitoria_do_jogador2: .asciiz "\n Jogador 2 venceu"
vitoria_do_jogador1: .asciiz "\n Jogador 1 venceu"
.text



la $a0, matriz #----Salvo endere?o da matriz

li $s0, 0x00FF0000 #--vermelho

li $s1, 0x00000000 #--preto

li $s2, 0x000000FF #--- Azul

li $a1, 0x10010000#---endere?o tela mars

li $a3,0

main:

inicio_main:

la $t1,jogador
move $a0,$t1
li $v0,4
syscall

li $v0,5
syscall
move $a2,$v0
addi $a2,$a2,-1 # correção
bgt $a2,7,acabou


la $a0, matriz #----Salvo endere?o da matriz

jal func_local_disponivel





j empate


#---pintar um quadrado-----

func_local_disponivel: #---procurar o 0(zero) mais baixo
#---- $a1 ----- tela mars
#---- $a2 -----  a coluna que o usuairo que colocar
#---- $a3 -----  par ou impar, pra ver quem ? o jogador
#---- $a0 -----  a matriz, pro calculo base
li $t1, 7 #--ultima linha



procura:
#-------------- achar endere?o
mul $t2, $t1,8 #linha x8
add $t2,$t2,$a2 #linha + coluna
mul $t2,$t2,4
add $t2,$t2, $a0
#--------------
lw $t3,0($t2) #----salvo em $t3 o valor correspondete ao espa?o

beq $t3,$zero,prencher #---- se tiver vazio
addi $t1,$t1,-1 #---subo uma coluna
bltz  $t1,acabou  #---com o passar, eu vou tenrar acessar a coluna 0 ou -1 o que vai identificar que a cabou a coluna
j procura#--se n?o prencheu nem acabou eu continuo procurando

prencher:
#------------ calcular resto se par = jogador 1, se impar jogador 2
rem $t5,$a3,2
#-------------

#-----------procurar endere?o correspondete ao do bitmap

#---------------

sub $t4,$t2,$a0 # salvo em $t4, a diiferen?a do valor base da matriz e do encontrado
add $t4,$t4,$a1 # $t4, tem a diferen?a mas o valor do bitmap


beq $t5,0,par
beq $t5,1,impar




par:
sw $s0,0 ($t4)#-----pinto no bit map com a cor($s0)
sw $s0,0 ($t2)#---pinto na matriz----
addi $a3,$a3,1 #---- se a jogada deu certo, somo, para na proxima vez ser outro jogador
j joador2_ganhou_coluna


impar:
sw $s2,0($t4)
sw $s2, 0($t2)
addi $a3,$a3,1 #---- se a jogada deu certo, somo, para na proxima vez ser outro jogador
j joador1_ganhou_coluna


acabou:
la $t5,jogada_invalida
move $a0,$t5
li $v0,4 #----imprime mensagem
syscall
j inicio_main


empate:#todas as 8 colunas acabaram
la $a0, matriz #pego o endereço da matriz
li $t7,0
while_empate:
lw $t5,0($a0)
beq $t5,$zero,continua
addi $a0,$a0,4
addi $t7,$t7,1
blt $t7,64,while_empate

la $a0,empatou

li $v0,4
syscall

j fim

fim:
li $v0,10
syscall

continua:
j inicio_main

 
 
 #--------------------------------------
 joador2_ganhou_coluna:
  li $t6,0#i=0
 li $t2,0#linha
li $t0,-1          # começa em -1 porque o addi vem antes do uso
 for_1:

 addi $t0,$t0,1    # incrementa primeiro (linha 0, 1, 2...)
bgt $t0,4,CHECAR_HORIZONTAL  #  CHAMA A VERIFICAÇÃO HORIZONTAL
 
 for2:
 la $s3,matriz
 addi $t1,$t0,0
 mul $t2, $t1,8 #linha x8
add $t2,$t2,$a2 #linha + coluna
mul $t2,$t2,4
add $t6,$t2,$s3

lw $t7,0($t6)
bne $t7,$s0, for_1   # $s0 = vermeelho (jogador par)

se_igual:
addi $t3,$t6,32#desci uma coluna
lw $t7,0($t3)
bne $t7,$s0, for_1

addi $t4,$t3,32
lw $t7,0($t4)
bne $t7,$s0, for_1

addi $t5,$t4,32
lw $t7,0($t5)
bne $t7,$s0, for_1

 vitoria_2_jogador:
 
 la $a0,vitoria_do_jogador2   # vermelho = jogador 1
 li $v0,4
 syscall
 j fim
 #------------------------------------
  joador1_ganhou_coluna:
  li $t0,-1
 for1_1:

 addi $t0,$t0,1
 bgt $t0,4,CHECAR_HORIZONTAL  # TESTA OUTRO JEITO NÉ QUE A VITORICA NA HORIZONTAL
 
 for22:
 la $s3,matriz
 addi $t1,$t0,0
 mul $t2, $t1,8 #linha x8
add $t2,$t2,$a2 #linha + coluna
mul $t2,$t2,4
add $t6,$t2,$s3


lw $t7,0($t6)
bne $t7,$s2, for1_1  
se_igual1:
addi $t3,$t6,32#desci uma coluna
lw $t7,0($t3)
bne $t7,$s2, for1_1

addi $t4,$t3,32
lw $t7,0($t4)
bne $t7,$s2, for1_1

addi $t5,$t4,32
lw $t7,0($t5)
bne $t7,$s2, for1_1

 vitoria_1_jogador:
 
 la $a0,vitoria_do_jogador1  
 li $v0,4
 syscall
 j fim

# ---------------AGR EU VEJO SE ALGUEM GANHOU NA HORIZONTAK --------------------------------------
CHECAR_HORIZONTAL:
jal verifvitoria                         # AGR TESTA COM A FUNÇÃO
beq $v0, $s0, vitoria_2_jogador          # SE RETORNOU COR VERMELHA ($s0), JOGADOR 1 VENCEU NA HORIZONTAL
beq $v0, $s2, vitoria_1_jogador  # SE RETORNOU COR AZUL ($s2), JOGADOR 2 VENCEU NA HORIZONTAL
j verifica_diagonal_p1 # AQUI VOU PRA ULTIMA POSSIBILIDADE, VER AS DIAGONAIS
r1:
j verifica_diagonal_2p2
r2:
j verifica_diagonal_sp1
r3:
j verifica_diagonal_sp2
retorne:
j empate     # SE RETORNOU 0, NINGUÉM VENCEU E SEGUE PARA VERIFICAR EMPATE


# ----------------------------------
 
 #funo vitrio--- by : LEANDRO
#argumentos int vitoria (int ** matriz($a0))
verifvitoria:
addu $sp, $sp, -36 #----reservando na pilha 16 bytes ou 4 words

sw $ra 4($sp) #---------Aqui sero utilizados $s0, $s1, $s2 e $ra para poder retornar ao main
sw $t0 8($sp)
sw $t1 12($sp)
sw $t2 16($sp)
sw $t3 20($sp)
sw $t4 24($sp)
sw $t5 28($sp)
sw $t6 32($sp)
sw $t7 36($sp)


#-----COMPARAR LINHAS-----#
compararlinhas:
move $t6, $a0 #------ $t6 ser a linha atual a ser verificada
move $t0, $a0 #------ $t0 ser um ponteiro que auxilia na verificao de 4 em 4 da linha atual
li $t4, 0 #------ equivalente ao i em c
li $t5, 0 #------ equivalente ao j em c
looplinha:
lw $t1, 0($t0) #--carrego 4 espaos consecutivos
lw $t2, 4($t0)
lw $t3, 8($t0)
lw $t7, 12($t0)

bne $t1, $t2, difflinhas #--comparo os 4 espaos se so iguais
bne $t2, $t3, difflinhas
bne $t3, $t7, difflinhas
beqz $t7, difflinhas
j igualdade

difflinhas:
beq $t4, 4, fimcomplinhaatual
addi $t4, $t4, 1
addi $t0, $t0, 4
j looplinha

fimcomplinhaatual:
beq $t5, 7, fimcomplinhas
addi $t5, $t5, 1
addi $t6, $t6, 32
move $t0, $t6
li $t4, 0
j looplinha

fimcomplinhas:

li $v0, 0
j fimfuncaovitoria


igualdade:
move $v0, $t1 #------------- a funo retorna a paridade do jogador vencedor
j fimfuncaovitoria

fimfuncaovitoria:
lw $ra 4($sp) #----------------- Liberando a pilha
lw $t0 8($sp)
lw $t1 12($sp)
lw $t2 16($sp)
lw $t3 20($sp)
lw $t4 24($sp)
lw $t5 28($sp)
lw $t6 32($sp)
lw $t7 36($sp)
addu $sp, $sp, 36
jr $ra

verifica_diagonal_p1 :
#------v3erifica assim : direita baixo\----------
diagonal_prenchda:
  li $t6,0#i=0
 li $t2,0#linha
li $t0,-1          # começa em -1 porque o addi vem antes do uso
 for_1d:

 addi $t0,$t0,1    # incrementa primeiro (linha 0, 1, 2...)
bge $t0,5,r1
 li $t8,-1         # a ideia é um contador que vai passando as coluns se estorurar
 for2d:
addi $t8,$t8,1    # avança coluha (0, 1, 2...)
 bge $t8,5,for_1d  # passou da coluna 4, pula uma linha
 la $s3,matriz
 addi $t1,$t0,0
 mul $t2, $t1,8 #linha x8
add $t2,$t2,$t8  
mul $t2,$t2,4
add $t6,$t2,$s3

lw $t7,0($t6)
bne $t7,$s0, for2d # se não for pula

se_iguald:
addi $t3,$t6,36#desci uma coluna andei 1 pra direita
lw $t7,0($t3)
bne $t7,$s0, for2d #  se nao for

addi $t4,$t3,36
lw $t7,0($t4)
bne $t7,$s0, for2d # se nao for

addi $t5,$t4,36
lw $t7,0($t5)
bne $t7,$s0, for2d # se nao for
vitoriad_1_jogador:
 
la $a0,vitoria_do_jogador1   #cc
 li $v0,4
 syscall
 j fim
#--------------------------------
verifica_diagonal_2p2 :
diagonal_prenchda2p:
  li $t6,0#i=0
 li $t2,0#linha
li $t0,-1          # começa em -1 porque o addi vem antes do uso
 for_2d2:

 addi $t0,$t0,1    # incrementa primeiro (linha 0, 1, 2...)
bge $t0,5,r2
 li $t8,-1         # a ideia é um contador que vai passando as coluns se estorurar
 for2d2:
addi $t8,$t8,1    # avança coluha (0, 1, 2...)
 bge $t8,5,for_2d2  # passou da coluna 4, pula uma linha
 la $s3,matriz
 addi $t1,$t0,0
 mul $t2, $t1,8 #linha x8
add $t2,$t2,$t8  
mul $t2,$t2,4
add $t6,$t2,$s3

lw $t7,0($t6)
bne $t7,$s2, for2d2 # se não for pula

se_igua2d2:
addi $t3,$t6,36#desci uma coluna andei 1 pra direita
lw $t7,0($t3)
bne $t7,$s2, for2d2 #  se nao for

addi $t4,$t3,36
lw $t7,0($t4)
bne $t7,$s2, for2d2 # se nao for

addi $t5,$t4,36
lw $t7,0($t5)
bne $t7,$s2, for2d2 # se nao for
vitoriad_2_jogador:
 
la $a0,vitoria_do_jogador2   #cc
 li $v0,4
 syscall
 j fim
 #-------------------------------------------
 verifica_diagonal_sp1:
 
 diagonal_sec:

  li $t6,0#i=0
 li $t2,0#linha
li $t0,-1          # começa em -1 porque o addi vem antes do uso
 for_1s:

 addi $t0,$t0,1    # incrementa primeiro (linha 0, 1, 2...)
bge $t0,5,r3
li $t8,2        # a diferente do outro temos que avançar logo 3 cassas se não estorura
 for2s:
addi $t8,$t8,1    # avança coluha (0, 1, 2...)
  # aqui podemos ir ate o final ordem contraia
 bge $t8,8,for_1s
 la $s3,matriz
 addi $t1,$t0,0
 mul $t2, $t1,8 #linha x8
add $t2,$t2,$t8  
mul $t2,$t2,4
add $t6,$t2,$s3

lw $t7,0($t6)
bne $t7,$s0, for2s # se não for pula

se_iguals:
addi $t3,$t6,28#desci uma coluna andei 1 pra esqertda
lw $t7,0($t3)
bne $t7,$s0, for2s #  se nao for

addi $t4,$t3,28
lw $t7,0($t4)
bne $t7,$s0, for2s # se nao for

addi $t5,$t4,28
lw $t7,0($t5)
bne $t7,$s0, for2s # se nao for
vitoriad_1_jogadors:
 
la $a0,vitoria_do_jogador1   #cc
 li $v0,4
 syscall
 j fim
 
 
 #--------------------------------
 
verifica_diagonal_sp2:
 
 diagona2_sec:

  li $t6,0#i=0
 li $t2,0#linha
li $t0,-1          # começa em -1 porque o addi vem antes do uso
 for_2s:

 addi $t0,$t0,1    # incrementa primeiro (linha 0, 1, 2...)
bge $t0,5,retorne
li $t8,2        # a diferente do outro temos que avançar logo 3 cassas se não estorura
 for2s2:
addi $t8,$t8,1    # avança coluha (0, 1, 2...)
  # aqui podemos ir ate o final ordem contraia
 bge $t8,8,for_2s
 la $s3,matriz
 addi $t1,$t0,0
 mul $t2, $t1,8 #linha x8
add $t2,$t2,$t8  
mul $t2,$t2,4
add $t6,$t2,$s3

lw $t7,0($t6)
bne $t7,$s2, for2s2 # se não for pula

se_iguals2:
addi $t3,$t6,28#desci uma coluna andei 1 pra esqertda
lw $t7,0($t3)
bne $t7,$s2, for2s2 #  se nao for

addi $t4,$t3,28
lw $t7,0($t4)
bne $t7,$s2, for2s2 # se nao for

addi $t5,$t4,28
lw $t7,0($t5)
bne $t7,$s2, for2s2 # se nao for
vitoriad_2_jogadors2:
 
la $a0,vitoria_do_jogador2   #cc
 li $v0,4
 syscall
 j fim
