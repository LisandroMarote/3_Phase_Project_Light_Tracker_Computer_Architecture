#include <reg51.h>
#define fimTempo 100 								// timer = 0.2ms -> fimTempo = 100*0.2ms = 20ms 
#define zero 3 										// 3*0.2ms = 0.6ms -> 0� 
#define centoOitenta 12 							// 12*0.2 = 2.4ms -> 180�
#define atraso 10									// 10*20ms = 0.2s

								 
sbit servo = P1^0; 									// Pino De Controlo Para Servo Motor.
sbit LED = P1^1;									// Pino De Controlo Para o LED.
sbit sensorLuz = P3^2;								// Pino De Controlo Para O Sensor De Luz.

unsigned char conta = 0; 							// Contador Que Conta a Cada 200us. 
unsigned char conta2 = 0; 							// Tempo de Espera Entre Mudan�a De �ngulos.
unsigned char referencia = zero; 					// O Servo Come�a Nos 0�.
unsigned int dir = 0;								// Vari�vel Auxiliar Para Dire��o Do Servo.	(0-> 180� e 1-> 0�).		

// Declara��o De Fun��es.
void Init(void) {
	// Configuracao Registo IE 
	EA = 1;											// Activa Interrup��es Globais.
	ET0 = 1; 										// Activa Interrup��o timer 0. 
	EX0 = 1; 										// Ativa Interrup��o Externa 0.
	// Configuracao Registo TMOD 
	TMOD &= 0xF0; 									// Limpa Os 4 bits Do timer 0 (8 bits � auto reload). 
	TMOD |= 0x02; 									// Modo 2 Do Timer 0.
	// Configuracao Timer 0 
	TH0 = 0x37; 									// Timer 0 - 200us. 
	TL0 = 0x37;
	// Configuracao Registo TCON
	TR0 = 1; 										// Come�a O timer 0. 
	IT0 = 1; 										// Interrup��o Externa Activa A Falling Edge.
	// Configura��o Do LED.
	LED = 1;										// Inicializa��o Do LED A 1 (Funciona Pela L�gica Negada).
}

// Interrupcao Externa. 
void External0_ISR(void) interrupt 0 { 
	LED = 0;										// Ativa��o Do LED (L�gica Negada Uma Vez Mais).
}

// Interrupcao Tempo.
void Timer0_ISR(void) interrupt 1 { 
	conta++; 										// Incrementa a Cada Contagem de 200us. 
}

void main (void) { 
// Inicializa��es. 
	Init();
	while(1) 										// Loop Infinito. 
	{   		
		// Atingiu O Valor De Refer�ncia (0.6ms, 1.5ms ou 2.6ms). 
			if(conta == referencia)
			{ 
				servo = 0;  						// Coloca a Sa�da a 0 At� Atingir Os 20ms.
				if(sensorLuz == 0) conta2 = 0;		// Mantem o Servo Bloqueado Enquanto Sensor De Luz Estiver A Receber Um Sinal Luminoso.
			}
		
			// Atingiu Os 20ms
 			if(conta == fimTempo)
			{ 
				conta = 0;       					// Reinicia A Contagem. 
				servo = 1;       					// Impulso Positivo At� Atingir O Valor De Referencia. 
				conta2++;							// Incrementa A Vari�vel Do Tempo De Espera Entre Os �ngulos.
			} 
			//Se Atingiu o Tempo Definido De Espera Para Mudar De �ngulo.
			if(sensorLuz == 1)
			{
				if(conta2 == atraso)
				{
					LED = 1;
					if(dir == 0)
					{
						if(referencia == centoOitenta)
						{
							dir = 1;				// Muda Dire��o A Come�ar Dos 180� Para 0�.
						}
							else
							{
								referencia+=1;		// Incrementa��o Da Refer�ncia At� Atingir os 180�.
								conta2 = 0;			// Volta a Reiniciar a Contagem.
							} 
					}
						else
						{
							if(referencia == zero)
							{
								dir = 0;			// Muda Dire��o A Come�ar Dos 0� Para 18+p0�.
							}
								else
								{
									referencia-=1;
									conta2 = 0;		// Volta a Reiniciar A Contagem.
								}
						}
					} 
				}	
	}											// Fim Do While.
}													// Fim Do Void Main.