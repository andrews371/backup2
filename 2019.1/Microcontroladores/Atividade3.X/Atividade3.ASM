;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       ATIVIDADE 3                               *
;*              ANDRE OLIVEIRA DE SOUSA - 11325684                 *
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
		
		TEMP1

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
	MOVLW	B'00000011' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
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
	BTFSS	GPIO,GP0 	;TESTES PARA SABER QUAL A 
	GOTO	$ + 4		;COMBINACAO DE GP0 E GP1
	BTFSS	GPIO,GP1	;PARA SABER EM QUAL INTENSIDADE DEVE DEIXAR
	GOTO	ROTINA3		;O GP5
	GOTO	ROTINA4		;UMA DAS 4 OPCOES DE ROTINA DE INTENSIDADE DO LED
	BTFSC	GPIO,GP1	;SERA ESCOLHIDA
	GOTO	ROTINA2		;AQUI TERMINA A FASE DE TESTES E ESCOLHA DA ROTINA ADEQUADA
	

;CADA ROTINA E SUBROTINA ABAIXO VISA DEIXAR GP5 EM HIGH E EM LOW O PERCENTUAL DO PERIODO PEDIDO	
;LEMBRANDO QUE TEMOS UMA FREQUENCIA DE 500 HZ, O QUE INDICA UM PERIODO DE 2 ms
;QUE CORRESPONDE A 200 MICROSSEGUNDOS = 200 CILOS DE MAQUINA
	
	
ROTINA1				;ESSA ROTINA DEIXA GP5 5% EM HIGH E 95% EM LOW QUANDO GP0 = 0 E GP1 = 0
	BSF	GPIO,GP5	;SETA GP5
	MOVLW   .32		
	MOVWF   TEMP1		;SETA TEMP1 COM 32
    ROTINA1_2			;NESTA ETAPA VAMOS DECREMENTAR TEMP1 ATE ZERO
	DECFSZ  TEMP1,F		;PARA JUNTAMENTE COM AS INSTRUCOES "NOP" ABAIXO
	GOTO    ROTINA1_2	;GASTAR O TEMPO NECESSARIO ATE CHEGARMOS EM BCF
	NOP
	NOP
	BCF	GPIO,GP5	;AQUI COLOCAMOS GP5 EM LOW POR 95% DO PERIODO
	MOVLW   .250		;SETA TEMP1 COM 250
	MOVWF   TEMP1
    ROTINA1_2_C1		;NESTA ETAPA SEGUE A MESMA LOGICA DE DECREMENTAR TEMP1
	DECFSZ  TEMP1,F		;PARA AO FINAL DA ROTINA QUANDO CHEGAR NO 
	GOTO    ROTINA1_2_C1	;GOTO MAIN, JA TERMOS GASTO O TEMPO NECESSARIO
	NOP			;COM GP5 EM LOW 
	MOVLW	.250		;SETAMOS OUTRO VALOR PARA TEMP1 POIS AINDA NAO
	MOVWF	TEMP1		;ATINGIMOS O TEMPO NECESSARIO E NAO PODIAMOS COLOCAR MAIS QUE 255 EM TEMP1
    ROTINA1_2_C2		;NESTA ETAPA CONTINUAMOS DECREMENTANDO TEMP1
	DECFSZ	TEMP1,F		;PARA JUNTAMENTE COM OUTRAS INTRUCOES, ATINGIRMOS
	GOTO	ROTINA1_2_C2	;O TEMPO EM QUE GP5 DEVE FICAR EM LOW
	NOP
	MOVLW	.131		;AQUI SE REPETE O PROCEDIMENTO POIS AINDA NAO
	MOVWF	TEMP1		;ATINGIMOS O TEMPO NECESSARIO
    ROTINA1_2_C3
	DECFSZ	TEMP1,F
	GOTO	ROTINA1_2_C3	
	
    GOTO    MAIN		;FINALMENTE, CHEGANDO AQUI, JA TEMOS DEIXADO GP5 95% EM LOW

ROTINA2				;ESSA ROTINA DEIXA GP5 20% EM HIGH E 80% EM LOW QUANDO GP0 = 0 E GP1 = 1
	BSF	GPIO,GP5	;A SEQUENCIA ATE O GOTO MAIN SEGUE EXATAMENTE A MESMA LOGICA
	MOVLW   .132		;DA ROTINA1 QUE JA FOI EXPLICADA
	MOVWF   TEMP1
    ROTINA2_2    
	DECFSZ  TEMP1,F
	GOTO    ROTINA2_2
	NOP
	NOP
	BCF	GPIO,GP5
	MOVLW   .250   
	MOVWF   TEMP1
    ROTINA2_2_C1   
	DECFSZ  TEMP1,F
	GOTO    ROTINA2_2_C1
	MOVLW   .250   
	MOVWF   TEMP1
    ROTINA2_2_C2
        DECFSZ	TEMP1,F
	GOTO	ROTINA2_2_C2
	MOVLW   .31   
	MOVWF   TEMP1
    ROTINA2_2_C3
        DECFSZ	TEMP1,F
	GOTO	ROTINA2_2_C3
	NOP
	NOP
	
    GOTO    MAIN
    
ROTINA3				;ESSA ROTINA DEIXA GP5 60% EM HIGH E 40% EM LOW QUANDO GP0 = 1 E GP1 = 0
	BSF	GPIO,GP5	;TODA A ROTINA É EXATAMENTE IGUAL A ROTINA1 QUE JA FOI COMENTADA
	MOVLW   .250   
	MOVWF   TEMP1
    ROTINA3_2    
	DECFSZ  TEMP1,F
	GOTO    ROTINA3_2
	MOVLW	.149
	MOVWF	TEMP1  
    ROTINA3_3
	DECFSZ	TEMP1,F
	GOTO	ROTINA3_3
	BCF	GPIO,GP5
	MOVLW	.250
	MOVWF	TEMP1  
    ROTINA3_3_C1
	DECFSZ	TEMP1,F
	GOTO	ROTINA3_3_C1
	NOP 
	MOVLW	.15
	MOVWF	TEMP1  
    ROTINA3_3_C2
	DECFSZ	TEMP1,F
	GOTO	ROTINA3_3_C2

    GOTO    MAIN
    
ROTINA4				    ;ESSA ROTINA DEIXA GP5 100% EM HIGH E 0% EM LOW QUANDO GP0 = 1 E GP1 = 1
	BSF	GPIO,GP5	    ;NOVAMENTE O RESTANDO DO CODIGO SEGUE A LOGICA DA ROTINA1
	MOVLW   .250		    ;ONDE DEVEMOS GASTAR, NESSE CASO, OS 100% DO TEMPO, OU SEJA,
	MOVWF   TEMP1		    ;OS 2 ms COM GP5 EM HIGH
    ROTINA4_2    
	DECFSZ  TEMP1,F
	GOTO    ROTINA4_2
	MOVLW	.250 
	MOVWF	TEMP1 
    ROTINA4_3
	DECFSZ	TEMP1,F 
	GOTO	ROTINA4_3
	MOVLW	.165  
	MOVWF	TEMP1 
    ROTINA4_4
	DECFSZ	TEMP1,F
	GOTO	ROTINA4_4
	
    GOTO    MAIN    

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
