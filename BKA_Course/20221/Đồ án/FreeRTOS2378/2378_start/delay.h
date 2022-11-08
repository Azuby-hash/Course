/***********************************************************************/
/*            Day la file chuan cho cac ham delay trong ARM            */
/*              Copyright by Dinh Thanh Tung - KTMTk51                 */
/***********************************************************************/
/*                                                                     */
/*                    dai hoc Bach Khoa Ha Noi                         */
/*                                                                     */
/***********************************************************************/

#ifndef __DELAY_H
#define __DELAY_H

void delay_ms(unsigned int n)
{
	n= n*10000;
	while(n > 0) {n--;}							// Lap de giam n
}

#endif  // __DELAY_H
