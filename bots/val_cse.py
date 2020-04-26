#!/usr/bin/env python
# coding: utf-8

# In[1]:


### manipulando tabela do brasileirão série A a partir de 2012
# para verificação de padrão nos resultados corretos extra leagues

import csv 
import statistics as st
import math
import numpy as np

# Distribuição de Poisson para resultados de futebol
def poisson(time1,time2,mgf_ccasa,mgs_ccasa,mgf_cfora,mgs_cfora,rodada):
    mgf_tcasa = time1['mgf_tcasa']
    mgs_tcasa = time1['mgs_tcasa']
    mgf_tfora = time2['mgf_tfora']
    mgs_tfora = time2['mgs_tfora']
    
    odd_jc = 0
    odd_je = 0
    odd_jf = 0
    
    # tratamento de zeros
    if mgf_tcasa == 0:
        mgf_tcasa = 0.1
        
    if mgs_tcasa == 0:
        mgs_tcasa = 0.1
        
    if mgf_tfora == 0:
        mgf_tfora = 0.1
        
    if mgs_tfora == 0:
        mgs_tfora = 0.1
        
    if mgf_ccasa == 0:
        mgf_ccasa = 0.1
        
    if mgs_ccasa == 0:
        mgs_ccasa = 0.1
        
    if mgf_cfora == 0:
        mgf_cfora = 0.1
        
    if mgs_cfora == 0:
        mgs_cfora = 0.1
    
    media_getc = mgf_tcasa / mgf_ccasa * mgs_tfora / mgs_cfora * mgf_ccasa
    media_getf = mgf_tfora / mgf_cfora * mgs_tcasa / mgs_ccasa * mgf_cfora

    # p/ prob. do número de gols
    probf_casa = [0,0,0,0,0,0,0,0,0,0,0]
    probf_fora = [0,0,0,0,0,0,0,0,0,0,0]
    probs_casa = [0,0,0,0,0,0,0,0,0,0,0]
    probs_fora = [0,0,0,0,0,0,0,0,0,0,0]

    # p/ prob. de vitória, empate e derrota
    probv_casa = 0
    probv_fora = 0
    prob_empate = 0

    # p/ prob. dupla chance
    dupla_casa = 0
    dupla_fora = 0

    # p/ prob. empate anula
    emp_ac = 0
    emp_af = 0

    # p/ prob. under e over
    under_05 = 0
    over_05 = 0
    under_15 = 0
    over_15 = 0
    under_25 = 0
    over_25 = 0
    under_35 = 0
    over_35 = 0

    # p/ prob. ambas marcam
    ambas_sim = 0
    ambas_nao = 0
    
    # criando uma matriz em python
    prob_placar = np.zeros((11,11), dtype=np.float64)
    placar_ordenado = []
    pos_placar_ordenado = []
    posicao = 0
    cont = 0

    # prob. de gols do time da casa e fora
    for i in range(11):
        probf_casa[i] = (math.exp(-media_getc)*media_getc**i)/math.factorial(i)
        probf_fora[i] = (math.exp(-media_getf)*media_getf**i)/math.factorial(i)

    # prob. de placares do jogo; prob. de 1x2; prob. de under e over
    # i -> num de gols do time da casa; j -> num de gols do time de fora
    for i in range(11):
        for j in range(11):
            # prob. de 1x2
            if i > j:
                probv_casa += probf_casa[i] * probf_fora[j] * 100
            elif j > i:
                probv_fora += probf_casa[i] * probf_fora[j] * 100
            else: 
                prob_empate += probf_casa[i] * probf_fora[j] * 100

            # prob. de under e over
            # under/over 0.5
            if i + j <= 0:
                under_05 += probf_casa[i] * probf_fora[j] * 100

            # under/over 1.5
            if i + j <= 1:
                under_15 += probf_casa[i] * probf_fora[j] * 100

            # under/over 2.5
            if i + j <= 2:
                under_25 += probf_casa[i] * probf_fora[j] * 100

            # under/over 3.5
            if i + j <= 3:
                under_35 += probf_casa[i] * probf_fora[j] * 100

            # prob. ambas marcam
            if (i > 0) and (j > 0):
                ambas_sim += probf_casa[i] * probf_fora[j] * 100

            # prob. de placar exato
            prob_placar[i][j] = probf_casa[i] * probf_fora[j] * 100
            placar_ordenado.append(prob_placar[i][j])
            pos_placar_ordenado.append(placar_ordenado[cont])
            cont += 1
            # print(f'{i} x {j} -> {prob_placar[i][j]:.2f}%')

    # prob. dupla chance
    dupla_casa = (probv_casa + prob_empate) 
    dupla_fora = (probv_fora + prob_empate)

    # prob. empate anula
    emp_ac = probv_casa/(probv_casa + probv_fora) * 100
    emp_af = 100 - emp_ac

    # prob. over 0.5
    over_05 = 100 - under_05

    # prob. over 1.5
    over_15 = 100 - under_15

    # prob. over 2.5
    over_25 = 100 - under_25

    # prob. over 3.5
    over_35 = 100 - under_35

    # prob. ambas marcam não
    ambas_nao = 100 - ambas_sim

    placar_ordenado.sort(reverse = True)
    
    
    odd_jc = 100/probv_casa
    odd_je = 100/prob_empate
    odd_jf = 100/probv_fora
    #print(f'Rodada {rodada}') 
    
    return odd_jc,odd_je,odd_jf
    
    
    '''
    print('{} x {}'.format(time1['time'], time2['time']))
    print(f'prob. de vitória casa => {probv_casa:.2f}%')
    print(f'prob. de empate: {prob_empate:.2f}%')
    print(f'prob. de vitória visitante => {probv_fora:.2f}%\n')
    

    print(f'\nPlacar Ordenado\n')
    # for i in range(121): 121 é o máximo. Nesse range pode-se escolher quantos resultados corretos exibir
    for i in range(10):
        posicao = pos_placar_ordenado.index(placar_ordenado[i])

        # Resultados Corretos
        print(f'{int(posicao/11)} x {posicao%11} -> {placar_ordenado[i]:.2f}%')

    # 1x2
    print(f'\nprob. de vitória casa => {probv_casa:.2f}%')
    print(f'prob. de vitória visitante => {probv_fora:.2f}%')
    print(f'prob. de empate: {prob_empate:.2f}%')

    # dupla chance
    print(f'\nprob. dupla chance casa => {dupla_casa:.2f}%')
    print(f'prob. dupla chance visitante => {dupla_fora:.2f}%')

    # empate anula
    print(f'\nprob. empate anula casa => {emp_ac:.2f}%')
    print(f'prob. empate anula visitante: => {emp_af:.2f}%')

    # under/over 0.5
    print(f'\nprob. under 0.5 => {under_05:.2f}%')
    print(f'prob. over 0.5 => {over_05:.2f}%')

    # under/over 1.5
    print(f'\nprob. under 1.5 => {under_15:.2f}%')
    print(f'prob. over 1.5 => {over_15:.2f}%')

    # under/over 2.5
    print(f'\nprob. under 2.5 => {under_25:.2f}%')
    print(f'prob. over 2.5 => {over_25:.2f}%')

    # under/over 3.5
    print(f'\nprob. under 3.5 => {under_35:.2f}%')
    print(f'prob. over 3.5 => {over_35:.2f}%')

    # ambas marcam
    print(f'\nprob. ambas marcam sim => {ambas_sim:.2f}%')
    print(f'prob. ambas marcam não => {ambas_nao:.2f}%')'''
    pass


def ano_dados(camp,ano):
    # base de dados
    time_casa = ''
    time_fora = ''
    num_jogos = 0
    num_gols = 0
    media_gols = 0

    # para média de gols dos times
    mgf_tcasa = 0
    mgs_tcasa = 0
    mgf_tfora = 0
    mgs_tfora = 0

    # para média de gols do campeonato
    # antes da rodada em questão
    tgf_ccasa_ant = 0
    tgf_cfora_ant = 0
    mgf_ccasa_ant = 0
    mgs_ccasa_ant = 0
    mgf_cfora_ant = 0
    mgs_cfora_ant = 0

    # depois da rodada em questão
    mgf_ccasa = 0
    mgs_ccasa = 0
    mgf_cfora = 0
    mgs_cfora = 0

    time_ant = [''] * 20 # recebe dados do time antes do jogo da rodada
    time = [''] * 20     # recebe dados do time depois de ser realizado o jogo da rodada em quetão

    tgf_ccasa = 0
    tgf_cfora = 0

    cont1 = 0
    cont_jogos = 0
    rodada = 1
    cont_geral = 1
    cont_ind = [0] * 20

    time1_ant = ''
    time2_ant = ''
    time1 = ''
    time2 = ''
    dentro_rodada = 0

    odd_pca = 0
    odd_pea = 0
    odd_pfa = 0

    ojc = 0
    oje = 0
    ojf = 0

    resultado = ''
    saldo = 0
    num_entradas = 0

    taxa_1x0 = 0
    taxa_n1x0 = 0
    total_ja = 0

    # últimos resultados
    urc = [''] * 20
    urf = [''] * 20

    with open(camp, 'r', encoding = 'utf-8', newline = '') as al:
        arq1 = csv.DictReader(al)

        for linha in arq1:
            
            try:
                lnvazia = int(linha['HG'])
                lnvazia = int(linha['AG'])

                if (linha['Season'].split('/')[0] == ano):
                    # odd match odds Pinnacle
                    odd_pca = float(linha['PH'])
                    odd_pea = float(linha['PD'])
                    odd_pfa = float(linha['PA']) 

                    # resultado do jogo
                    resultado = linha['Res']

                    # média de gols do campeonato antes da rodada em questão
                    tgf_ccasa_ant = tgf_ccasa
                    tgf_cfora_ant = tgf_cfora
                    mgf_ccasa_ant = mgf_ccasa
                    mgs_ccasa_ant = mgs_ccasa
                    mgf_cfora_ant = mgf_cfora
                    mgs_cfora_ant = mgs_cfora

                    # média de gols do campeonato depois da rodada em questão
                    tgf_ccasa += float(linha['HG'])
                    tgf_cfora += float(linha['AG'])
                    mgf_ccasa = tgf_ccasa/cont_geral
                    mgs_ccasa = tgf_cfora/cont_geral
                    mgf_cfora = mgs_ccasa
                    mgs_cfora = mgf_ccasa

                    # carregando os times e o número de jogos de cada
                    if cont1 < 10:
                        cont_ind[cont1] += 1
                        cont_ind[cont1+10] += 1
                        urc[cont1] = linha['Home']
                        urc[cont1+10] = linha['Away']
                        urf[cont1] = linha['Home']
                        urf[cont1+10] = linha['Away']

                        time[cont1] = {'time':linha['Home'],'num_jogosc':cont_ind[cont1],'num_jogosf':0,'tgf_tcasa':int(linha['HG']),'tgs_tcasa':int(linha['AG']),'tgf_tfora':0,'tgs_tfora':0,'mgf_tcasa':float(linha['HG'])/cont_ind[cont1],'mgs_tcasa':float(linha['AG'])/cont_ind[cont1],'mgf_tfora':0,'mgs_tfora':0}
                        time[cont1+10] = {'time':linha['Away'],'num_jogosc':0,'num_jogosf':cont_ind[cont1+10],'tgf_tcasa':0,'tgs_tcasa':0,'tgf_tfora':int(linha['AG']),'tgs_tfora':int(linha['HG']),'mgf_tcasa':0,'mgs_tcasa':0,'mgf_tfora':float(linha['AG'])/cont_ind[cont1+10],'mgs_tfora':float(linha['HG'])/cont_ind[cont1+10]}
                        cont1 += 1                  

                    # contando jogos
                    if cont_jogos <= 10:
                        cont_jogos += 1

                    # atualizando os dados dos times por jogo
                    if cont_geral >= 10:     
                        for i in range(20):
                            if linha['Home'] == time[i]['time']: 
                                time_ant[i] = time[i].copy() # time antes da rodada em questão

                                # atualização dos times após os jogos da rodada
                                time[i]['num_jogosc'] += 1
                                time[i]['tgf_tcasa'] += int(linha['HG'])
                                time[i]['tgs_tcasa'] += int(linha['AG'])

                                time[i]['mgf_tcasa'] = time[i]['tgf_tcasa']/time[i]['num_jogosc']
                                time[i]['mgs_tcasa'] = time[i]['tgs_tcasa']/time[i]['num_jogosc']

                            if linha['Away'] == time[i]['time']:
                                time_ant[i] = time[i].copy() # time antes da rodada em questão

                                # atualização dos times após os jogos da rodada
                                time[i]['num_jogosf'] += 1
                                time[i]['tgf_tfora'] += int(linha['AG'])
                                time[i]['tgs_tfora'] += int(linha['HG'])

                                time[i]['mgf_tfora'] = time[i]['tgf_tfora']/time[i]['num_jogosf']
                                time[i]['mgs_tfora'] = time[i]['tgs_tfora']/time[i]['num_jogosf']


                    #contando rodadas - a primeira vez que entra aqui é a rodada 2
                    if cont_jogos > 10 or dentro_rodada < 10:
                        # atualizando o número de rodadas
                        if cont_jogos > 10:
                            rodada += 1
                            cont_jogos = 1
                            dentro_rodada = 0

                        dentro_rodada += 1

                        #carregando times com dados da rodada para chamar o método
                        if rodada > 1:
                            for i in range(20):                 
                                if linha['Home'] == time[i]['time']:
                                    time1_ant = time_ant[i] # time1 antes da rodada em questão
                                    time1 = time[i]         # time1 depois da rodada em questão
                                if linha['Away'] == time[i]['time']:
                                    time2_ant = time_ant[i] # time2 antes da rodada em questão
                                    time2 = time[i]         # time2 depois da rodada em questão


                        #print('número de jogos: {}'.format(cont_geral))
                        # chamando o método para cálculo de probabilidades
                        
                            #ojc,oje,ojf = poisson(time1_ant,time2_ant,mgf_ccasa_ant,mgs_ccasa_ant,mgf_cfora_ant,mgs_cfora_ant,rodada)

                        if odd_pca <= 1.6:
                            total_ja += 1
                            if int(linha['HG']) != 1 or int(linha['AG']) != 0:
                                taxa_n1x0 += 1
                            else:
                                taxa_1x0 += 1

                        elif odd_pfa <= 1.6:              
                            total_ja += 1
                            if int(linha['HG']) != 0 or int(linha['AG']) != 1:
                                taxa_n1x0 += 1
                            else:
                                taxa_1x0 += 1

                            '''if (((odd_pca / ojc) - 1) * 100) >= 20 and (((odd_pca / ojc) - 1) * 100) <= 40 and odd_pca >= 1.8 and odd_pca <= 2.2:
                                num_entradas += 1
                                if (linha['Res'] == 'H'):
                                    saldo += 5 * (odd_pca - 1)
                                else:
                                    saldo -= 5

                            elif (((odd_pfa / ojf) - 1) * 100) >= 20 and (((odd_pfa / ojf) - 1) * 100) <= 40 and odd_pfa >= 1.8 and odd_pfa <= 2.2:
                                num_entradas += 1
                                if (linha['Res'] == 'A'):
                                    saldo += 5 * (odd_pfa - 1)
                                else:
                                    saldo -= 5


                            elif (((odd_pea / oje) - 1) * 100) >= 10 and odd_pea >= 2.2 and odd_pea <= 3.3:
                                num_entradas += 1
                                if (linha['Res'] == 'D'):
                                    saldo += 5 * (odd_pea - 1)
                                else:
                                    saldo -= 5'''
                            pass
                    cont_geral += 1
                    
            except:
                continue

    #print('Campeonato: {}  ano: {}'.format(camp,ano))
    #print('Entradas: {}  Saldo: {s:.2f}'.format(num_entradas,s = saldo))
    return taxa_n1x0,taxa_1x0,total_ja
    
    
    
# programa principal
# ano a ser avaliado

ent2 = input('Campeonato: ')
entrada2 = ent2.upper().split(',') # campeonato -> entrada2
tam_ent2 = len(entrada2)
print('\n')
entrada2 = entrada2

for i in range(tam_ent2):
    entrada2[i] = 'dados/' + entrada2[i] + '.csv'

ent = input('anos a serem avaliados: ')
entrada = ent.split(',') # ano -> entrada
tam_ent = len(entrada)
print('\n')

taxa_n1x0 = 0
taxa_1x0 = 0
total_ja = 0

ftaxa_n1x0 = 0
ftaxa_1x0 = 0
ftotal_ja = 0

ftaxa_acertos = []

for i in range(tam_ent2):
    for j in range(tam_ent):
        try:
            taxa_n1x0,taxa_1x0,total_ja = ano_dados(entrada2[i],entrada[j])
            ftaxa_n1x0 += taxa_n1x0
            ftaxa_1x0 += taxa_1x0
            ftotal_ja += total_ja
            ftaxa_acertos.append((ftaxa_n1x0*100) / ftotal_ja)
            #print('Banca parcial {s:.2f}\n'.format(s = saldo_final))
        except:
            continue
    
#print(f'Número de entradas: {quant_entradas}   Saldo final: {saldo_final:.2f}')
odd_lay = 100 / (100 - ((ftaxa_n1x0 * 100) / (ftotal_ja)))
print(f'Total de jogos analisados: {ftotal_ja}')
print(f'taxa de nao 1x0: {ftaxa_n1x0}')
print(f'taxa de 1x0: {ftaxa_1x0}')
print(f'greens por red: {ftaxa_n1x0 / ftaxa_1x0:.2f}')
print(f'Acertos em média: {((ftaxa_n1x0 * 100) / (ftotal_ja)):.2f}%')
print(f'Acertos em mediana (tirando outliers): {st.median(ftaxa_acertos):.2f}%')
print(f'Odd lay ideal ABAIXO de : {odd_lay:.2f}\n')
    

