#!/usr/bin/env python
# coding: utf-8

# In[1]:


import threading
import pandas as pd
import numpy as np
from bs4 import BeautifulSoup
import requests
from IPython.core.display import display, HTML
display(HTML("<style>.container { width:99% !important; }</style>"))
from os import environ
environ['PYGAME_HIDE_SUPPORT_PROMPT'] = '1'
import pygame  # it is important to import pygame after that
import time

#Pandas Settings
pd.options.display.float_format = '{:,.2f}'.format


# In[2]:


def scanner(inicio, fim, cont_data):
    
    url = 'http://18.231.88.179/sites/scanner.php?timeI=0&timeF=0'      
    link = requests.get(url)
    page = BeautifulSoup(link.text, 'html.parser')

    jogo = page.find_all('tr')
    head = page.find_all('',{'class':'text-center'})
    tam_head = len(page.find_all('',{'class':'text-center'}))

    # para dá toque de alerta quando chamada a função de toque
    pygame.init()
    pygame.mixer.music.load('toque.mpeg')  
    
    # flag para indicar quando a função deve parar
    func = True
    if (len(jogo) - 1) == 0:
        func = False

    print(f'quant jogos: {len(jogo) - 1}')
    
    # varredura de jogos
    for i in range(1,len(jogo)):
        print(f'jogo {i}')
        
        # tentando mais de uma vez pegar os dados do jogo caso surja erro
        for k in range(3): 
            
            # flag para confirmar que o placar nao mudou enquanto se armazenavam as odds
            mudou_placar = True
            
            try:

                # varredura de atributos do jogo
                for j in range(11):

                    # caminho de cada dado mudando apenas o "j" para cada dado
                    dado = jogo[i].find_all('td')[j]

                    # tempo de jogo
                    if j == 0:
                        tempo = dado.text.split("'")[0].split('+')[0]
                        print(f'tempo {tempo}')
                
                    # placar
                    elif j == 1:
                        placar = dado.text.replace(' - ','x')

                    # equipes
                    elif j == 2:
                        times = dado.text
                        print(times)

                    # chutes no gol
                    elif j == 3: 
                        chutesnogolcasa = dado.find('div').text

                        # separando atributos de casa e visitante
                        if (dado.text.split(chutesnogolcasa)[1]) == '':
                            chutesnogolvisitante = chutesnogolcasa
                        else:
                            chutesnogolvisitante = dado.text.split(chutesnogolcasa)[1]

                    # chutes fora do gol 
                    elif j == 4:
                        chutesforagolcasa = dado.find('div').text

                        # separando atributos de casa e visitante
                        if (dado.text.split(chutesforagolcasa)[1]) == '':
                            chutesforagolvisitante = chutesforagolcasa
                        else:
                            chutesforagolvisitante = dado.text.split(chutesforagolcasa)[1]
                            
                    # escanteios
                    elif j == 5:
                        escanteioscasa = dado.find('div').text

                        # separando atributos de casa e visitante
                        if (dado.text.split(escanteioscasa)[1]) == '':
                            escanteiosvisitante = escanteioscasa
                        else:
                            escanteiosvisitante = dado.text.split(escanteioscasa)[1]

                    # ataques perigosos
                    elif j == 6:
                        ataquesperigososcasa = dado.find('div').text

                        # separando atributos de casa e visitante
                        if (dado.text.split(ataquesperigososcasa)[1]) == '':
                            ataquesperigososvisitante = ataquesperigososcasa
                        else:
                            ataquesperigososvisitante = dado.text.split(ataquesperigososcasa)[1]

                    # posse de bola
                    elif j == 7:
                        possecasa = dado.find('div').text

                        # separando atributos de casa e visitante
                        if (dado.text.split(possecasa)[1]) == '':
                            possevisitante = possecasa
                        else:
                            possevisitante = dado.text.split(possecasa)[1]

                    # PI 2
                    elif j == 8:
                        pi2casa = dado.find('div').text

                        # separando atributos de casa e visitante
                        if (dado.text.split(pi2casa)[1]) == '':
                            pi2visitante = pi2casa
                        else:
                            pi2visitante = dado.text.split(pi2casa)[1]

                    # PI 1
                    elif j == 9:
                        pi1casa = dado.find('div').text

                        # separando atributos de casa e visitante
                        if (dado.text.split(pi1casa)[1]) == '':
                            pi1visitante = pi1casa
                        else:
                            pi1visitante = dado.text.split(pi1casa)[1]

                    # link com odds
                    elif j == 10:
                        for tentar_de_novo in range(3):
                            try:                            
                                # acessando a página de odds
                                linkodds = 'http://18.231.88.179/sites/' + dado.find('a').get('href').split('/')[1]

                                # pegando as odds e informações do campeonato se tiver
                                link = requests.get(linkodds)
                                page2 = BeautifulSoup(link.text, 'html.parser')          
                        
                                # Pegando o nome das equipes direto da tabela de odds para comparar se estamos nas odds dos times certos
                                # Não pego direto de "Evento" pq nem sempre os nomes estão disponíveis ali
                                time1 = page2.find_all('tr')[1].find_all('td')[1].text
                                time2 = page2.find_all('tr')[3].find_all('td')[0].text
                                times_secao_odds = time1 + ' x ' + time2 
                                
                                tempo_secao_odds = page2.find_all('center')[0].text.split('Placar: ')[1].split('Tempo: ')[1].split("'")[0].split('+')[0]

                                # verificando se a página de odds é a do time em questão e o mesmo para o tempo
                                if (times_secao_odds == times) and (tempo_secao_odds == tempo) :
                                    print(f'link com as odds {linkodds}')

                                    # data
                                    data = page2.find('h6').text.split('Atualizado em ')[1][0:10]

                                    # campeonato
                                    campeonato = page2.find_all('center')[0].text.split('Campeonato: ')[1].split('Evento: ')[0]
                                    print(campeonato)

                                    # odds - match odds

                                    # home back e lay
                                    home_back = page2.find_all('tr')[1].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(home_back)                            
                                    home_lay = page2.find_all('tr')[1].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(home_lay)

                                    # empate back e lay
                                    draw_back = page2.find_all('tr')[2].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(draw_back)                            
                                    draw_lay = page2.find_all('tr')[2].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(draw_lay)

                                    # away back e lay
                                    away_back = page2.find_all('tr')[3].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(away_back)                            
                                    away_lay = page2.find_all('tr')[3].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(away_lay)

                                    # odds - over e under

                                    # Over 1.5 back e lay
                                    o15_back = page2.find_all('tr')[4].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(o15_back)                            
                                    o15_lay = page2.find_all('tr')[4].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(o15_lay)

                                    # Under 1.5 back e lay
                                    u15_back = page2.find_all('tr')[5].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(u15_back)                            
                                    u15_lay = page2.find_all('tr')[5].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(u15_lay)

                                    # Over 2.5 back e lay
                                    o25_back = page2.find_all('tr')[6].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(o25_back)                            
                                    o25_lay = page2.find_all('tr')[6].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(o25_lay)

                                    # Under 2.5 back e lay
                                    u25_back = page2.find_all('tr')[7].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(u25_back)                            
                                    u25_lay = page2.find_all('tr')[7].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(u25_lay)

                                    # Over 3.5 back e lay
                                    o35_back = page2.find_all('tr')[8].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(o35_back)                            
                                    o35_lay = page2.find_all('tr')[8].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(o35_lay)

                                    # Under 3.5 back e lay
                                    u35_back = page2.find_all('tr')[9].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(u35_back)                            
                                    u35_lay = page2.find_all('tr')[9].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(u35_lay)

                                    # Over 4.5 back e lay
                                    o45_back = page2.find_all('tr')[10].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(o45_back)                            
                                    o45_lay = page2.find_all('tr')[10].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(o45_lay)

                                    # Under 4.5 back e lay
                                    u45_back = page2.find_all('tr')[11].find('td',{'bgcolor':'#1E90FF'}).text
                                    print(u45_back)                            
                                    u45_lay = page2.find_all('tr')[11].find('td',{'bgcolor':'#FF69B4'}).text
                                    print(u45_lay)

                                    # odds - correct score

                                    # Goleada casa
                                    goleadacasa_back = page2.find_all('td',{'bgcolor':'#1E90FF'})[27].text
                                    print(goleadacasa_back)                            
                                    goleadacasa_lay = page2.find_all('td',{'bgcolor':'#FF69B4'})[27].text
                                    print(goleadacasa_lay)

                                    # Goleada fora
                                    goleadafora_back = page2.find_all('td',{'bgcolor':'#1E90FF'})[28].text
                                    print(goleadafora_back)                            
                                    goleadafora_lay = page2.find_all('td',{'bgcolor':'#FF69B4'})[28].text
                                    print(goleadafora_lay)

                                    # Outro empate
                                    outroempate_back = page2.find_all('td',{'bgcolor':'#1E90FF'})[29].text
                                    print(outroempate_back)                            
                                    outroempate_lay = page2.find_all('td',{'bgcolor':'#FF69B4'})[29].text
                                    print(outroempate_lay)

                                    placar_secao_odds = page2.find_all('center')[0].text.split('Placar: ')[1].split(' Tempo: ')[0].replace(' - ', 'x')

                                    if placar_secao_odds == placar:
                                        # flag para checar se nao houve gol (e portanto mudança de odd) enquanto coletava as odds
                                        mudou_placar = False                                    
                                        print(f'times {times_secao_odds}')
                                        
                                    break
                                    
                                else:
                                    print('exceção: Times ou Tempo de pg principal e de odds não coincidem.')
                                    continue
                        
                            except:
                                print('exceção na pagina de odds')
                                
                                # voltando para a pagina inicial
                                url = 'http://18.231.88.179/sites/scanner.php?timeI=0&timeF=0'      
                                link = requests.get(url)
                                page = BeautifulSoup(link.text, 'html.parser')
                                continue
                
                break
                
            except:
                print('exceção na pagina de jogos')
                
                # voltando para a pagina inicial (caso tenha mudado para a pagina de odds e tenha tido exceção)
                url = 'http://18.231.88.179/sites/scanner.php?timeI=0&timeF=0'      
                link = requests.get(url)
                page = BeautifulSoup(link.text, 'html.parser')
                continue

        # CRIANDO UM DATAFRAME COM OS DADOS DA PARTIDA A CADA 10 MIN E ARMAZENANDO PARA FORMAR A BASE DE DADOS
        if (tempo == 'HT' or tempo == 'FT' or (int(tempo) % 10) == 0 or int(tempo) == 45 ) and (mudou_placar == False):
            print('CHEGUEI AQUI 111')
            
            # nome do arquivo que vai salvar os dados + extensão
            file = data.replace('/', '-')
            file = file + '-' + str(cont_data) + '.csv'
            
            # verificando se nao está mais salvando no arquivo atual
            if (fim - inicio) >= 1200:
                 # nome do arquivo que vai salvar os dados + extensão
                file = data.replace('/', '-')
                cont_data += 1
                file = file + '-' + str(cont_data) + '.csv'
                
                # atualizando a contagem de tempo para saber se ainda está salvando no arquivo atual
                inicio = time.time()
                fim = time.time()
            
            # ler o dataframe anterior para depois concatenar com o novo
            try:
                anterior_df = pd.read_csv(file)
            except:
                anterior_df = pd.DataFrame()
                pass

            # criando dataframe novo a cada 10 min
            atual_df = pd.DataFrame(                
                {'data':[data], 'campeonato':[campeonato] ,'times':[times], 'tempo':[tempo], 'placar':[placar], 'chutesnogolgolcasa':[chutesnogolcasa],
                 'chutesnogolvisitante':[chutesnogolvisitante], 'chutesforagolcasa':[chutesforagolcasa],
                 'chutesforagolvisitante':[chutesforagolvisitante], 'escanteioscasa':[escanteioscasa],
                 'escanteiosvisitante':[escanteiosvisitante], 'ataquesperigososcasa':[ataquesperigososcasa],
                 'ataquesperigososvisitante':[ataquesperigososvisitante], 'possecasa':[possecasa], 'possevisitante':[possevisitante],
                 'pi2casa':[pi2casa], 'pi2visitante':[pi2visitante], 'pi1casa':[pi1casa], 'pi1visitante':[pi1visitante],
                 'home_back':[home_back],'home_lay':[home_lay],'away_back':[away_back],'away_lay':[away_lay],'draw_back':[draw_back],
                 'draw_lay':[draw_lay],'o15_back':[o15_back],'o15_lay':[o15_lay],'u15_back':[u15_back],'u15_lay':[u15_lay],'o25_back':[o25_back],
                 'o25_lay':[o25_lay],'u25_back':[u25_back],'u25_lay':[u25_lay],'o35_back':[o35_back],'o35_lay':[o35_lay],'u35_back':[u35_back],
                 'u35_lay':[u35_lay],'o45_back':[o45_back],'o45_lay':[o45_lay],'u45_back':[u45_back],'u45_lay':[u45_lay],
                 'goleadacasa_back':[goleadacasa_back],'goleadacasa_lay':[goleadacasa_lay],'goleadafora_back':[goleadafora_back],
                 'goleadafora_lay':[goleadafora_lay],'outroempate_back':[outroempate_back],'outroempate_lay':[outroempate_lay]}
            ) 
           
            # colocando o dataframe anterior e o atual em uma lista
            list_frames = [anterior_df, atual_df]

            # concatenando a lista de dataframe em um único dataframe
            final_df = pd.concat(list_frames, sort=False)

            try:
                # eliminando coluna indesejada                
                final_df.drop(['Unnamed: 0'], inplace=True, axis=1)
            except:
                pass
                
            # atualizando o indice
            final_df = final_df.reset_index(drop=True)

            # convertendo valores possiveis no dataframe em numericos. Necessario para a busca de dados duplicados
            final_df = final_df.apply(pd.to_numeric, errors='ignore')

            # filtrando o tempo em questão e os times em questão para ver se já foram armazenados (verificando se estão duplicados)
            cont_dados_duplicados = final_df.duplicated(subset=['tempo', 'times'], keep='first').sum()

            print('CHEGUEI AQUI 22222')  
            fim = time.time()
            
            if cont_dados_duplicados == 0 :
                print('CHEGUEI AQUI 333')  
                
                # atualizando a contagem de tempo para saber se ainda está salvando no arquivo atual
                inicio = time.time()
                fim = time.time()

                # as vezes mostra ht ou ft mas logo em seguida muda para 45 ou 90 min. Tentar garantir
                # que só vão ser amazenados os dados nesse tempo se realmente for esse tempo
                if (tempo == 'HT'):
                    print('CHEGUEI AQUI 444')
                    atual2_df = pd.DataFrame(
                        {'data':[data], 'campeonato':[campeonato] ,'times':[times], 'tempo':['45'], 'placar':[placar], 'chutesnogolgolcasa':[chutesnogolcasa],
                         'chutesnogolvisitante':[chutesnogolvisitante], 'chutesforagolcasa':[chutesforagolcasa],
                         'chutesforagolvisitante':[chutesforagolvisitante], 'escanteioscasa':[escanteioscasa],
                         'escanteiosvisitante':[escanteiosvisitante], 'ataquesperigososcasa':[ataquesperigososcasa],
                         'ataquesperigososvisitante':[ataquesperigososvisitante], 'possecasa':[possecasa], 'possevisitante':[possevisitante],
                         'pi2casa':[pi2casa], 'pi2visitante':[pi2visitante], 'pi1casa':[pi1casa], 'pi1visitante':[pi1visitante],
                         'home_back':[home_back],'home_lay':[home_lay],'away_back':[away_back],'away_lay':[away_lay],'draw_back':[draw_back],
                         'draw_lay':[draw_lay],'o15_back':[o15_back],'o15_lay':[o15_lay],'u15_back':[u15_back],'u15_lay':[u15_lay],'o25_back':[o25_back],
                         'o25_lay':[o25_lay],'u25_back':[u25_back],'u25_lay':[u25_lay],'o35_back':[o35_back],'o35_lay':[o35_lay],'u35_back':[u35_back],
                         'u35_lay':[u35_lay],'o45_back':[o45_back],'o45_lay':[o45_lay],'u45_back':[u45_back],'u45_lay':[u45_lay],
                         'goleadacasa_back':[goleadacasa_back],'goleadacasa_lay':[goleadacasa_lay],'goleadafora_back':[goleadafora_back],
                         'goleadafora_lay':[goleadafora_lay],'outroempate_back':[outroempate_back],'outroempate_lay':[outroempate_lay]}
                    )

                    list_frames2 = [anterior_df, atual2_df]
                    final2_df = pd.concat(list_frames2, sort=False)
                    try:
                        final2_df.drop(['Unnamed: 0'], inplace=True, axis=1)
                    except:
                        pass

                    final2_df = final2_df.reset_index(drop=True)
                    final2_df = final2_df.apply(pd.to_numeric, errors='ignore')    
                    cont_dados_duplicados2 = final2_df.duplicated(subset=['tempo', 'times'], keep='first').sum()

                    if (cont_dados_duplicados2 == 0):
                        for key,row in final_df.iterrows():
                            if row['tempo'] == 'HT':
                                final_df.loc[key,'tempo'] = '45'
                                break
                        # salvando o dataframe construído a cada 10 min de cada partida
                        final_df.to_csv(file) 
                        time.sleep(0.2)

                    else:
                        # salvando o dataframe construído a cada 10 min de cada partida
                        final_df.to_csv(file) 
                        time.sleep(0.2)

                elif (tempo == 'FT'):
                    print('CHEGUEI AQUI 555')
                    atual2_df = pd.DataFrame(
                        {'data':[data], 'campeonato':[campeonato] ,'times':[times], 'tempo':['90'], 'placar':[placar], 'chutesnogolgolcasa':[chutesnogolcasa],
                         'chutesnogolvisitante':[chutesnogolvisitante], 'chutesforagolcasa':[chutesforagolcasa],
                         'chutesforagolvisitante':[chutesforagolvisitante], 'escanteioscasa':[escanteioscasa],
                         'escanteiosvisitante':[escanteiosvisitante], 'ataquesperigososcasa':[ataquesperigososcasa],
                         'ataquesperigososvisitante':[ataquesperigososvisitante], 'possecasa':[possecasa], 'possevisitante':[possevisitante],
                         'pi2casa':[pi2casa], 'pi2visitante':[pi2visitante], 'pi1casa':[pi1casa], 'pi1visitante':[pi1visitante],
                         'home_back':[home_back],'home_lay':[home_lay],'away_back':[away_back],'away_lay':[away_lay],'draw_back':[draw_back],
                         'draw_lay':[draw_lay],'o15_back':[o15_back],'o15_lay':[o15_lay],'u15_back':[u15_back],'u15_lay':[u15_lay],'o25_back':[o25_back],
                         'o25_lay':[o25_lay],'u25_back':[u25_back],'u25_lay':[u25_lay],'o35_back':[o35_back],'o35_lay':[o35_lay],'u35_back':[u35_back],
                         'u35_lay':[u35_lay],'o45_back':[o45_back],'o45_lay':[o45_lay],'u45_back':[u45_back],'u45_lay':[u45_lay],
                         'goleadacasa_back':[goleadacasa_back],'goleadacasa_lay':[goleadacasa_lay],'goleadafora_back':[goleadafora_back],
                         'goleadafora_lay':[goleadafora_lay],'outroempate_back':[outroempate_back],'outroempate_lay':[outroempate_lay]}
                    )

                    list_frames2 = [anterior_df, atual2_df]
                    final2_df = pd.concat(list_frames2, sort=False)
                    try:
                        final2_df.drop(['Unnamed: 0'], inplace=True, axis=1)
                    except:
                        pass

                    final2_df = final2_df.reset_index(drop=True)
                    final2_df = final2_df.apply(pd.to_numeric, errors='ignore')    
                    cont_dados_duplicados2 = final2_df.duplicated(subset=['tempo', 'times'], keep='first').sum()

                    if (cont_dados_duplicados2 == 0):
                        for key,row in final_df.iterrows():
                            if row['tempo'] == 'FT':
                                final_df.loc[key,'tempo'] = '90'
                                break

                        # salvando o dataframe construído a cada 10 min de cada partida
                        final_df.to_csv(file) 
                        time.sleep(0.2)

                    else:
                        # salvando o dataframe construído a cada 10 min de cada partida
                        final_df.to_csv(file) 
                        time.sleep(0.2)

                # o tempo nao era HT e nem FT
                else:
                    print('CHEGUEI AQUI 6')
                    # salvando o dataframe construído a cada 10 min de cada partida
                    final_df.to_csv(file)  
                    time.sleep(0.2)
        
            
            
        # aviso sonoro 

        # ambas marcam
        if tempo != 'HT' and tempo != 'FT':
            if (int(chutesnogolcasa) >= 3) and (placar == '0x1' or placar == '0x2' or placar == '0x3') and (int(tempo) <= 45):
                print('GRANDE CHANCE PARA AMBAS')
                print(times)

                # toca um áudio
                #pygame.mixer.music.play()
                time.sleep(2)

            elif (int(chutesnogolvisitante) >= 3) and (placar == '1x0' or placar == '2x0' or placar == '3x0') and (int(tempo) <= 45):
                print('GRANDE CHANCE PARA AMBAS')
                print(times)

                # toca um áudio
                #pygame.mixer.music.play()
                time.sleep(2)

        else:
            if (int(chutesnogolcasa) >= 3) and (placar == '0x1' or placar == '0x2' or placar == '0x3') and (tempo == 'HT'):
                print('GRANDE CHANCE PARA AMBAS')
                print(times)

                # toca um áudio
                #pygame.mixer.music.play()
                time.sleep(2)

            elif (int(chutesnogolvisitante) >= 3) and (placar == '1x0' or placar == '2x0' or placar == '3x0') and (tempo == 'HT'):
                print('GRANDE CHANCE PARA AMBAS')
                print(times)

                # toca um áudio
                #pygame.mixer.music.play()
                time.sleep(2)



        # over gols
        if tempo != 'HT' and tempo != 'FT':
            if (int(chutesnogolcasa) >= 3) and (int(chutesnogolvisitante) >= 3) and (placar == '1x0' or placar == '2x0' or placar == '0x1' or placar == '0x2') and (int(tempo) <= 45):
                print('GRANDE CHANCE PARA OVER')
                print(times)

                # toca um áudio
                #pygame.mixer.music.play()
                time.sleep(2)

            elif (int(chutesnogolcasa) >= 2) and (int(chutesnogolvisitante) >= 2) and (int(tempo) <= 20):
                print('GRANDE CHANCE PARA OVER')
                print(times)

                # toca um áudio
                #pygame.mixer.music.play()
                time.sleep(2)

        else:
            if (int(chutesnogolcasa) >= 3) and (int(chutesnogolvisitante) >= 3) and (placar == '1x0' or placar == '2x0' or placar == '0x1' or placar == '0x2') and (tempo == 'HT'):
                print('GRANDE CHANCE PARA OVER')
                print(times)

                # toca um áudio
                #pygame.mixer.music.play()
                time.sleep(2)




        # under gols
        if tempo != 'HT' and tempo != 'FT':
            if (int(chutesnogolcasa) >= 2) and (int(chutesnogolvisitante) == 0) and (int(tempo) >= 35 and int(tempo) <= 45) and (placar == '1x0' or placar == '2x0'):
                print('GRANDE CHANCE PARA UNDER')
                print(times)

                # toca um áudio
                #pygame.mixer.music.play()
                time.sleep(2)

            elif (int(chutesnogolvisitante) >= 2) and (int(chutesnogolcasa) == 0) and (int(tempo) >= 35 and int(tempo) <= 45) and (placar == '0x1' or placar == '0x2'):
                print('GRANDE CHANCE PARA UNDER')
                print(times)

                # toca um áudio
                #pygame.mixer.music.play()
                time.sleep(2)

        else:
            if (int(chutesnogolcasa) >= 2) and (int(chutesnogolvisitante) == 0) and (placar == '1x0' or placar == '2x0') and (tempo == 'HT'):
                print('GRANDE CHANCE PARA UNDER')
                print(times)

                # toca um áudio
                #pygame.mixer.music.play()
                time.sleep(2)

            elif (int(chutesnogolvisitante) >= 2) and (int(chutesnogolcasa) == 0) and (placar == '0x1' or placar == '0x2') and (tempo == 'HT'):
                print('GRANDE CHANCE PARA UNDER')
                print(times)

                # toca um áudio
                ##pygame.mixer.music.play()
                time.sleep(2)


        print('\n\n')
    return func, inicio, fim, cont_data


# In[ ]:


# função principal

# função que vai ser chamada por uma thread para sempre perguntar se quero parar o script
def worker():
    inp = ''
    while inp.lower() != 'sair':
        inp = input('Para finalizar digite "sair" ')
        
t = threading.Thread(target=worker)
t.start()

# chamando a função para fazer scanner in live
func = True
count = 0

# inicializando variaveis para contar tempo
inicio = time.time()
fim = time.time()

# final do nome do arquivo salvo quando nao puder salvar mais no atual
cont_data = 1

#while t.isAlive():
while (func == True or count < 3):
    try:
        func, inicio, fim, cont_data = scanner(inicio, fim, cont_data)
        if func == False:
            count += 1
            time.sleep(0.5)
        else:
            count = 0
            time.sleep(1)
    except:
        time.sleep(0.5)
    if count == 3:
        print('Nenhum jogo ao vivo neste momento.')
        count = 0

