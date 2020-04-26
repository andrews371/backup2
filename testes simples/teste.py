import time

'''
print(1)
time.sleep(0.4)
print(2)
time.sleep(0.4)
print(3)
time.sleep(0.4)
print(4)
time.sleep(0.4)
print(5)
time.sleep(0.4)
print(6)
'''
pass

ler = int(input('informe um valor de tensão analógica -> '))
x = (ler * 5) / 255
print(f'correspondente digital -> {x:.1f}')