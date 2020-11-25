stack segment stack
	dw 6 dup(?)						; ������ �����筮
stack ends

data segment
	keep_seg dw 0					; ����� ��࠭�� ��䮫�� �����
	keep_offset dw 0
data ends

code segment
	assume ds:data, cs:code, ss:stack
	
	interrupt proc far
		
		push ax						; AX �㤥� ������, ��࠭塞 �� �⥪�
		
		mov al, 182					; ����ࠨ���� ⠩���
		out 43h, al
		
		mov ax, bx					; ��।�� ����⥫� �����
		out 42h, al
		mov al, ah
		out 42h, al
		
		
		mov al, 20h					; �����頥� ����������� �ࠢ����� ��㣨� ���뢠��� (� ����� ������ �ਮ��⮬)
		out 20h, al

		pop ax						; ����⠭�������� AX
		iret
	interrupt endp
	
	
	main proc far
		push ds
		sub ax, ax					; ���樠�����㥬 ᥣ���� ������
		push ax
		
		mov ax, data
		mov ds, ax
		
		
		mov ax, 351ch				; ����砥� ����� ���뢠���, ��࠭塞 � �����
		int 21h
		
		mov keep_offset, bx
		mov keep_seg, es
	;---------------------------------
		cli
		push ds
		mov dx, offset interrupt	; ��⠭�������� ���� ��ࠡ��稪 ���뢠���
		mov ax, seg interrupt
		mov ds, ax
		
		mov ax, 251ch
		int 21h
		
		pop ds
		sti
	;---------------------------------	
		in al, 61h					; ����砥� ���
		mov ah, al
		or al, 3
		mov bx, 12000				; ��砫�� ����⥫� �����
		out 61h, al
		
		za:
		mov cx, 0ffffh				; �⠢�� ����প� �� �祭� ����� ⠪⮢
		
		looper:
		loop looper
		
		sub bx, 100
		cmp bx, 1500				; 㬥��蠥� ����⥫� ����� �� 100 (���� ��㪠 ⥬ �६���� �����)
		jg za
		
		xor bx, bx
		
		mov al, ah					; ⥯��� ���� �몫����, ��頣� ᯨ�
		out 61h, al
		
	;---------------------------------
	
		cli
		push ds
		
		mov dx, keep_offset			; ����⠭�������� ��室�� ����� ���뢠���
		mov ax, keep_seg
		mov ds, ax
		
		mov ah, 25h
		mov al, 1ch
		int 21h
		
		pop ds
		sti
	
	;---------------------------------
	
		ret
	main endp
code ends
end main
	