;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                      ATIVIDADE 4                                *
;*            ANDRE OLIVEIRA DE SOUSA - 11325684                   *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES

		;NOVAS VARI�VEIS
		
		CONT_DELAY_95
		CONT_DELAY_60
		CONT_DELAY_40

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER�O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00001011' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000001'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	;CORPO DA ROTINA PRINCIPAL 

    MOVLW   .19
    MOVWF   CONT_DELAY_95
    
    BCF	    GPIO,GP0
    BCF	    GPIO,GP1
    BCF	    GPIO,GP3
    
    BSF	    GPIO,GP2
    BSF	    GPIO,GP4
    BSF	    GPIO,GP5
    
    DELAY_5_INICIAL		
	CLRF	TMR0
	MOVLW	.233
	MOVWF	TMR0
	BTFSS	INTCON,T0IF
	GOTO	$ - 1 
	BCF	INTCON,T0IF
    DELAY_95_INICIAL
	CLRF	TMR0
	DECFSZ	CONT_DELAY_95
	GOTO	DELAY_95_INICIAL
	
    ESCOLHA_LED
	BTFSC	GPIO,GP1
	GOTO	VERDE_AZUL
	BTFSC	GPIO,GP0
	GOTO	VERMELHO
	GOTO	DESLIGA_LEDS
	
    DESLIGA_LEDS
	BCF	GPIO,GP2
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	TESTE
	
	
	
	
    VERMELHO
	    BTFSC	GPIO,GP3
	    GOTO	ESCOLHA_LED
	    BTFSC	GPIO,GP1
	    GOTO	VERMELHO_SESSENTA_CEM
	    BTFSC	GPIO,GP0
	    GOTO	VERMELHO_DUTY_CYCLE_20
	    GOTO	VERMELHO_DUTY_CYCLE_5

	VERMELHO_SESSENTA_CEM    
	    BTFSC	GPIO,GP0
	    GOTO	VERMELHO_DUTY_CYCLE_600
	    GOTO	VERMELHO_DUTY_CYCLE_60

	VERMELHO_DUTY_CYCLE_5
	    BSF	    GPIO,GP2
	    DELAY_5_INICIAL
	    
	VERMELHO_DUTY_CYCLE_20
	    BSF	    GPIO,GP2
	    GOTO    DELAY_20

	VERMELHO_DUTY_CYCLE_60
	    BSF	    GPIO,GP2
	    GOTO    DELAY_60

	VERMELHO_DUTY_CYCLE_100
	    BSF	    GPIO,GP2
	    GOTO    DELAY_100

    VERDE_AZUL
	BTFSC	GPIO,GP0
	GOTO	AZUL
	GOTO	VERDE
	
	
	
	
    AZUL
	    BTFSC	GPIO,GP3
	    GOTO	ESCOLHA_LED
	    BTFSC	GPIO,GP1
	    GOTO	AZUL_SESSENTA_CEM
	    BTFSC	GPIO,GP0
	    GOTO	AZUL_DUTY_CYCLE_20
	    GOTO	AZUL_DUTY_CYCLE_5

	AZUL_SESSENTA_CEM    
	    BTFSC	GPIO,GP0
	    GOTO	AZUL_DUTY_CYCLE_600
	    GOTO	AZUL_DUTY_CYCLE_60

	AZUL_DUTY_CYCLE_5
	    BSF	    GPIO,GP5
	    GOTO    DELAY_5

	AZUL_DUTY_CYCLE_20
	    BSF	    GPIO,GP5
	    GOTO    DELAY_20

	AZUL_DUTY_CYCLE_60
	   BSF	    GPIO,GP5
	    GOTO    DELAY_60

	AZUL_DUTY_CYCLE_100
	    BSF	    GPIO,GP5
	    GOTO    DELAY_100
	
	
	
	
    VERDE
	    BTFSC	GPIO,GP3
	    GOTO	ESCOLHA_LED
	    BTFSC	GPIO,GP1
	    GOTO	VERDE_SESSENTA_CEM
	    BTFSC	GPIO,GP0
	    GOTO	VERDE_DUTY_CYCLE_20
	    GOTO	VERDE_DUTY_CYCLE_5

	VERDE_SESSENTA_CEM    
	    BTFSC	GPIO,GP0
	    GOTO	VERDE_DUTY_CYCLE_600
	    GOTO	VERDE_DUTY_CYCLE_60

	VERDE_DUTY_CYCLE_5
	    BSF	    GPIO,GP4
	    GOTO    DELAY_5

	VERDE_DUTY_CYCLE_20
	    BSF	    GPIO,GP4
	    GOTO    DELAY_20

	VERDE_DUTY_CYCLE_60
	    BSF	    GPIO,GP4
	    GOTO    DELAY_60

	VERDE_DUTY_CYCLE_100
	    BSF	    GPIO,GP4
	    GOTO    DELAY_100

    
    GOTO    MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
