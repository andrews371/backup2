;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       ATIVIDADE 7                               *
;*             ANDRE OLIVEIRA DE SOUSA - 11325684                  *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;NOVAS VARIÁVEIS
		CONTL
		CONTH
		CONT

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00001000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL
	BCF	GPIO,GP1
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	
COMECO	
	MOVLW	.2
	MOVWF	CONT
	CLRF	TMR1H		; ZERA OS TMR1H:TMR1L
	CLRF    TMR1L		
	MOVLW	B'00000000'		
	MOVWF	TMR1H		
	MOVLW	B'00000000'	
	MOVWF	TMR1L
	
	;PULSO PARA ACIONAR O ULTRASSON
	BSF	GPIO,GP0
	CALL	DELAY_10US
	BCF	GPIO,GP0
	
	;TESTE DA RESPOSTA DO ULTRASSON
TESTE_INICIAL_GP3
	BTFSC	GPIO,GP3	    ;VERIFICA SE GP3 RECEBEU A RESPOSTA
	GOTO	TEMPO_RESPOSTA	    ;SE GP3 FOR 1, RECEBEU A RESPOSTA
	GOTO	TESTE_INICIAL_GP3   ;SE GP3 FOR 0, AINDA NÃO RECEBEU A RESPOSTA

	;VERIFICA POR QUANTO TEMPO O GP3 PERMANECEU EM NÍVEL LÓGICO ALTO
TEMPO_RESPOSTA
	;INICIA CONTADOR		
	BSF     T1CON,TMR1ON	    ;INICIA A CONTAGEM DE TEMPO
	BTFSC	GPIO,GP3
	GOTO	$ - 1
	BCF	T1CON,TMR1ON	    ;PÁRA A CONTAGEM DE TEMPO
	GOTO	ROTINA_MENOR5 ;QUANDO GP3 FOR 0 JA TEMOS O TEMPO PARA CALCULAR A DISTÂNCIA
	
ROTINA_MENOR5
	MOVLW	B'00000001'
	MOVWF	CONTH
	MOVLW	B'00100010'
	MOVWF	CONTL
	
	;TESTE DE DISTÂNCIA
	MOVFW	CONTH
	SUBWF	TMR1H,W
	BTFSC	STATUS,C
	GOTO	MAIOR_IGUAL
	GOTO	MENOR
	
MAIOR_IGUAL
	BTFSC	STATUS,Z
	GOTO	TESTA_LOW
	GOTO	MAIOR	

MAIOR
	GOTO	ROTINA5
	
MENOR	
	BCF	GPIO,GP1
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DELAY_60
	
;BITS MENOS SIGNIFICATIVOS
TESTA_LOW
	MOVFW	CONTL
	SUBWF	TMR1L,W
	BTFSC	STATUS,C
	GOTO	MAIOR_IGUAL_L
	GOTO	MENOR_L
	
MAIOR_IGUAL_L
	GOTO	ROTINA5	
	
MENOR_L	
	BCF	GPIO,GP1
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DELAY_60
;FIM DO TESTE DE DISTÂNCIA
	
	
	
;REFERÊNCIA PARA 580 = 10 CM	
ROTINA5
	MOVLW	B'00000010'
	MOVWF	CONTH
	MOVLW	B'01000100'
	MOVWF	CONTL
	
	;TESTE DE DISTÂNCIA
	MOVFW	CONTH
	SUBWF	TMR1H,W
	BTFSC	STATUS,C
	GOTO	MAIOR_IGUAL_ROT5
	GOTO	MENOR_ROT5
	
MAIOR_IGUAL_ROT5
	BTFSC	STATUS,Z
	GOTO	TESTA_LOW_ROT5
	GOTO	MAIOR_ROT5	

MAIOR_ROT5
	GOTO	ROTINA10
	
MENOR_ROT5	
	BSF	GPIO,GP1
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DELAY_60
	
;BITS MENOS SIGNIFICATIVOS
TESTA_LOW_ROT5
	MOVFW	CONTL
	SUBWF	TMR1L,W
	BTFSC	STATUS,C
	GOTO	MAIOR_IGUAL_L_ROT5
	GOTO	MENOR_L_ROT5
	
MAIOR_IGUAL_L_ROT5
	GOTO	ROTINA10
	
MENOR_L_ROT5	
	BSF	GPIO,GP1
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DELAY_60
;FIM DO TESTE DE DISTÂNCIA
	
	
	
	;REFERÊNCIA PARA 870 = 15 CM	
ROTINA10
	MOVLW	B'00000011'
	MOVWF	CONTH
	MOVLW	B'01100110'
	MOVWF	CONTL
	
	;TESTE DE DISTÂNCIA
	MOVFW	CONTH
	SUBWF	TMR1H,W
	BTFSC	STATUS,C
	GOTO	MAIOR_IGUAL_ROT10
	GOTO	MENOR_ROT10
	
MAIOR_IGUAL_ROT10
	BTFSC	STATUS,Z
	GOTO	TESTA_LOW_ROT10
	GOTO	MAIOR_ROT10	

MAIOR_ROT10
	GOTO	ROTINA15
	
MENOR_ROT10	
	BSF	GPIO,GP1
	BSF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DELAY_60
	
;BITS MENOS SIGNIFICATIVOS
TESTA_LOW_ROT10
	MOVFW	CONTL
	SUBWF	TMR1L,W
	BTFSC	STATUS,C
	GOTO	MAIOR_IGUAL_L_ROT10
	GOTO	MENOR_L_ROT10
	
MAIOR_IGUAL_L_ROT10
	GOTO	ROTINA15
	
MENOR_L_ROT10	
	BSF	GPIO,GP1
	BSF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DELAY_60
;FIM DO TESTE DE DISTÂNCIA
	
	
	
		;REFERÊNCIA PARA 1160 = 20 CM	
ROTINA15
	MOVLW	B'00000100'
	MOVWF	CONTH
	MOVLW	B'10001000'
	MOVWF	CONTL
	
	;TESTE DE DISTÂNCIA
	MOVFW	CONTH
	SUBWF	TMR1H,W
	BTFSC	STATUS,C
	GOTO	MAIOR_IGUAL_ROT15
	GOTO	MENOR_ROT15
	
MAIOR_IGUAL_ROT15
	BTFSC	STATUS,Z
	GOTO	TESTA_LOW_ROT15
	GOTO	MAIOR_ROT15

MAIOR_ROT15
	GOTO	ROTINA_MAIOR20
	
MENOR_ROT15	
	BSF	GPIO,GP1
	BSF	GPIO,GP2
	BSF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DELAY_60
	
;BITS MENOS SIGNIFICATIVOS
TESTA_LOW_ROT15
	MOVFW	CONTL
	SUBWF	TMR1L,W
	BTFSC	STATUS,C
	GOTO	MAIOR_IGUAL_L_ROT15
	GOTO	MENOR_L_ROT15
	
MAIOR_IGUAL_L_ROT15
	BTFSC	STATUS,Z
	GOTO	ROTINA20
	GOTO	ROTINA_MAIOR20
	
MENOR_L_ROT15	
	BSF	GPIO,GP1
	BSF	GPIO,GP2
	BSF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	DELAY_60
;FIM DO TESTE DE DISTÂNCIA
	

ROTINA20
	BSF	GPIO,GP1
	BSF	GPIO,GP2
	BSF	GPIO,GP4
	BSF	GPIO,GP5
	GOTO	DELAY_60
	

ROTINA_MAIOR20
	;LEDS PISCANDO
	BSF	GPIO,GP1
	BSF	GPIO,GP2
	BSF	GPIO,GP4
	BSF	GPIO,GP5
	;DELAY DE 100 MS PARA O OLHO HUMANO PODER ENXERGAR
	BANK1
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO DO TMR0
	BANK0
	BCF	INTCON,T0IF
	CLRF	TMR0
	MOVLW	.60
	MOVWF	TMR0
	BTFSS	INTCON,T0IF
	GOTO	$ - 1
	DECFSZ	CONT
	GOTO	ROTINA_MAIOR20
	;FIM DO DELAY
	;LEDS PISCANDO
	BCF	GPIO,GP1
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5

	
	;DELAY DE 60ms NECESSÁRIO PARA DAR OUTRO PULSO DE SAÍDA
DELAY_60
	BANK1
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO DO TMR0
	BANK0
	BCF	INTCON,T0IF
	CLRF	TMR0
	MOVLW	.21
	MOVWF	TMR0
	BTFSS	INTCON,T0IF
	GOTO	$ - 1
	;FIM DO DELAY
	
	GOTO	COMECO

DELAY_10US
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END

