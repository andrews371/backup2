# preenchendo um campo e apertando backspace (espaço)
# usei a documentação do webdriver firefox selenium em python 
# para pegar comandos de tecla

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time

url = 'https://www.youtube.com/watch?v=kdtkyYid7YA'
driver = webdriver.Firefox()
driver.get(url)
time.sleep(4)
login = driver.find_element_by_css_selector('yt-formatted-string.style-suggestive').click()
login = driver.find_element_by_css_selector('#identifierId')
login.send_keys('aoliveira371@gmail.com')
login.send_keys(Keys.RETURN)
time.sleep(2)
login = driver.find_element_by_css_selector('.I0VJ4d > div:nth-child(1) > input:nth-child(1)')
login.send_keys('09122509')
login.send_keys(Keys.RETURN)
time.sleep(15)
cont = 0

while cont < 20:
	try:
		cont += 1
		login = driver.find_element_by_xpath('')
		login.send_keys('joao pessoa na area')
		time.sleep(2)
		login.send_keys(Keys.RETURN)
	except:
		time.sleep(10)
		print('tentativa {}'.format(cont))
		
print('Bot finalizado')