#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# Bot para o Brasileirão série A e B

from bs4 import BeautifulSoup as bs
from selenium import webdriver
import time
import math
import numpy as np

# Cálculo das probabilidades para os times
def poisson(url_jogo, pja, url_serie):
    driver.get(url_jogo)
    placar = pja
    
    time.sleep(2)
    html = driver.execute_script("return document.documentElement.outerHTML")
    page = bs(html, 'html.parser')

    equipes = page.find_all('span',{'class':'stats-title'})[0].text.strip().replace(" ", "")
    equipes = equipes.replace("\n", "")
    equipes = equipes.replace("VS", " VS ")
    
    mgf_tcasa = page.find_all('table',{'class':'stat-seqs stat-half-padding'})[2].find_all('tr',{'class':'even'})[0].find('',{'class':'highlight-home'}).text 
    if mgf_tcasa.strip() != '-':
        mgf_tcasa = float(mgf_tcasa)
    else:
        mgf_tcasa = 0.1
        
    mgs_tcasa = page.find_all('table',{'class':'stat-seqs stat-half-padding'})[2].find_all('tr',{'class':'even'})[1].find('',{'class':'highlight-home'}).text
    if mgs_tcasa.strip() != '-':
        mgs_tcasa = float(mgs_tcasa)
    else:
        mgs_tcasa = 0.1
        
    mgf_tfora = page.find_all('table',{'class':'stat-seqs stat-half-padding'})[3].find_all('tr',{'class':'even'})[0].find('',{'class':'highlight-away'}).text
    if mgf_tfora.strip() != '-':
        mgf_tfora = float(mgf_tfora)
    else:
        mgf_tfora = 0.1

    mgs_tfora = page.find_all('table',{'class':'stat-seqs stat-half-padding'})[3].find_all('tr',{'class':'even'})[1].find('',{'class':'highlight-away'}).text
    if mgs_tfora.strip() != '-':
        mgs_tfora = float(mgs_tfora)
    else:
        mgs_tfora = 0.1
    
    mgf_ccasa = page.find('',{'class':'boxed stats_resume'}).find_all('li')[9].find(class_='values').text.strip()
    if mgf_ccasa.strip() != '-':
        mgf_ccasa = float(mgf_ccasa)
    else:
        mgf_ccasa = 0.1
    
    mgs_ccasa = page.find('',{'class':'boxed stats_resume'}).find_all('li')[10].find(class_='values').text.strip()
    if mgs_ccasa.strip() != '-':
        mgs_ccasa = float(mgs_ccasa)
    else:
        mgs_ccasa = 0.1
    
    mgf_cfora = page.find('',{'class':'boxed stats_resume'}).find_all('li')[10].find(class_='values').text.strip() 
    if mgf_cfora.strip() != '-':
        mgf_cfora = float(mgf_cfora)
    else:
        mgf_cfora = 0.1
    
    mgs_cfora = page.find('',{'class':'boxed stats_resume'}).find_all('li')[9].find(class_='values').text.strip()
    if mgs_cfora.strip() != '-':
        mgs_cfora = float(mgs_cfora)
    else:
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
    if url_serie == 'https://www.academiadasapostasbrasil.com/stats/competition/brasil-stats/26':
        print(f'Campeonato Brasileiro Série A\n')
        if placar != 0:
            print('Jogo já realizado.')
            print(f'{equipes}')
            print(f'Placar => {placar}\n')
        else:
            print(f'{equipes}\n')
    else:
        print(f'Campeonato Brasileiro Série B\n')
        if placar != 0:
            print('Jogo já realizado.')
            print(f'{equipes}')
            print(f'Placar => {placar}\n')
        else:
            print(f'{equipes}\n')

    # for i in range(121): 121 é o máximo. Nesse range pode-se escolher quantos resultados corretos exibir
    # aux para evitar duplicar resultados com mesma prob.
  
    for i in range(10):
	    posicao = pos_placar_ordenado.index(placar_ordenado[i])
	    pos_placar_ordenado.remove(placar_ordenado[i])
	    pos_placar_ordenado.insert(posicao,1000)

	    # Resultados Corretos
	    print(f'{int(posicao/11)} x {posicao%11} -> {placar_ordenado[i]:.2f}%')

    # 1x2
    print(f'\nprob. de vitória casa => {probv_casa:.2f}% | Fair odd => {100/probv_casa:.3f}')
    print(f'prob. de empate: {prob_empate:.2f}% | Fair odd => {100/prob_empate:.3f}')
    print(f'prob. de vitória visitante => {probv_fora:.2f}% | Fair odd => {100/probv_fora:.3f}')

    # dupla chance
    print(f'\nprob. dupla chance casa => {dupla_casa:.2f}% | Fair odd => {100/dupla_casa:.3f}')
    print(f'prob. dupla chance visitante => {dupla_fora:.2f}% | Fair odd => {100/dupla_fora:.3f}')

    # empate anula
    print(f'\nprob. empate anula casa => {emp_ac:.2f}% | Fair odd => {100/emp_ac:.3f}')
    print(f'prob. empate anula visitante: => {emp_af:.2f}% | Fair odd => {100/emp_af:.3f}')

    # under/over 0.5
    print(f'\nprob. under 0.5 => {under_05:.2f}% | Fair odd => {100/under_05:.3f}')
    print(f'prob. over 0.5 => {over_05:.2f}% | Fair odd => {100/over_05:.3f}')

    # under/over 1.5
    print(f'\nprob. under 1.5 => {under_15:.2f}% | Fair odd => {100/under_15:.3f}')
    print(f'prob. over 1.5 => {over_15:.2f}% | Fair odd => {100/over_15:.3f}')

    # under/over 2.5
    print(f'\nprob. under 2.5 => {under_25:.2f}% | Fair odd => {100/under_25:.3f}')
    print(f'prob. over 2.5 => {over_25:.2f}% | Fair odd => {100/over_25:.3f}')

    # under/over 3.5
    print(f'\nprob. under 3.5 => {under_35:.2f}% | Fair odd => {100/under_35:.3f}')
    print(f'prob. over 3.5 => {over_35:.2f}% | Fair odd => {100/over_35:.3f}')

    # ambas marcam
    print(f'\nprob. ambas marcam sim => {ambas_sim:.2f}% | Fair odd => {100/ambas_sim:.3f}')
    print(f'prob. ambas marcam não => {ambas_nao:.2f}% | Fair odd => {100/ambas_nao:.3f}')
    
    # link para ver detalhes do jogo
    print('\n\nÚltimos jogos das equipes e tabela do campeonato')
    print(f'\n{url_jogo}')
    
    # espaçamento
    print('\n\n\n')
    



# busca dados para os jogos da rodada
def bot_brasil(url, opcao):
    driver.get(url)
    time.sleep(2)
    html = driver.execute_script("return document.documentElement.outerHTML")
    page = bs(html, 'html.parser')

    # as aspas simples como primeiro argumento do find_all 
    # indica que quero um elemento, como uma classe por exemplo, mas não quero especificar de que tag
    tam1 = len(page.find('table',{'class':'competition-rounds'}).find_all('',{'class':'even'}))
    tam2 = len(page.find('table',{'class':'competition-rounds'}).find_all('',{'class':'odd'}))
    tam = tam1 + tam2    

    jogo = [0] * tam
    pja = [0] * tam
    tam_link_vs = [0] * tam
    cont1 = 0
    cont2 = 1
    
    for i in range(tam1):
        tam_link_vs[cont1] = len(page.find_all('',{'class':'even'})[i].find_all('a'))
        cont1 += 2
    for i in range(tam2):
        tam_link_vs[cont2] = len(page.find_all('',{'class':'odd'})[i].find_all('a'))
        cont2 += 2

    cont1 = 0
    cont2 = 1
   
    for i in range(tam1):
        for j in range(tam_link_vs[cont1]): # i => linhas de classe even, j => tag a dentro das linhas
            aux = page.find_all('',{'class':'even'})[i].find_all('a')[j].text
            aux = aux.strip()         
            if aux == 'vs':            
                jogo[cont1] = page.find_all('',{'class':'even'})[i].find_all('a')[j].get('href') 
                break        
        if aux != 'vs':
            pja[cont1] = page.find_all('',{'class':'even'})[i].find_all('a')[1].text.strip()        
            jogo[cont1] = page.find_all('',{'class':'even'})[i].find_all('a')[1].get('href')
        cont1 += 2

    for i in range(tam2): # i => linhas de classe odd, j => tag a dentro das linhas
        for j in range(tam_link_vs[cont2]):
            aux = page.find_all('',{'class':'odd'})[i].find_all('a')[j].text
            aux = aux.strip()
            if aux == 'vs':
                jogo[cont2] = page.find_all('',{'class':'odd'})[i].find_all('a')[j].get('href') 
                break
        if aux != 'vs':
            pja[cont2] = page.find_all('',{'class':'odd'})[i].find_all('a')[1].text.strip()           
            jogo[cont2] = page.find_all('',{'class':'odd'})[i].find_all('a')[1].get('href')
        cont2 += 2

    # chamada para o cálculo de Poisson
    
    if opcao != 'toda':
        if pja[opcao - 1] != 0:
            poisson(jogo[opcao], pja[opcao], url)
        else:
            poisson(jogo[opcao], 0, url)
    else:
        for i in range(tam):
                if pja[i] != 0:
                    poisson(jogo[i], pja[i], url)
                else:
                    poisson(jogo[i], 0, url) 
    


# Início do programa


# pede opção ao usuário
escolha_camp = input('Dados para o Brasileirão série A ou B?\nPara série A digite "a", para série B digite "b" ')
print('\n')
entrada = input('Você quer algum jogo em específico ou a rodada completa?\nPara um jogo específico digite o número de ordem dele da academia.\nPara a rodada toda digite toda: ')
print('\n')

geckodriver = '/home/andre/Downloads/geckodriver'
driver = webdriver.FirefoxOptions()
driver.add_argument('-headless')
driver = webdriver.Firefox(executable_path=geckodriver, options=driver)

if escolha_camp == 'a':
    url = 'https://www.academiadasapostasbrasil.com/stats/competition/brasil-stats/26'
else:
    url = 'https://www.academiadasapostasbrasil.com/stats/competition/brasil-stats/89'
    
# descomentar a linha abaixo para testes de outros campeonatos
#url = 'https://www.academiadasapostasbrasil.com/stats/competition/china-stats/51'
try:
    ent = int(entrada)
    bot_brasil(url, ent - 1)
except:
    if entrada == 'toda':
        bot_brasil(url,'toda')
    else:
        print('\n')
        print('Opção inválida ;)')

driver.quit()

