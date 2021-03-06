;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
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
		
		CONT_5

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
	MOVLW	B'00000010'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	MOVLW	B'00000010'	;CONFIGURA O PINO 1 COMO DO GPIO COMO ENTRADA ANAL�GICA
	MOVWF	ANSEL
	MOVLW	B'10000011'	;BIT 3 HABILITA A TENS�O DE REFER�NCIA E LOW RANGE OU HIGH RANGE
	MOVWF	VRCON		;NESSE CASO FOI LOW RANGE
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00010100'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

    ;CORPO DA ROTINA PRINCIPAL

    BCF	    GPIO,GP2		    ;INICIA COM O COMPRESSOR DESLIGADO
    
    ;VALOR DE TENS�O DE REFER�NCIA M�NIMO 0.585: COM VRR EM 1 CHEGAMOS EM 0.625
    ;J� COM VRR EM 0 (HIGH RANGE) CHEGAMOS EM UM VALOR NEGATIVO. PORTANTO USAMOS VRR EM 1 (LOW RANGE)
    
    ;VALOR DE TENS�O DE REFER�NCIA M�XIMO 1.725: COM VRR EM 1 CHEGAMOS NO VALOR 1.667
    ;J� COM VRR EM 0 CHEGAMOS EM 1.719 QUE � MAIS PR�XIMO DA TENS�O DE REFER�NCIA
    ;ENT�O USAMOS PARA TENS�O DE REFER�NCIA M�XIMA VRR EM 0 (HIGH RANGE)
    
    ;PARA AMBOS OS CASOS N � IGUAL A 3, E ENT�O OS BITS VR3:VRO TEM QUE ESTAR EM 0011
    
COMECO  
    ;TESTANDO AS CONDI��ES INICIAIS DO COMPARADOR
    BANK1
    BTFSC   VRCON,VRR
    GOTO    T_MIN		    ;SE O VRR FOR 1, O COMPARADOR EST� CONFIGURADO PARA M�NIMO

    ;ESTE TRECHO � EXECUTADO QUANDO O VRR � ZERO
    ;E NESTE CASO O COMPARADOR EST� CONFIGURADO PARA M�XIMO
    BANK0
    BTFSC   CMCON,COUT		    ;TESTA SE A TEMP AMBIENTE � SUPERIOR OU INFERIOR A TMAX CONFIGURADA NO COMPARADOR
    GOTO    LIGA_COMPRESSOR	    ;TEMP AMBIENTE SUPERIOR A TMAX. COMPRESSOR DEVE SER LIGADO 
    GOTO    COMECO		    ;TEMP AMBIENTE INFERIOR A TMAX. COMPRESSOR DEVE PERMANECER COMO 
				    ;ESTAVA. CONFIGURA��O ANTERIOR DO COMPARADOR DEVE SER MANTIDA.
				    
T_MIN
    BANK0
    BTFSC   CMCON,COUT		    ;TESTA SE A TEMP AMBIENTE � SUPERIOR OU INFERIOR A TMIN CONFIGURADA NO COMPARADOR
    GOTO    COMECO		    ;TEMP AMBIENTE SUPERIOR A TMIN. COMPRESSOR DEVE PERMANECER COMO 
				    ;ESTAVA. CONFIGURA��O ANTERIOR DO COMPARADOR DEVE SER MANTIDA. 		    ;TEMP AMBIENTE INFERIOR A TMIN. COMPRESSOR DEVE SER DESLIGADO
    GOTO    DESLIGA_COMPRESSOR
    
    
;AQUI LIGA O COMPRESSOR E MUDA A TENS�O DE REFER�NCIA PARA M�NINA  
LIGA_COMPRESSOR
    BSF	    GPIO,GP2
    
    ;DELAY PARA TENTAR EVITAR A HISTERESE
    MOVLW   .5
    MOVWF   CONT_5
DELAY_LIGA
    CLRF    TMR0
    BCF	    INTCON,T0IF
    MOVLW   .60
    MOVWF   TMR0
    BTFSS   INTCON,T0IF
    GOTO    $ - 1
    DECFSZ  CONT_5
    GOTO    DELAY_LIGA
    ;FIM DO DELAY E CONTINUA��O DO PROGRAMA
    
    BANK1
    BSF	    VRCON,VRR
    BANK0
    GOTO    COMECO
    
;DESIGA O COMPRESSOR E MUDA A TENS�O DE REFER�NCIA PARA M�XIMA    
DESLIGA_COMPRESSOR
    BCF	    GPIO,GP2
    
    ;DELAY PARA TENTAR EVITAR A HISTERESE
    MOVLW   .5
    MOVWF   CONT_5
DELAY_DESLIGA
    CLRF    TMR0
    BCF	    INTCON,T0IF
    MOVLW   .60
    MOVWF   TMR0
    BTFSS   INTCON,T0IF
    GOTO    $ - 1
    DECFSZ  CONT_5
    GOTO    DELAY_DESLIGA
    ;FIM DO DELAY E CONTINUA��O DO PROGRAMA
    
    BANK1
    BCF	    VRCON,VRR
    BANK0
    MOVWF   VRCON
    GOTO    COMECO
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
