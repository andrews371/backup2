# preenchendo um campo e apertando backspace (espaço)
# usei a documentação do webdriver firefox selenium em python 
# para pegar comandos de tecla

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time

url = 'https://10fastfingers.com/competition/5d72111083a45'
driver = webdriver.Firefox()
driver.get(url)
login = driver.find_element_by_css_selector('ul.nav:nth-child(5) > li:nth-child(2) > a:nth-child(1)').click()
login = driver.find_element_by_css_selector('#UserEmail')
login.send_keys('aoliveira371@gmail.com')
login = driver.find_element_by_css_selector('#UserPassword')
login.send_keys('091225')
login.send_keys(Keys.RETURN)
time.sleep(5)

while True:
	try:
	    elemento = driver.find_element_by_css_selector('#inputfield')
	    palavra = driver.find_element_by_css_selector('.highlight').text
	    elemento.send_keys(palavra)
	    elemento.send_keys(Keys.SPACE)
	except:
		print('Terminou...')
		break
print('fim do while')