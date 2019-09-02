# Firmware
Para a demulação AM no RDS (Rádio Definido por Software) será utilizado um ARM stm32f407 como microcontrolador. Primeiramente o sinal analógico, modulado em AM, será convertido para digital viabilizando o tratamento pelo microcontrolador. Para demodulação será utilizada a transformada de Hilbert realizando as operações exibidas no fluxograma abaixo e por último o sinal tratado será enviado por USB ou para um Speaker.

![Image FluxogramaDemodulacao](https://github.com/apct-2019/Firmware/blob/master/FluxogramaDemodulador.png)

Os requisitos de funcionamento do firmware são:
* Demodulação AM
* Conversão Analógico Digital
* Controle de Ganho Automático

## Demodulação AM

A demolução AM será feita pela transformada de Hilbert. A demodulação foi feita segunda a base teórica:

![Image Demodulação](https://github.com/apct-2019/Aquino/blob/master/Demod-formula.jpg)

Para uma primeira implementação foi desenvolvido um código em scilab que modula e demodula um sinal em AM. Este código servirá de base para o futuro código implementado no microcontrolador.

```scilab
BasebandFrequency = 10e3;
CarrierFrequency = 375e3;
SamplingFrequency = 1.5e6;
BufferLength = 200;
n = 0:(BufferLength - 1);
BasebandSignal = sin(2*%pi*n / (SamplingFrequency/BasebandFrequency));
CarrierSignal = sin(2*%pi*n / (SamplingFrequency/CarrierFrequency));

figure(1)
plot(n, BasebandSignal,"b")
plot(n, CarrierSignal,"r")
figure(2)
ModulatedSignal_AM = CarrierSignal.*(1+BasebandSignal);
plot(n, ModulatedSignal_AM, "b")

HilbAmSignal = hilbert(ModulatedSignal_AM);
Envelop = abs(HilbAmSignal)-1;
figure(3)
plot(n, BasebandSignal,"b")
plot(n, Envelop, "r")
```
Como resultado do código acima foram gerados os seguintes gráficos.

![Image Frequencia de Portadora e Banda Base](https://github.com/apct-2019/Aquino/blob/master/BasebandAndCarrierSignal.png)

Sinal da Portadora e da Banda Base

![Image Sinal Modulado em AM](https://github.com/apct-2019/Aquino/blob/master/AMSignal.png)

Sinal Modulado em AM

![Image Sinal Demodulado e Sinal Original](https://github.com/apct-2019/Aquino/blob/master/OriginalxDemodulatedSignal.png)

Sinal Demodulado e Sinal Original

Para o scilab a função hilbert(u) retorna u + i * û , ou seja para calcular a envoltória basta calcular o módulo do retorno da função.

## Conversor Analógico Digital

Para realização do circuito, primeiramente, é necessária que alguns parâmetros essenciais a todo circuito sejam definidos. Estes parâmetros são:

* Amplitude máxima de sinal
* Resolução do Conversor AD
* Ranger Dinâmico
* Taxa de Amostragem do Conversor AD
* Frequencia Intermediária


### Amplitude Máxima de Sinal
Segundo o datasheet do microcontrolador, a amplitude máxima permetida para a conversão é de 3,6 Volts, porém será aplicada um percentual de 70% da voltagem máxima como margem de segurança para garantir o bom funcionamento da conversão, com isso a Amplitude máxima de sinal será de 2,5 Volts.

### Resolução do Conversor AD

A resolução do conversor é programavel assumindo os valores de 6-bit, 8-bit, 10-bit ou 12-bit. Para garantir a melhor perfomance possível foi escolhido 12-bit como resolução de conversão o que garante 4095 niveis de quantização.

### Ranger Dinâmico 

O ranger dinâmico mede quão sensível a conversão é para pequenas variações. O ranger é calculado utilizando a seguinte fórmula:
RD = Maxima Voltagem/ Minima Voltagem
Minima Voltagem = Maxima Voltagem/ # Niveis de Quantização

com isso RD é igual a 4095 ou 72,2 dB.

### Taxa de Amostragem do Conversor AD

A taxa de Amostragem do Conversor AD é calculada em função do Período de Amostragem e este é programavel. O Período de Amostragem é 12 ciclos de ADCClk mais x ciclos, onde x pode ser 3 15 28 56 84 112 144 480. A frequencia do ADCClk é programavel como f/2, f/4, f/6, f/8 onde f é a frequencia do clock APB2. Escolhendo APB2 como 84 MHz, ADCClk como f/6, e x como 3 chegamos a Taxa de Amostragem de 933 KHz.

### Frequencia Intermediária

Segundo o teorema de Nyquist temos que a Frequencia Intermediária tem que ser no máximo a metade da Taxa de Amostragem, com isso foi escolhido o valor de FI = 455 KHz que garante uma margem de segurança em relação a Taxa de Amostragem.
