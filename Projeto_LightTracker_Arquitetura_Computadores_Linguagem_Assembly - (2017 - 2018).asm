; ------------------- Definição De Constantes -------------------
FIMTEMPO		EQU 		100					; timer = 0.2ms -> fimTempo = 100*0.2ms = 20ms 
ZERO			EQU			3					; 3*0.2ms = 0.6ms -> 0º 
CENTOOITENTA	EQU			12					; 12*0.2 = 2.4ms -> 180º
ATRASO			EQU			10					; 10*20ms = 0.2s

; ------------------- Definição De Portas -------------------
servo			EQU 		P1.0				; Pino Para Controlo Do Servo.
LED				EQU 		P1.1				; Pino De Acionamento Do LED Quando Deteta Um Sinal Luminoso.
sensorLuz		EQU			P3.2				; Pino De Acionamento Do Sinal Luminoso.

; ---------------------------------------------------------
; Primeira Instrução, Após o Reset Do MicroControlador.
CSEG AT 000H
	JMP MAIN
	
; Se Ocorrer A Interrupção Externa 0.
CSEG AT 0003h
	JMP  InterrupcaoExt0

; Tratamento Da Interrupção De Temporização 0, Para Contar 20ms.
CSEG AT 000Bh
	JMP  InterrupcaoTemp0
								
CSEG AT 0050H
MAIN:
	LCALL INICIO

BEGIN:											; Inicialização Do Loop Infinito.
	MOV A, R0			
	MOV B, R2
	CJNE A, B, AtingiuOs20						; Caso Conta Seja Diferente A Referência Salta Para AtingiuOs20.
	CLR servo									; Coloca Servo A 0.
	JB sensorLuz, AtingiuOs20					; Caso Sensor De Luz Esteja A Receber Sinal Luminoso.
	MOV R1, #0									; Conta2 Igual A 0 (Mantém Servo Bloqueado).

AtingiuOs20:
	MOV A, R0									; Coloca Conta No Acumulador.
	CJNE R0, #FIMTEMPO, sinalLuminoso			; Caso Conta Atinga Fim De Tempo Salta Para Rotina Sinal Luminoso.
	MOV R0, #0									; Reinicia A Contagem Do Conta.
	SETB servo									; Coloca O Servo A 1 Para Atingir Valor Da Referencia.
	INC R1										; Incrementa O Conta2.

sinalLuminoso:
	JNB sensorLuz, BEGIN						; Avança Caso Sensor De Luz Não Esteja Ativo.
	MOV A, R1
	CJNE A, #ATRASO, BEGIN						; Caso Conta2 Seja Diferente De Atraso Salta Novamente Para Begin.
	SETB LED									; Continua A Enviar Sinal Para LED Continuar Desativado.
	MOV A, R4
	CJNE R4, #0 , direcaoZero					; Caso A Variável DIR Seja Diferente Zero, Salta Para direcaoZero.
	MOV A, R2
	CJNE A, #CENTOOITENTA, reiniciaContagem	; Caso A DIR Não Esteja Na Referência 180º Salta Para  reiniciaContagem.
	MOV R4, #1									; Coloca a DIR A 1 (180º Para 0º).
	JMP BEGIN
	
reiniciaContagem:
	INC R2										; Incrementa A Referência.
	MOV R1, #0									; Volta A Reiniciar A Contagem.
	JMP BEGIN
	
direcaoZero:
	MOV A, R2
	CJNE A, #ZERO, direcaoCentoOitenta			; Caso Referência Seja Diferente De Zero, Salta Para direcaoCentoOitenta.
	MOV R4, #0									; Coloca a DIR A 0 (0º Para 180º).
	JMP BEGIN
	
direcaoCentoOitenta:
	DEC R2										; Decrementa O Valor Da Referência.
	MOV R1, #0									; Volta A Reiniciar A Contagem.

JMP BEGIN										; Loop Infinito Fim.

; ---------------------------------------------------------										
; Registos
; R0 - conta.
; R1 - conta2.
; R2 - referencia.
; R3 - sensor luz.
; R4 - (Dir) Variável Auxiliar Responsável Pela Direção Do Servo.
; ---------------------------------------------------------	
;Tratamento Da Interrupção Externa.
InterrupcaoExt0:
			CLR LED								; Coloca O LED A 0, Ou Seja Liga (Funciona Pela Lógica Negada).
			RETI
			
; Tratamento Da Interrupção De Temporização.			
InterrupcaoTemp0:
			INC R0								; Incrementa O Conta.
			RETI
				
; ---------------------------------------------------------
; Ciclo Do Programa Inicial.
INICIO:
	
	MOV IE ,#10000011B
												; Activa Interrupções Globais.
	 											; Activa Interrupção timer 0. 
	 											; Ativa Interrupção Externa 0.
	; Configuração Do Registo TMOD 
	MOV TMOD, #00000010B
												; Limpa Os 4 bits Do timer 0 (8 bits – auto reload). 
												; Modo 2 Do Timer 0.
	; Configuração Timer 0 
	MOV TH0, #037H 								; Timer 0 - 200us. 
	MOV TL0, #037H 
	; Configuração Registo TCON
												;TF1 TR1 TF0 TR0 IE1 IT1 IE0 IT0
												; 		  	  1				  1
	SETB TR0  									; Começa O timer 0. 
	SETB IT0  									; Interrupção Externa Activa A Falling Edge.
	; Configuração Do LED.
	SETB LED									; Inicialização Do LED A 1 (Funciona Pela Lógica Negada).	
												
	; Configuração Dos Registos.
	MOV R2, #ZERO								; Atribuição À Referência Valor Do Zero (3).
	MOV R4, #0									; Atribuição À Variável DIR Valor De 0.
	MOV R0, #0									; Inicialização Da Variável Conta Com Valor De 0.
	MOV R1, #0									; Inicialização Da Variável Conta2 Com Valor De 0.
	MOV R3, #0									; Inicialização Da Variável Sensor Luz Com Valor De 0.
	RET
	
	END




	








