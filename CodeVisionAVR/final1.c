/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/23/2023
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>
#include <string.h>
#include <delay.h>

int START;
unsigned int dem, x;
unsigned int i;
unsigned long ADC_out = 0;
unsigned long nhietdo, chuc, dvi;

#include <stdio.h>
//chuong trinh con phat mot ky tu
void uart_char_send(unsigned char chr){
    while (!(UCSRA & (1<<UDRE))) {}; //cho den khi bit UDRE=1
        UDR=chr;
}


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    i += 1;
    
    chuc = (i/10);
    dvi = (i%10);
    
    uart_char_send(chuc+0x30);
    uart_char_send(dvi+0x30);
    // uart_char_send(10);
    uart_char_send(13);
    delay_ms(200);

}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
//        f = 125000Hz
//        --> time = 1 / f = 8lan (us)
//        TCNT0: 6 - 255, duoc 250 xung nhip
//        -> Time tran = 250 * 8 = 2000 (us) = 4s
//        dem++;
//        Neu bien dem tang 500 lan thi se dc 1(s)
       dem++;
       TCNT0 = 6;        
}

 
//Ngat Nhan UART cho mot ky tu
interrupt [USART_RXC] void usart_rx_isr(void)
{
char data;
data=UDR;
//uart_char_send(data);
    if (data == '0'){ START = 0x00; }
    if (data == '9'){ START = 0xFF; }
    
    if (START == 0xFF)
    {   
        //DIEU KHIEN 8 LED DON
        if (data == '1'){ PORTC.7 = 0xFF; }
        if (data == 'q'){ PORTC.7 = 0x00; }
        if (data == '2'){ PORTC.6 = 0xFF; }
        if (data == 'w'){ PORTC.6 = 0x00; }
        if (data == '3'){ PORTC.5 = 0xFF; }
        if (data == 'e'){ PORTC.5 = 0x00; }
        if (data == '4'){ PORTC.4 = 0xFF; }
        if (data == 'r'){ PORTC.4 = 0x00; }
        if (data == '5'){ PORTC.3 = 0xFF; }
        if (data == 't'){ PORTC.3 = 0x00; }
        if (data == '6'){ PORTC.2 = 0xFF; }
        if (data == 'y'){ PORTC.2 = 0x00; }
        if (data == '7'){ PORTC.1 = 0xFF; }
        if (data == 'u'){ PORTC.1 = 0x00; }
        if (data == '8'){ PORTC.0 = 0xFF; }
        if (data == 'i'){ PORTC.0 = 0x00; }
        
        
        //DIEU KHIEN LED RUN
        if (data == 'z' )
        {   
           x = 250;  //0.5s
        } 
        
        if (data == 'x' )
        {   
           x = 500;  //1s
        }
         if (data == 'c' )
        {   
           x = 750;  //1.5s
        } 
        
        if (data == 'v' )
        {   
           x = 1000; //2s
        }  
         if (data == 'b' )
        {   
           x = 1250; //2.5s
        } 
        
        if (data == 'n' )
        {   
           x = 1500;  //3s
        }  
            if (data == 'm' )
        {   
           x = 1750;  //3.5s
        } 
        
        if (data == 'j' )
        {   
           x = 2000;  //4s
        }
         if (data == 'k' )
        {   
           x = 2250;  //4.5s
        } 
        
        if (data == 'l' )
        {   
           x = 2500;  //5s
        }  
            
    } 
            
}



#define ADC_VREF_TYPE 0x00

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}




void main(void)
{
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=1 
PORTB=0x01;
DDRB=0x01;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x03;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
#asm("sei")

while (1)
      {  
         if(dem >= x)
        { 
            PORTB.0 = ~PORTB.0;
            dem = 0;
        } 
            
            // DO NHIET DO 
            ADC_out = read_adc(0);
            nhietdo = ADC_out*500/1023; //10mV = 1do.
            
            chuc = nhietdo/10;
            dvi = nhietdo%10;
            uart_char_send(chuc+0x30);
            uart_char_send(dvi+0x30); 
            
            uart_char_send(13);
            uart_char_send(10);
            delay_ms(200);

      }
}
