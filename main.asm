CSEG segment
org 100h
Begin:
mov ah,0fh
int 10h
mov ah,03h
int 10h
mov strpoz,dh
;Очистка экрана
mov al,0
mov heightstr,al
mov widthstr,al
mov bp,offset string
call pars

mov si,offset happy_not
mov bp,offset happy_time
begi: mov di,[si]
cmp di,0ffffh
je end_play
;mov bx,ds:[bp]
;mov al,35
mov al,ds:[bp]
call beep
add si,2
add bp,1
jnz Begi
end_play: 
mov ah,heightstr
mov al,strpoz
cmp ah,al
ja cvbn
mov ah,0fh
int 10h
mov ah,02h
mov dh,strpoz
mov dl,0
int 10h
cvbn: int 20h
;int 20h
;Процедура парцсинга строк
pars proc
;push dx
begin_proc_pars:
mov ax,offset adresCharStr
mov adresArray,ax
;mov bp,offset string
mov adresCharStr,bp
;mov dx,offset adresCharStr
begin_pars:
mov al,ds:[bp]
cmp al,"$"
je end_str

;Конец обзаца
;mov al,ds:[bp]
cmp al,"!"
je end_obz

;конец парсинга
;mov al,ds:[bp]
cmp al,"@"
je end_pars
;mov adresArray,dx
add bp,1
jmp begin_pars
;ret


end_str:
add bp,1
add adresArray,2
mov ax,bp
mov bp,adresArray
mov cs:[bp],ax
mov bp,ax

;mov ah,09h
;mov dx,offset string
;int 21h
;int 20h
jmp begin_pars

end_obz:
add bp,1
mov adresReplay,bp
add adresArray,2
mov ax,bp
mov bp,adresArray
mov dl,"!"
sub dh,dh
mov cs:[bp],dx
mov bp,ax
push si
;mov si,offset adresCharStr
;mov di,[si]
call echo_str
pop si
mov bp,adresReplay
jmp begin_proc_pars

end_pars:
;add bp,1
;mov adresReplay,bp
add adresArray,2
mov ax,bp
mov bp,adresArray
mov dl,"!"
sub dh,dh
mov cs:[bp],dx
mov bp,ax
push si
;mov si,offset adresCharStr
;mov di,[si]
call echo_str
pop si
ret


;Переменные
adresArray dw ?
;структуры данных
adresCharStr dw 12 dup(?)
adresReplay dw ?

;string db "yes$"
pars endp
;Процедура вывода символов
echo_str proc
mov al,heightstr
mov heightbegin,al
;адрес ячейки массива с адресом
begin_get_char:
mov si,offset adresCharStr
;адрес символа
mov bp,[si]
;символ
get_char:
;настройка дисплея
mov ah,0fh
int 10h
mov ah,02h
mov dh,heightstr
mov dl,widthstr
;mov bh,0
int 10h
mov al,cs:[bp]
cmp al,"$"
je next_str
;cmp al," "
;je next_char
cmp al,"!"
je sbros
cmp al,"@"
je sbros
;вывод символа
mov ah,0ah
mov cx,1
int 10h
mov al,0
mov bh,0
mov bl,1
call delay 
;указатель на следующий символ в строке
next_char:
push bp
push ax
mov bp,si
mov ax,[si]
add ax,1
mov cs:[bp],ax
pop ax
pop bp
; следущая строка
next_str:
add si,2
mov bp,[si]
cmp bp,"!"
je sbros
add heightstr,1
jmp get_char

;adresCharStr+1
;cmp "!"
;
;сброс строк
sbros:
mov al,heightstr
mov heightend,al 
;проверка не закончен ли вывод
mov si,offset adresCharStr
help_exit:
mov bp,[si]
mov al,cs:[bp]
add si,2
cmp al,"$"
je help_exit
cmp al,"!"
je end_echo
cmp al,"@"
je end_echo

begin_sbros:
mov al,heightbegin
mov heightstr,al
add widthstr,1
jmp begin_get_char

end_echo:
mov widthstr,0
mov al,heightend
add al,1
mov heightstr,al
ret
end_next_str:
;adresCharStr dw ?
heightbegin db ?
heightend db ?
echo_str endp

beep proc 
;mov di,329
push ax
push bx
push dx
push cx
push di
mov tim,al
mov dx,14h
mov ax,4f38h
div di
mov iq,ah
mov iw,al
zxc:
;mov qad,50000
;mov al,0b6h
;out 43h,al
mov al,iw
out 42h,al
mov al,iq
out 42h,al
in al,61h
mov ah,al
or al,3
out 61h,al
;Длительность звучания
mov al,0
mov bh,0
mov bl,tim
call delay 
in al,61h
xor al,2
;mov al,ah
out 61h,al
;inc iq
;mov ah,1
;int 21h
;mov ah,"2"
;cmp al,ah
;jne zxc
;int 20h
pop di
pop cx
pop dx
pop bx
pop ax
ret
tim db ?
iq db ?
iw db ?
;qad dw ?
beep endp

;Процедура счётчик
delay proc 
;mov al,0
;mov bh,0
;mov bl,24
push ax
push bx
push cx
push dx
mov ah,2ch
int 21h

mov ah,ch
add al,cl
add bh,dh
add bl,dl

cmp bl,100
jb secs
sub bl,100
inc bh
secs: cmp bh,60
jb mins
sub bh,60
inc al
mins: cmp al,60
jb hrs
sub al,60
inc ah
hrs: cmp ah,24
jne check
sub ah,ah

check: push ax
mov ah,2ch
int 21h
pop ax
cmp cx,ax
ja quit
jb check
cmp dx,bx
jb check
quit: pop dx
pop cx
pop bx
pop ax
ret
delay endp
;данные
happy_not dw 294, 294, 330, 294, 392, 370 
			dw 294, 294, 330, 294, 440, 392 
			dw 294, 294, 587, 494, 392, 370, 330 
			dw 523, 523, 494, 392, 440, 392, 0ffffh
happy_time db 35, 35, 35, 35, 35, 54
		  db 35, 35, 35, 35, 35, 54
		  db 35, 35, 35, 35, 35, 35, 35
		  db 35, 35, 35, 35, 35, 35
heightstr db ?
widthstr db ?
strpoz db ?
string db       "                                  **                      $"
		db		"              ****     ***  *  * **** *    *              $"  
		db	    "              *       ***** **** ***  * \/ *              $"  
		db		"              ****    *   * *  * **** *    *              !"  
		db		"                                                          !"
		db		"     ****  ****  * * *   ***   ****  *  *  *   *  ****    $"	        
		db		"     ****  *  *    *    *****  ***   ****  * / *   * *    $"
		db		"     *     ****  * * *  *   *  ****  *  *  *   *  *  *    !"   
        db		"                                                          !"
		db		"          *    *    *    ****  *   *  *  *    *           $"
		db      "          * \/ *   ***   ****  * / *  ****   ***          $"
		db      "          *    *  *   *  *     *   *  *  *  *   *         !"
		db		"                                                          @"
CSEG ends
end Begin