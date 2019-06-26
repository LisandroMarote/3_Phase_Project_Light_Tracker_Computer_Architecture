#include <reg51.h>
#define fimTempo 100 								// timer = 0.2ms -> fimTempo = 100*0.2ms = 20ms 
#define zero 3 										// 3*0.2ms = 0.6ms -> 0º 
#define centoOitenta 12 							// 12*0.2 = 2.4ms -> 180º
#define atraso 10									// 10*20ms = 0.2s

								 
sbit servo = P1^0; 									// Pino De Controlo Para Servo Motor.
sbit LED = P1^1;									// Pino De Controlo Para o LED.
sbit sensorLuz = P3^2;								// Pino De Controlo Para O Sensor De Luz.

unsigned char conta = 0; 							// Contador Que Conta a Cada 200us. 
unsigned char conta2 = 0; 							// Tempo de Espera Entre Mudança De Ângulos.
unsigned char referencia = zero; 					// O Servo Começa Nos 0º.
unsigned int dir = 0;								// Variável Auxiliar Para Direção Do Servo.	(0-> 180º e 1-> 0º).		

// Declaração De Funções.
void Init(void) {
	// Configuracao Registo IE 
	EA = 1;											// Activa Interrupções Globais.
	ET0 = 1; 										// Activa Interrupção timer 0. 
	EX0 = 1; 										// Ativa Interrupção Externa 0.
	// Configuracao Registo TMOD 
	TMOD &= 0xF0; 									// Limpa Os 4 bits Do timer 0 (8 bits – auto reload). 
	TMOD |= 0x02; 									// Modo 2 Do Timer 0.
	// Configuracao Timer 0 
	TH0 = 0x37; 									// Timer 0 - 200us. 
	TL0 = 0x37;
	// Configuracao Registo TCON
	TR0 = 1; 										// Começa O timer 0. 
	IT0 = 1; 										// Interrupção Externa Activa A Falling Edge.
	// Configuração Do LED.
	LED = 1;										// Inicialização Do LED A 1 (Funciona Pela Lógica Negada).
}

// Interrupcao Externa. 
void External0_ISR(void) interrupt 0 { 
	LED = 0;										// Ativação Do LED (Lógica Negada Uma Vez Mais).
}

// Interrupcao Tempo.
void Timer0_ISR(void) interrupt 1 { 
	conta++; 										// Incrementa a Cada Contagem de 200us. 
}

void main (void) { 
// Inicializações. 
	Init();
	while(1) 										// Loop Infinito. 
	{   		
		// Atingiu O Valor De Referência (0.6ms, 1.5ms ou 2.6ms). 
			if(conta == referencia)
			{ 
				servo = 0;  						// Coloca a Saída a 0 Até Atingir Os 20ms.
				if(sensorLuz == 0) conta2 = 0;		// Mantem o Servo Bloqueado Enquanto Sensor De Luz Estiver A Receber Um Sinal Luminoso.
			}
		
			// Atingiu Os 20ms
 			if(conta == fimTempo)
			{ 
				conta = 0;       					// Reinicia A Contagem. 
				servo = 1;       					// Impulso Positivo Até Atingir O Valor De Referencia. 
				conta2++;							// Incrementa A Variável Do Tempo De Espera Entre Os Ângulos.
			} 
			//Se Atingiu o Tempo Definido De Espera Para Mudar De Ângulo.
			if(sensorLuz == 1)
			{
				if(conta2 == atraso)
				{
					LED = 1;
					if(dir == 0)
					{
						if(referencia == centoOitenta)
						{
							dir = 1;				// Muda Direção A Começar Dos 180º Para 0º.
						}
							else
							{
								referencia+=1;		// Incrementação Da Referência Até Atingir os 180º.
								conta2 = 0;			// Volta a Reiniciar a Contagem.
							} 
					}
						else
						{
							if(referencia == zero)
							{
								dir = 0;			// Muda Direção A Começar Dos 0º Para 18+p0º.
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