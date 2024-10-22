.data
inbuf:			.space 6500	#for 250000 and 16=16: max width of src image = 3900
outbuf:			.space 5000
src:			.asciiz "parte_6.bmp"
dst:			.asciiz "dst.bmp"

.text
.globl main
	
main:
	#fix given filename
	LOADDIR R5, src
next_char:
	SUMNOSIGN_I R5, R5, 1
	LOADBYTENOSIGN R6, R5
	SALMAYIG_I R6, 32, next_char
	STOREBYTE R0, R5

	LOADINM R19,  392
	
	LOADINM R20,  392
	
	#open src and dst file
	LOADINM R1, 13
	LOADDIR R2, src
	LOADINM R3, 0
	LOADINM R4, 0
	LLAME
	#FIRST CHANGE
	COPY R15, R1
	
	LOADINM R1, 13
	LOADDIR R2, dst
	LOADINM R3,  1
	LOADINM R4,  0
	LLAME

	COPY R16, R1
	
	#read first 14+3*4 bytes of the header and copy first 18
	LOADINM R1,  14
	COPY R2, R15
	LOADDIR R3, inbuf
	LOADINM R4,  26
	LLAME
	
	LOADINM R1,  15
	COPY R2, R16
	LOADDIR R3, inbuf
	LOADINM R4, 18
	LLAME
	
	#read int from 14th byte - number of bytes remaining in this header
	LOADWORDNOSIGN R5, inbuf, 14
	RES_I R5, R5, 12
	
	#read resolution of src file
	LOADWORDNOSIGN R17, inbuf, 18
	LOADWORDNOSIGN R18, inbuf, 22
	
	#save resolution of dst file
	STOREWORDNOSIGN R19, inbuf, 18
	STOREWORDNOSIGN R20, inbuf, 22
	
	LOADINM R1, 15
	COPY R2, R16
	LOADDIR R3, inbuf, 18
	LOADINM R4,  8
	LLAME
	
	#copy the rest of the header using int from 14th byte
	LOADINM R1,  14
	COPY R2, R15
	LOADDIR R3, inbuf
	COPY R4, R5
	LLAME
	
	LOADINM R1, 15
	COPY R2, R16
	LOADDIR R3, inbuf
	COPY R4, R5
	LLAME
	
	#fill empty inbuf
	MULTNOSIGN_I R17, R17, 4
	MULTNOSIGN_I R17, R17, 16
	#mulu R17, R17, 32
	
	LOADINM R1,  14
	COPY R2, R15
	LOADDIR R3, inbuf
	COPY R4, R17
	LLAME
	
	DIV_I R17, R17, 16
	#div R17, R17, 32
	DIV_I R17, R17, 4
	
	LOADINM R22, 16
	#LOADDIR R22, 32
	SUM_I R22, R22, -1
	
	#loop iterating over rows
	MULTNOSIGN_I R19, R19, 4
	LOADINM R13,  0
row_loop:
	
	#inner loop: iterates over channels (columns)
	LOADINM R14,  0
channel_loop:	
#calculate fx fy ox oy
	#fx = x / nw * (w - 1)
	SUM_I R8, R17, -1
	MULTNOSIGN R8, R8, R14
	#switch int to point number
	DSPLIZQ R8, R8, 8
	DIV R8, R8, R19
	
	#fy = y / nh * (h - 1)
	SUM_I R9, R18, -1
	MULTNOSIGN R9, R9, R13
	#switch int to point number
	DSPLIZQ R9, R9, 8
	DIV R9, R9, R20
	
	#get floor values (as integers)
	COPY  R10, R8
	DSPLDER R10, R10, 8
	COPY R11, R9
	DSPLDER R11, R11, 8
	
	#get mantissa values (as point numbers)
	DSPLIZQ R8, R8, 24
	DSPLDER R8, R8, 24
	DSPLIZQ R9, R9, 24
	DSPLDER R9, R9, 24
	
#find two first pixels (channel)
	
	#offy = (oy%16) * w * 4
	COPY R12, R11
	DSPLIZQ R12, R12, 28
	DSPLDER R12, R12, 28
	MULTNOSIGN R12, R12, R17
	MULTNOSIGN_I R12, R12, 4
	
	#offx = x%4 + 4*ox
	COPY R7, R14
	#modulo 4
	DSPLIZQ R7, R7, 30
	DSPLDER R7, R7, 30
	SUMNOSIGN R7, R7, R10
	SUMNOSIGN R7, R7, R10
	SUMNOSIGN R7, R7, R10
	SUMNOSIGN R7, R7, R10
	
	#offy += offx
	SUMNOSIGN R12, R12, R7
	
	#check if required bytes are in inbuf; if not update inbuf
	SALMAYIG R11, R22, update_inbuf0
	
return_after_bufor_update0:
	#get first pixel (channel)
	LOADBYTENOSIGN_I R6, inbuf, R12
	
	#get second pixel (channel)
	SUM_I R12, R12, 4
	LOADBYTENOSIGN_I R5, inbuf, R12
	
#find 3th and 4th pixel (channel)
	
	#offy = (oy+1)%16 * w * 4 + offx
	COPY R12, R11
	SUM_I R12, R12, 1
	DSPLIZQ R12, R12, 28
	DSPLDER R12, R12, 28
	MULTNOSIGN R12, R12, R17
	MULTNOSIGN_I R12, R12, 4
	SUMNOSIGN R12, R12, R7
	
	#calculate interpolation between first two pixels (channels): p1 + (p2 - p1) * fx
	RES R11, R5, R6
	MULTNOSIGN R11, R11, R8
	DSPLIZQ R6, R6, 8
	SUMNOSIGN R11, R11, R6
	
	#get 3rd pixel (channel)
	LOADBYTENOSIGN_I R6, inbuf, R12
	
	#get 4th pixel (channel)
	SUM_I R12, R12, 4
	LOADBYTENOSIGN_I R5, inbuf, R12
	
	#calculate interpolantion between 3rd and 4th pixel (channels): p3 + (p4 - p3) * fx
	RES R12, R5, R6
	MULTNOSIGN R12, R12, R8
	DSPLIZQ R6, R6, 8
	SUMNOSIGN R12, R12, R6
	
#calculate bilanear interpolation between 4 pixels (channels): lerp12 + (lerp34 - lerp12) * fy
	RES R7, R12, R11
	#convert this point number to int
	DSPLDER R7, R7, 8
	MULTNOSIGN R7, R7, R9
	SUMNOSIGN R7, R7, R11
	
	#save calculated pixel (channel) to outbuf
	DSPLDER R7, R7, 8
	STOREBYTE_I R7, outbuf, R21
	SUM_I R21, R21, 1
	
	#check if outbuf if full
	SALMAYIG_I R21, 10000, push_outbuf_to_file
	
	#ending inner loop
	SUM_I R14, R14, 1
	SALMEN R14, R19, channel_loop
	
	#ending outer loop
	SUM_I R13, R13, 1
	SALMEN R13, R20, row_loop
	
	
epilog:
	#if outbuf contains data, save it to file
	LOADINM R1,  15
	COPY R2, R16
	LOADDIR R3, outbuf
	COPY R4, R21
	LLAME

	#close both files
	LOADINM R1,  16
	COPY R2, R15
	LLAME
	
	LOADINM R1,  16
	COPY R2, R16
	LLAME
	
	LOADINM R1, 10
	LLAME
	
push_outbuf_to_file:
	LOADINM R1, 15
	COPY R2, R16
	LOADDIR R3, outbuf
	COPY R4, R21
	LLAME
	LOADINM R21, 0

	#ending inner loop
	SUM_I R14, R14, 1
	SALMEN R14, R19, channel_loop
	
	#ending outer loop
	SUM_I R13, R13, 1
	SALMEN R13, R20, row_loop
	
	
	SAL epilog
	
update_inbuf0:
	COPY R6, R7
	MULTNOSIGN_I R17, R17, 4
	
load_more:	
	#help = lastlaneIndex%16 * w
	SUM_I R22, R22, 1
	COPY R7, R22
	DSPLIZQ R7, R7, 28
	DSPLDER R7, R7, 28
	MULTNOSIGN R7, R7, R17
	SUM_I R22, R22, -1
	
	#read next 8 lanes of pixels from the file
	MULTNOSIGN_I R17, R17, 8
	LOADINM R1,  14
	COPY R2, R15
	LOADDIR R3, inbuf, R7
	COPY R4, R17
	LLAME
	DIV_I R17, R17, 8
	
	#lastlaneIndex += 8
	SUM_I R22, R22, 8
	
	SALMAYIG R6, R22, load_more
	DIV_I R17, R17, 4
	
	SAL return_after_bufor_update0

