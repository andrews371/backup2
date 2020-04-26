#!/usr/bin/env python
# coding: utf-8

# In[4]:


# bot punter 

import threading
import pandas as pd
import numpy as np
import requests
from bs4 import BeautifulSoup as bs
from selenium import webdriver 
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait # para aguardar o carregamento de elemento da página
from selenium.webdriver.support import expected_conditions as EC # para aguardar o carregamento de elemento da página
from selenium.webdriver.common.by import By # para o "By" quando tiver aguardando o carregamento de elemento da página
from IPython.core.display import display, HTML
display(HTML("<style>.container { width:99% !important; }</style>"))
from os import environ
environ['PYGAME_HIDE_SUPPORT_PROMPT'] = '1'
import pygame  # it is important to import pygame after that
import time
import os
import telepot

bot = telepot.Bot('1034437479:AAEpdm6sH0UMifWevzP-707vRzRHqgOTcT8')

# para manipular abas com o firefox
os.environ['MOZ_FORCE_DISABLE_E10S'] = '1' # lembrar de colocar 1 depois do igual para este uso

#Pandas Settings
pd.options.display.float_format = '{:,.2f}'.format


# ## Estratégias

# In[ ]:


def bhct(page, i, lista_hct, tam_lista_hct, liga_tipster):   
    
    # checando se a competição do dia passada faz parte da estratégia       
    for j in range(tam_lista_hct):
        if liga_tipster == lista_hct[j]:
            # daqui para baixo analisamos os jogos da liga que foi passada
            tam_jogos = len(page.find_all('table',{'class':'games'})[i].find('tbody').find_all('tr')) 
            
            # analisando se os jogos se encaixam na estratégia
            # CONDIÇÃO "LIGA" ACEITA
            
            # varrendo os jogos da liga
            # para cada jogo vamos ver a condição de nao ter vencido nenhuma das ultimas 5 partidas no geral
            for k in range(tam_jogos):
                page1 = page
                cont_lay = 0
                # aqui vão ficar os detalhes do evento que será o array diferente de vazio se o investimento compensar
                # ou seja, se se encaixar na estratégia
                investimento = []

                # nome das equipes
                times = page1.find_all('table',{'class':'games'})[i].find('tbody').find_all('tr')[k].find('a').text.strip()
                data = page1.find('',{'id':'dateHeader'}).text.strip()
                
                # abrindo a página do jogo com as últimas partidas do time da casa no geral na liga
                partida = page1.find_all('table',{'class':'games'})[i].find('tbody').find_all('tr')[k].find('a').get('href')
                partida = 'https://tipsterarea.com/' + partida
                link = requests.get(partida)
                page1 = bs(link.text, 'html.parser')
                
                partida = page1.find_all('div',{'class':'gameStatLinkWrapper'})[0].find('a').get('href').split('league-home')[0]
                partida = 'https://tipsterarea.com' + partida
                link = requests.get(partida)
                page1 = bs(link.text, 'html.parser')
                
                # verificando as 5 últimas partidas
                for contador in range(5):
                    
                    # detalhes da partida
                    placar = page1.find_all('tbody')[1].find_all('tr')[contador].find_all('td')[3].text.strip()
                    
                    # posicao do mandante - para saber se o time em questão é mandante naquele jogo e facilitar
                    # o calculo das partias sem vencer no geral
                    try:
                        teste = page1.find_all('tbody')[1].find_all('tr')[contador].find_all('td')[2].find('span').get('class')[0]
      
                        gh = int(placar[0])
                        ga = int(placar[4])
                        
                        if gh <= ga:
                            cont_lay += 1
                        else:
                            break
                    except:
                        # entra aqui se o time em questão estiver jogando fora de casa e então muda o calculo
                        # dos gols para saber quem fez mais (mandante ou visitante) e assim saber quem venceu a partida
                        gh = int(placar[0])
                        ga = int(placar[4])
                        
                        if gh >= ga:
                            cont_lay += 1
                        else:
                            break

                if cont_lay == 3:
                    # CONDIÇÃO "NÃO TER VITÓRIA NAS ULTIMAS 5 PARTIDAS NO GERAL" ACEITA
                    
                    # ver condição odds home
                    odd = odds_home('https://www.oddsportal.com/soccer/england/league-one/burton-milton-keynes-dons-Iio8ZDb7/')
                    odd = float(odd)
                    if odd >= 1.7 and odd <= 8:
                        # CONDIÇÃO DE ODD ACEITA - ESTRATÉGIA ACEITA
                        investimento.append(liga_tipster)
                        investimento.append(times)
                        investimento.append(data)
                        investimento.append('Back Home Contra Tendência')
                        
                        # mostrando os jogos que se encaixaram na estratégia
                        print(investimento)
                        
     
            # achou a liga e trabalhou nela, nao tem mais que comparar, pula para a próxima
            break        


# In[5]:


def over_25(i, page, leagues_o25, tam_leagues_o25, teams_o25, tam_teams_o25, data):
    
    lista_picks = []
    
    # país e liga
    ligas_do_dia = page.find('tbody').find_all('tr')[i].find_all('th')[0].find_all('a')[0].text.strip()                   + ' ' + page.find('tbody').find_all('tr')[i].find_all('th')[0].find_all('a')[1].text.strip()
    
    # analisando o filtro de ligas da estratégia 
    ligas_do_dia = page.find('tbody').find_all('tr')[i].find_all('th')[0].find_all('a')[0].text.strip()
    pais = ligas_do_dia
    liga = page.find('tbody').find_all('tr')[i].find_all('th')[0].find_all('a')[1].text.strip()
    ligas_do_dia = pais + ' ' + liga

    # analisando o filtro de ligas da estratégia 
    for j in range(tam_leagues_o25):
        if ligas_do_dia == leagues_o25[j]:

            # filtro de ligas da estratégia ACEITO

            var = i + 1

            # analisando o filtro de times da estratégia
            while var != 0:                                                                       
                try:

                    # pegando hora
                    hora = page.find('tbody').find_all('tr')[var].find_all('td')[0].text.strip() 

                    # país
                    pais = page.find('tbody').find_all('tr')[i].find_all('th')[0].find_all('a')[0].text.strip()
                    
                    # liga
                    liga = page.find('tbody').find_all('tr')[i].find_all('th')[0].find_all('a')[1].text.strip()

                    # pegando nome das equipes
                    equipes = page.find('tbody').find_all('tr')[var].find_all('td')[1].text.strip()
                    
                    # quebrando em time da casa e visitante
                    times_do_dia = equipes.split(' - ')

                    for k in range(tam_teams_o25):
                        if (times_do_dia[0] == teams_o25[k]) or (times_do_dia[1] == teams_o25[k]):
                            
                            # filtro de times ACEITO
                            url_inicial = 'https://www.oddsportal.com'
                            tam_url = len(page.find('tbody').find_all('tr')[var].find_all('td')[1].find_all('a'))
                            url = url_inicial + page.find('tbody').find_all('tr')[var].find_all('td')[1].find_all('a')[tam_url - 1].get('href')
                           
                            # verificando o filtro de odds do empate que faz parte da estratégia over
                            odd = odds_draw(url)
                            odd = float(odd)
                            
                            if (odd >= 3.20):  
                                
                                # filtro de odds ACEITO
                                
                                data_metodo = 'Data: ' + data
                                hora = 'Hora: ' + hora
                                pais = 'País: ' + pais
                                liga = 'Liga: ' + liga
                                equipes = 'Equipes: ' + equipes
                                
                                lista_picks.append(data_metodo)
                                lista_picks.append(hora)
                                lista_picks.append(pais)
                                lista_picks.append(liga)
                                lista_picks.append(equipes)
                                lista_picks.append('Método: Over 2.5 gols')
                            
                            break
                                
                    var += 1
                except:
                    var = 0
                    continue

            break
    
    return lista_picks


# In[ ]:


def bhft(i):
    # daqui para baixo analisamos os jogos da liga que foi passada
    tam_jogos = page.find_all('table',{'class':'games'})[i].find('tbody').find_all('tr')


# In[ ]:


def under_25(i):
    # daqui para baixo analisamos os jogos da liga que foi passada
    tam_jogos = page.find_all('table',{'class':'games'})[i].find('tbody').find_all('tr')


# In[ ]:


def odds_home(url):
    # descomentar estas 4 próximas linhas para usar o navegador invisível
    #gecko = '/home/andre/Downloads/geckodriver'
    #driver = webdriver.FirefoxOptions()
    #driver.add_argument('-headless')
    #driver = webdriver.Firefox(executable_path=gecko, options=driver)

    # comentar a linha abaixo se for usar o navegador invisível e descomentar linhas no topo
    driver = webdriver.Firefox() 
    driver.get(url)
    time.sleep(1)

    for i in range(1, 20):  
        var = str(i)                                     
        bookmaker = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(1) > div:nth-child(1) > a:nth-child(2)').text
        if bookmaker == 'Pinnacle':     
            
            # pegando a odd de abertura do match odds - home
            elem_opening_odd = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(2)')
            hov = ActionChains(driver).move_to_element(elem_opening_odd)
            hov.perform()
            data_in_the_bubble = driver.find_element_by_xpath("//*[@id='tooltiptext']")
            ooh = data_in_the_bubble.get_attribute("innerHTML").split('Opening odds:')[1].split('<strong>')[1].split('</strong>')[0]
            break
    
    driver.quit()
    
    return ooh


# In[3]:


def odds_draw(url):  
    
    # descomentar estas 4 próximas linhas para usar o navegador invisível
    gecko = '/home/andre/Downloads/geckodriver'
    driver = webdriver.FirefoxOptions()
    driver.add_argument('-headless')
    driver = webdriver.Firefox(executable_path=gecko, options=driver)

    # comentar a linha abaixo se for usar o navegador invisível e descomentar linhas no topo
    # driver = webdriver.Firefox() 

    # acessa página
    driver.get(url)
    time.sleep(3)
          
    # aguardando carregamento de elemento da página
    WebDriverWait(driver, 120).until(EC.presence_of_element_located((By.CSS_SELECTOR, 'tr.lo:nth-child(9) > td:nth-child(1) > div:nth-child(1) > a:nth-child(2)')))
    time.sleep(3)   

    # pegando a odd do match odds
    
    # draw
    bookmaker = ''
    ood = ''
    for i in range(1, 20):  
        var = str(i)            
        try:
            bookmaker = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(1) > div:nth-child(1) > a:nth-child(2)').text
            if bookmaker == 'Pinnacle':                      

                # pegando a odd de abertura do match odds - draw        
                elem_opening_odd = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(3)')
                hov = ActionChains(driver).move_to_element(elem_opening_odd)
                hov.perform()
                data_in_the_bubble = driver.find_element_by_xpath("//*[@id='tooltiptext']")
                ood = data_in_the_bubble.get_attribute("innerHTML").split('Opening odds:')[1].split('<strong>')[1].split('</strong>')[0] 
                time.sleep(1)
                print('oi 1')
                break
        except:
            continue

    # se este if for aceito, então nao executou todo o if referente à pinnacle acima
    print(f'bookmaker = {bookmaker}')
    if ood == '':
        print('oi 2')
        # rolando a página mais para baixo
        body = driver.find_element_by_css_selector('body')
        body.send_keys(Keys.PAGE_DOWN)
        time.sleep(1)

        for i in range(1, 20):  
            var = str(i)            
            try:
                bookmaker = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(1) > div:nth-child(1) > a:nth-child(2)').text
                if bookmaker == 'Pinnacle':                      

                    # pegando a odd de abertura do match odds - draw        
                    elem_opening_odd = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(3)')
                    hov = ActionChains(driver).move_to_element(elem_opening_odd)
                    hov.perform()
                    data_in_the_bubble = driver.find_element_by_xpath("//*[@id='tooltiptext']")
                    ood = data_in_the_bubble.get_attribute("innerHTML").split('Opening odds:')[1].split('<strong>')[1].split('</strong>')[0]
                    time.sleep(1)
                    break
            except:
                continue

    
    driver.quit()
    
    return ood


# In[ ]:


def odds_away(url):
    # descomentar estas 4 próximas linhas para usar o navegador invisível
    gecko = '/home/andre/Downloads/geckodriver'
    driver = webdriver.FirefoxOptions()
    driver.add_argument('-headless')
    driver = webdriver.Firefox(executable_path=gecko, options=driver)

    # comentar a linha abaixo se for usar o navegador invisível e descomentar linhas no topo
    #driver = webdriver.Firefox() 
    driver.get(url)
    time.sleep(1)

    # pegando a odd do match odds
    
    # away
    for i in range(1, 20):  
        var = str(i)                                     
        bookmaker = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(1) > div:nth-child(1) > a:nth-child(2)').text
        if bookmaker == 'Pinnacle': 
            
            # pegando a odd de abertura do match odds - away
            elem_opening_odd = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(4)')
            hov = ActionChains(driver).move_to_element(elem_opening_odd)
            hov.perform()
            data_in_the_bubble = driver.find_element_by_xpath("//*[@id='tooltiptext']")
            ooa = data_in_the_bubble.get_attribute("innerHTML").split('Opening odds:')[1].split('<strong>')[1].split('</strong>')[0]
            break
        
    driver.quit()
    
    return ooa


# In[ ]:


def odds_over(url):
    # descomentar estas 4 próximas linhas para usar o navegador invisível
    gecko = '/home/andre/Downloads/geckodriver'
    driver = webdriver.FirefoxOptions()
    driver.add_argument('-headless')
    driver = webdriver.Firefox(executable_path=gecko, options=driver)

    # comentar a linha abaixo se for usar o navegador invisível e descomentar linhas no topo
    #driver = webdriver.Firefox() 
    driver.get(url)
    time.sleep(1)
    
    # clicando no mercado over e under
    driver.find_element_by_css_selector('.ul-nav > li:nth-child(5) > a:nth-child(1)').click()
    time.sleep(4)
    
    body = driver.find_element_by_css_selector('body')
    body.send_keys(Keys.PAGE_DOWN)
    time.sleep(1)

    # clicando em over/under 2.5          
    driver.find_element_by_css_selector('div.table-container:nth-child(12) > div:nth-child(1) > strong:nth-child(1) > a:nth-child(1)').click()
    time.sleep(1)
    
    body = driver.find_element_by_css_selector('body')
    body.send_keys(Keys.PAGE_DOWN)
    time.sleep(1)
    
    # odd over 2.5
    for i in range(1, 20):  
        var = str(i)                          
        bookmaker = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(1) > div:nth-child(1) > a:nth-child(2)').text
        if bookmaker == 'Pinnacle':     
            
            # odd de abertura de over 2.5               
            elem_opening_odd = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(3)')
            hov = ActionChains(driver).move_to_element(elem_opening_odd)
            hov.perform()
            data_in_the_bubble = driver.find_element_by_xpath("//*[@id='tooltiptext']")
            opening_odd_over = data_in_the_bubble.get_attribute("innerHTML").split('Opening odds:')[1].split('<strong>')[1].split('</strong>')[0]
            break

    
    driver.quit()
    
    return opening_odd_over


# In[ ]:


def odds_under(url):
    # descomentar estas 4 próximas linhas para usar o navegador invisível
    gecko = '/home/andre/Downloads/geckodriver'
    driver = webdriver.FirefoxOptions()
    driver.add_argument('-headless')
    driver = webdriver.Firefox(executable_path=gecko, options=driver)

    # comentar a linha abaixo se for usar o navegador invisível e descomentar linhas no topo
    #driver = webdriver.Firefox() 
    driver.get(url)
    time.sleep(1)
    
    # clicando no mercado over e under
    driver.find_element_by_css_selector('.ul-nav > li:nth-child(5) > a:nth-child(1)').click()
    time.sleep(4)
    
    body = driver.find_element_by_css_selector('body')
    body.send_keys(Keys.PAGE_DOWN)
    time.sleep(1)

    # clicando em over/under 2.5          
    driver.find_element_by_css_selector('div.table-container:nth-child(12) > div:nth-child(1) > strong:nth-child(1) > a:nth-child(1)').click()
    time.sleep(1)
    
    body = driver.find_element_by_css_selector('body')
    body.send_keys(Keys.PAGE_DOWN)
    time.sleep(1)
    
    # odd under 2.5
    for i in range(1, 20):  
        var = str(i)                          
        bookmaker = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(1) > div:nth-child(1) > a:nth-child(2)').text
        if bookmaker == 'Pinnacle':     
            
            # odd de abertura de under 2.5               
            elem_opening_odd = driver.find_element_by_css_selector('tr.lo:nth-child('+ var +') > td:nth-child(4)')
            hov = ActionChains(driver).move_to_element(elem_opening_odd)
            hov.perform()
            data_in_the_bubble = driver.find_element_by_xpath("//*[@id='tooltiptext']")
            opening_odd_under = data_in_the_bubble.get_attribute("innerHTML").split('Opening odds:')[1].split('<strong>')[1].split('</strong>')[0]
            break

    
    driver.quit()
    
    return opening_odd_under


# In[4]:


def telegram(picks, id_telegram):
    
    tam_picks = len(picks)
    if tam_picks > 0:
        tips = ''
        data = picks[0].split(':')[1].replace('.','/')
        tam_id_telegram = len(id_telegram)

        for i in range(tam_picks):

            # formatando a hora
            if picks[i].split(":")[0] == 'Hora':
                tips = tips + '*' + picks[i].split(":")[0] + ':' '*' + picks[i].split(":")[1] + ':' + picks[i].split(":")[2] + '\n'
                flag = False
            else:
                tips = tips + '*' + picks[i].split(":")[0] + ':' '*' + picks[i].split(":")[1] + '\n'

            # quebrando linha entre uma tip e outra
            if picks[i].split(":")[0] == 'Método':
                tips = tips + '\n'

        for i in range(tam_id_telegram):
            bot.sendMessage(id_telegram[i], '*TIPS DO DIA* \n\n' + tips, parse_mode = 'Markdown')
        
    else:
        print('Nenhuma tip para esta data')


# In[8]:


# Script principal

# CAMPOS PARA EDITAR: "dia_data", "mes_data", "id_telegram", e a estratégia que deseja chamar (over, back home, under, etc)

# passar todo dia para o bot o link com a data futura de jogos para ele analisar
# em data so precisa passar os dias. Caso precise mudar mês ou ano, muda na url em seguida

entrada = input('Data para o escaneamento: ')
dia_data = entrada[0:2]
mes_data = entrada[2:4]
ano_data = entrada[4:8]

# descomentar estas 4 próximas linhas para usar o navegador invisível
gecko = '/home/andre/Downloads/geckodriver'
driver = webdriver.FirefoxOptions()
driver.add_argument('-headless')
driver = webdriver.Firefox(executable_path=gecko, options=driver)

# comentar a linha abaixo se for usar o navegador invisível e descomentar linhas no topo
#driver = webdriver.Firefox() 

# ids para envio das picks
id_telegram = []

# telegram de André
id_telegram.append(681368147)
# telegram de Fábio
#id_telegram.append(686789160)

url = 'https://www.oddsportal.com/matches/soccer/' + ano_data + mes_data + dia_data   
driver.get(url)
time.sleep(3)

data = dia_data + '.' + mes_data + '.' + ano_data

# lista de todos os times do betaminic (até agora escrito igual ao oddsportal)
arquivo = open('times_beta.txt')
teams = arquivo.read().split('\n')
tam_teams = len(teams)
arquivo.close()

# lista de todas as competições do betaminic (até agora escrito igual ao oddsportal)
arquivo = open('ligas_beta.txt')
leagues = arquivo.read().split('\n')
tam_leagues = len(leagues)
arquivo.close()


# lista de ligas do back home contra tendencia
arquivo = open('/home/andre/Documents/bots/Betaminic strategies/hct/ligas_hct.txt')
leagues_hct = arquivo.read().split('\n')
tam_leagues_hct = len(leagues_hct)
arquivo.close()

# lista de ligas do over 2.5 
arquivo = open('/home/andre/Documents/bots/Betaminic strategies/over25/ligas_over25.txt')
leagues_o25 = arquivo.read().split('\n')
tam_leagues_o25 = len(leagues_o25)
arquivo.close()

# lista de times do over 2.5
arquivo = open('/home/andre/Documents/bots/Betaminic strategies/over25/times_over25.txt')
teams_o25 = arquivo.read().split('\n')
tam_teams_o25 = len(teams_o25)
arquivo.close()

# lista de times home a favor do tempo
arquivo = open('/home/andre/Documents/bots/Betaminic strategies/hft/times_hft.txt')
teams_hft = arquivo.read().split('\n')
tam_teams_hft = len(teams_hft)
arquivo.close()

# lista de times under 2.5 
arquivo = open('/home/andre/Documents/bots/Betaminic strategies/under25/times_under25.txt')
teams_u25 = arquivo.read().split('\n')
tam_teams_u25 = len(teams_u25)
arquivo.close()

# configurando site com a hora de brasília
driver.find_element_by_css_selector('#user-header-timezone-expander').click()


Create = WebDriverWait(driver, 120).until(EC.presence_of_element_located((By.CSS_SELECTOR, '#timezone-content > a:nth-child(67)')))
time.sleep(3)
Create.click()
time.sleep(9)

html = driver.execute_script("return document.documentElement.outerHTML")
page = bs(html, 'html.parser')

tam_ligas_do_dia = len(page.find('tbody').find_all('tr'))
picks = []

for i in range(tam_ligas_do_dia):
    try:
        classe_liga = page.find('tbody').find_all('tr')[i].get('class')[0]
        if classe_liga == 'dark':
            for j in range(tam_leagues):
                # analisando o filtro de ligas da estratégia 
                ligas_do_dia = page.find('tbody').find_all('tr')[i].find_all('th')[0].find_all('a')[0].text.strip()
                ligas_do_dia = ligas_do_dia + ' ' + page.find('tbody').find_all('tr')[i].find_all('th')[0].find_all('a')[1].text.strip()
                if ligas_do_dia == leagues[j]:
                    
                    # filtro de ligas do betaminic ACEITO
                    
                    # chamando o Método Over 2.5
                    lista_de_picks = over_25(i, page, leagues_o25, tam_leagues_o25, teams_o25, tam_teams_o25, data)
                    tam_lista_de_picks = len(lista_de_picks)
                    
                    for k in range(tam_lista_de_picks):
                        picks.append(lista_de_picks[k])                    
                    
    except:
        continue
        
print('Escaneamento Completo.')

# mandando as picks do Over 2.5 pelo telegram
telegram(picks, id_telegram)
driver.quit()

