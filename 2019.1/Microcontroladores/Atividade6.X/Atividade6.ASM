;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		
		CONT_5

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
	MOVLW	B'00000010'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	MOVLW	B'00000010'	;CONFIGURA O PINO 1 COMO DO GPIO COMO ENTRADA ANALÓGICA
	MOVWF	ANSEL
	MOVLW	B'10000011'	;BIT 3 HABILITA A TENSÃO DE REFERÊNCIA E LOW RANGE OU HIGH RANGE
	MOVWF	VRCON		;NESSE CASO FOI LOW RANGE
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00010100'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

    ;CORPO DA ROTINA PRINCIPAL

    BCF	    GPIO,GP2		    ;INICIA COM O COMPRESSOR DESLIGADO
    
    ;VALOR DE TENSÃO DE REFERÊNCIA MÍNIMO 0.585: COM VRR EM 1 CHEGAMOS EM 0.625
    ;JÁ COM VRR EM 0 (HIGH RANGE) CHEGAMOS EM UM VALOR NEGATIVO. PORTANTO USAMOS VRR EM 1 (LOW RANGE)
    
    ;VALOR DE TENSÃO DE REFERÊNCIA MÁXIMO 1.725: COM VRR EM 1 CHEGAMOS NO VALOR 1.667
    ;JÁ COM VRR EM 0 CHEGAMOS EM 1.719 QUE É MAIS PRÓXIMO DA TENSÃO DE REFERÊNCIA
    ;ENTÃO USAMOS PARA TENSÃO DE REFERÊNCIA MÁXIMA VRR EM 0 (HIGH RANGE)
    
    ;PARA AMBOS OS CASOS N É IGUAL A 3, E ENTÃO OS BITS VR3:VRO TEM QUE ESTAR EM 0011
    
COMECO  
    ;TESTANDO AS CONDIÇÕES INICIAIS DO COMPARADOR
    BANK1
    BTFSC   VRCON,VRR
    GOTO    T_MIN		    ;SE O VRR FOR 1, O COMPARADOR ESTÁ CONFIGURADO PARA MÍNIMO

    ;ESTE TRECHO É EXECUTADO QUANDO O VRR É ZERO
    ;E NESTE CASO O COMPARADOR ESTÁ CONFIGURADO PARA MÁXIMO
    BANK0
    BTFSC   CMCON,COUT		    ;TESTA SE A TEMP AMBIENTE É SUPERIOR OU INFERIOR A TMAX CONFIGURADA NO COMPARADOR
    GOTO    LIGA_COMPRESSOR	    ;TEMP AMBIENTE SUPERIOR A TMAX. COMPRESSOR DEVE SER LIGADO 
    GOTO    COMECO		    ;TEMP AMBIENTE INFERIOR A TMAX. COMPRESSOR DEVE PERMANECER COMO 
				    ;ESTAVA. CONFIGURAÇÃO ANTERIOR DO COMPARADOR DEVE SER MANTIDA.
				    
T_MIN
    BANK0
    BTFSC   CMCON,COUT		    ;TESTA SE A TEMP AMBIENTE É SUPERIOR OU INFERIOR A TMIN CONFIGURADA NO COMPARADOR
    GOTO    COMECO		    ;TEMP AMBIENTE SUPERIOR A TMIN. COMPRESSOR DEVE PERMANECER COMO 
				    ;ESTAVA. CONFIGURAÇÃO ANTERIOR DO COMPARADOR DEVE SER MANTIDA. 		    ;TEMP AMBIENTE INFERIOR A TMIN. COMPRESSOR DEVE SER DESLIGADO
    GOTO    DESLIGA_COMPRESSOR
    
    
;AQUI LIGA O COMPRESSOR E MUDA A TENSÃO DE REFERÊNCIA PARA MÍNINA  
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
    ;FIM DO DELAY E CONTINUAÇÃO DO PROGRAMA
    
    BANK1
    BSF	    VRCON,VRR
    BANK0
    GOTO    COMECO
    
;DESIGA O COMPRESSOR E MUDA A TENSÃO DE REFERÊNCIA PARA MÁXIMA    
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
    ;FIM DO DELAY E CONTINUAÇÃO DO PROGRAMA
    
    BANK1
    BCF	    VRCON,VRR
    BANK0
    MOVWF   VRCON
    GOTO    COMECO
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
