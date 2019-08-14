# Firmware

Para a demulação AM no RDS (Rádio Definido por Software) será utilizado um ARM stm32f407 como microcontrolador. Primeiramente o sinal  analógico, modulado em AM, será convertido para digital viabilizando o tratamento pelo microcontrolado. Para demodulação será utilizada a transformada de Hilbert realizando as operações exibidas no fluxograma abaixo e por ultimo o sinal tratado será enviado por USB ou para um Speaker.

![Image FluxogramaDemodulacao](link-to-image)