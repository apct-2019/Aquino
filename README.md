# Firmware

Para a demulação AM no RDS (Rádio Definido por Software) será utilizado um ARM stm32f407 como microcontrolador. Primeiramente o sinal  analógico, modulado em AM, será convertido para digital viabilizando o tratamento pelo microcontrolador. Para demodulação será utilizada a transformada de Hilbert realizando as operações exibidas no fluxograma abaixo e por último o sinal tratado será enviado por USB ou para um Speaker.

![Image FluxogramaDemodulacao](https://github.com/apct-2019/Firmware/blob/master/FluxogramaDemodulador.png)
