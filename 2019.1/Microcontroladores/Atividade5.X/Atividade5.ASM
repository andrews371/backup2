;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       ATIVIDADE 5                               *
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
		
		RESULT	
		VAR_CINCO
		VAR_CINQUENTA_UM
		PARTE_INTEIRA	
		PARTE_DECIMAL
		CONT_4
		CONT_8
		CONT_10
		TENSAO

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
	MOVLW	B'00000100'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00010100'	;VAMOS USAR A PORTA 2 COMO ENTRADA
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00001001'	;BIT 0 HABILITA O CONVERSOR A OPERAR, APESAR QUE NÃO INICIOU A CONVERSÃO
	MOVWF	ADCON0		;BIT 3 E 2 ESTANDO EM 1 E 0 RESPECTIVAMENTE PERMITE USAR A PORTA 2 COMO ENTRADA
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

;INICIALIZACAO DE VARIAVEIS QUE SERAO USADAS PARA OPERACOES DE CONTA
COMECO
    MOVLW   .4
    MOVWF   CONT_4		
    MOVLW   .8
    MOVWF   CONT_8
    MOVLW   B'00000101'		;CINCO
    MOVWF   VAR_CINCO
    MOVLW   B'00110011'		;CINQUENTA E UM
    MOVWF   VAR_CINQUENTA_UM
    MOVLW   B'00000001'		;UM
    MOVWF   PARTE_INTEIRA
    MOVLW   B'00000001'		;UM
    MOVWF   PARTE_DECIMAL
    BSF	    ADCON0,1		;INICIA A CONVERSÃO
AINDA_NAO_CONVERTEU		;REPETE ESSE LAÇO ATÉ QUE A CONVERSÃO TERMINE
    BTFSC   ADCON0,1		;QUANDO O BIT 1 DO ADCON0 FOR 0, A CONVERSÃO TERMINOU
    GOTO    AINDA_NAO_CONVERTEU

    
;AQUI PARA ENCONTRAR A PARTE INTEIRA DA CONVERSAO VAMOS DIVIDIR O RESULTADO
;DA CONVERSAO POR 51
ENCONTRANDO_PARTE_INTEIRA   
    MOVFW   ADRESH
    MOVWF   RESULT		;VARIAVEL QUE ARMAZENA O VALOR DA CONVERSAO
    SUBWF   VAR_CINQUENTA_UM,W	;SUBTRAINDO O VALOR DA CONVERSAO DE 51 PARA SABER SE JA TEMOS A PARTE INTEIRA QUE SERA 
    BTFSS   STATUS,C		;PROCURAMOS O MAIOR VALOR QUE FAÇA COM QUE 51 MULTIPLICADO POR ELE NÃO SEJA MAIOR QUE O RESULTADO DA CONVERSÃO
    GOTO    MULTIPLICA_51	;CASO A SUBTRAÇÃO SEJA MENOR QUE ZERO MULTIPLICAMOS 51 POR UM VALOR MAIOR
    BTFSC   STATUS,Z		;VAMOS TESTAR SE O RESULTADO DA SUBTRAÇÃO É MAIOR OU IGUAL A ZERO
    GOTO    SEGUNDA_PARTE	;CASO SEJA ZERO (STATUS Z = 1) ENCONTRAMOS O MAIOR VALOR QUE ATENDE OS REQUISITOS E PODEMOS IR PARA A SEGUNDA PARTE
    DECF    PARTE_INTEIRA	;CASO CONTRARIO, O RESULTADO DA MULTIPLICAÇÃO DE 51 PELO VALOR ATUAL DEU MAIOR QUE O VALOR DA CONVERSÃO
    MOVLW   B'00110011'		;ENTAO DECREMENTAMOS ESSE VALOR, POIS O ANTERIOR É O MAIOR QUE SE ENCAIXA NAS CONDIÇÕES
    SUBWF   VAR_CINQUENTA_UM,F	;SUBTRAIMOS O VALOR DE "VAR_CIQUENTA_UM" QUE É O VALOR DE ACUMULADO DE 51 SOMADO A 51 SEMPRE QUE PRECISAR MULTIPLICAR 51 POR UM NÚMERO 1 UNIDADE MAIOR
    GOTO    SEGUNDA_PARTE	;CHEGANDO AQUI TAMBÉM TEMOS A PARTE INTEIRA E PODEMOS IR PARA A SEGUNDA PARTE

MULTIPLICA_51
    MOVLW   B'00110011'		;MULTIPLICANDO CINQUENTA E UM PARA O PROCESSO DE DIVISÃO 
    ADDWF   VAR_CINQUENTA_UM,W	;PARA ISSO SOMA O VALOR DE "VAR_CINQUENTA_UM" QUE INICIALMENTE É 51 COM 51 QUE EQUIVALE A MULTIPLICAR 51 POR UM VALOR 1 UNIDADE MAIOR
    MOVWF   VAR_CINQUENTA_UM	;ARMAZENA O RESULTADO EM "VAR_CINQUENTA_UM" QUE VAI ACUMULANDO OS RESULTADOS DA MULTIPLICAÇÃO PARA TESTES MENCIONADOS ANTERIORMENTE
    INCF    PARTE_INTEIRA	;CADA VEZ QUE MULTIPLICAMOS 51 TEMOS 1 A MAIS NO QUOCIENTE COMO POSSÍVEL CANDIDATO A RESULTADO INTEIRO DA DIVISÃO
    GOTO    ENCONTRANDO_PARTE_INTEIRA  ;VOLTA PARA TESTAR SE TEMOS O RESULTADO DA DIVISÃO OU SE PASSAMOS DELE
    
SEGUNDA_PARTE			;VAMOS DIVIDIR O RESTO DA DIVISÃO POR 5, POIS ASSIM O RESULTADO INTEIRO, SERÁ A PARTE DECIMAL DA CONVERSÃO QUE QUEREMOS
    MOVFW   VAR_CINQUENTA_UM	;SUBTRAINDO O VALOR DA MULTIPLICAÇÃO CALCULADO ANTES DO RESULTADO DA CONVERSÃO, TEMOS O RESTO DA DIVISÃO
    SUBWF   RESULT,F		;RESULT ARMAZENA O RESTO DA DIVISÃO
    
    
ENCONTRANDO_PARTE_DECIMAL	;ESTE PASSO É ANÁLOGO AO PASSO PARA ENCONTRAR A PARTE INTEIRA
    MOVFW   RESULT		
    SUBWF   VAR_CINCO,W		;O VALOR DO DIVISOR AGORA SERÁ 5 E NÃO MAIS 51
    BTFSS   STATUS,C		;AQUI ASSIM COMO ANTES VAMOS TESTAR SE O RESULTADO DA SUBTRAÇÃO DEU NEGATIVO
    GOTO    MULTIPLICA_5	;POSITIVO OU ZERO PARA SABERMOS SE JÁ TEMOS O VALOR QUE ATENDE AOS REQUISITOS DE UMA DIVISÃO DA MESMA FORMA JÁ FEITA ANTES
    DECF    PARTE_DECIMAL	;SE O STATUS Z É 0, PASSAMOS DO VALOR E TEMOS QUE DECREMENTÁ-LO E ESTE VALOR É O NOVO RESULTADO DA DIVISÃO E É A PARTE DECIMAL QUE DESEJAMOS
    GOTO    PRIMEIRA_ROTACAO	;PROXIMA ETAPA

MULTIPLICA_5
    MOVLW   B'00000101'		;MULTIPLICANDO CINCO PARA O PROCESSO DE DIVISÃO 
    ADDWF   VAR_CINCO,W		;COMO FIZEMOS ANTES, VAMOS MULTIPLICAR 5 POR 2, POIS JÁ TESTAMOS POR 0 E 1 ANTES E ARMAZENAR O VALOR EM "VAR_CINCO"
    MOVWF   VAR_CINCO		;PARA SABERMOS POR QUANTO DEVEMOS MULTIPLICAR 5 PARA O VALOR SER O MAXIMO POSSIVEL
    INCF    PARTE_DECIMAL	;SEM FAZER COM QUE A SUBTRAÇÃO DE "VAR_CINCO" E O RESTO CALCULADO ANTES SEJA MAIOR QUE 1
    GOTO    ENCONTRANDO_PARTE_DECIMAL
    
;DESLOCA OS BITS DO PRIMEIRO DÍGITO PARA A ESQUERDA 
;PARA POSTERIORMENTE SEREM ENVIADOS À SAÍDA 
    
PRIMEIRA_ROTACAO		;AQUI APENAS DESLOCAMOS 4 VEZES OS BITS DA PARTE INTEIRA 
    BCF	    STATUS,C		;PARA POSTERIOR "CONCATENAÇÃO" COM A PARTE DECIMAL ATRAVÉS DE UMA SOMA
    RLF	    PARTE_INTEIRA	;ROTACIONA BIT A BIT O VALOR DE RESULT
    GOTO    CONTA_BITS		;PULA PARA O METODO QUE IRÁ CONTAR 1 E VOLTAR PARA O ROTATE PARA ROTACIONAR O PRÓXIMO BIT. 

CONTA_BITS
    DECFSZ  CONT_4
    GOTO    PRIMEIRA_ROTACAO
    
;JUNTANDO AS DUAS SAÍDAS
    
    MOVFW	PARTE_INTEIRA
    ADDWF	PARTE_DECIMAL,W
    MOVWF	TENSAO		;A "CONCATENAÇÃO" MENCIONADA ANTES É FEITA ATRAVÉS DA SOMA DA PARTE INTEIRA DESLOCADA DE 4 BITS
				;COM A PARTE DECIMAL E O RESULTADO É ARMAZENADO EM TENSÃO QUE CONTÉM
				;O VALOR INTEIRO E DECIMAL DA CONVERSÃO EM 8 BITS
    
;SAIDA PARTE INTEIRA
    
;ATRAVÉS DE UMA ROTAÇÃO DE 8 BITS NA VARIÁVEL TENSÃO, PODEMOS MANDAR A SAÍDA PARA O SHIFTER
SAIDA
    RLF	    TENSAO		;ROTACIONA BIT A BIT O VALOR DE RESULT
    BTFSC   STATUS,C		;TESTA O CARRY
    GOTO    SETA_GP0_SAIDA	;SE O CARRY É 1, PULA PARA SETA_GP0, PARA QUE O GP0 POSSA SER SETADO
    BCF	    GPIO,GP0		;SE O CARRY É 0 LIMPA GP0
    BSF	    GPIO,GP1		;SETA GP1 PARA DAR UM PULSO DE CLOCK E MANDAR O VALOR DE GP0
    NOP
    BCF	    GPIO,GP1		;LIMPA GP1
    GOTO    CONTA_BITS_SAIDA 	;PULA PARA O METODO QUE IRÁ CONTAR 1 E VOLTAR PARA O ROTATE PARA ROTACIONAR O PRÓXIMO BIT. 
				;ISSO IRÁ SER FEITO 8 VEZES PARA ROTACIONAR OS 8 BITS EM "RESULT" E MANDAR PARA O CARRY
SETA_GP0_SAIDA			
    BSF	    GPIO,GP0		;AQUI VAMOS SETAR O GP0
    BSF	    GPIO,GP1		;SETA GP1 PARA DAR UM PULSO DE CLOCK E MANDAR O VALOR DE GP0
    NOP
    BCF	    GPIO,GP1		;LIMPA GP1 DESCENDO A BORDA DO MESMO 
    GOTO    CONTA_BITS_SAIDA	;NOVAMENTE PULA PARA CONTAR MAIS 1 ATÉ CHEGAR EM 8 PARA ROTACIONAR TODOS OS BITS DE "RESULT"

CONTA_BITS_SAIDA
    DECFSZ  CONT_8
    GOTO    SAIDA
    
;DELAY DE 500 ms ENTRE CADA EXIBIÇÃO
    
    MOVLW	.10
    MOVWF	CONT_10
DELAY
    CLRF    TMR0
    BCF	    INTCON,T0IF
    MOVLW   .100
    MOVWF   TMR0
    BTFSS   INTCON,T0IF
    GOTO    $ - 1
    DECFSZ  CONT_10
    GOTO    DELAY	
    
    GOTO    COMECO


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
