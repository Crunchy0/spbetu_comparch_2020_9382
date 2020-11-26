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
		jmp a
		save_ax dw 1 (0)
		save_ss dw 1 (0)
		save_sp dw 1 (0)
		iStack dw 6 dup(0)			; �뤥�塞 ������ ��� ������ �⥪�
		
		a:
		mov save_ss, ss
		mov save_sp, sp
		mov save_ax, ax
		mov ax, seg iStack			; ��࠭塞 �⥪ �ணࠬ�� � �����
		mov ss, ax
		mov sp, offset a
		mov ax, save_ax
		
		push ax						; AX �㤥� ������, ��࠭塞 �� �⥪�
		push bx
		
		in al, 61h					; ����砥� ���
		mov ah, al
		mov bx, 13000
		
		or al, 3
		out 61h, al
		
		za:
		
		sub bx, 1
		mov al, 182					; ����ࠨ���� ⠩���
		out 43h, al

		
		mov ax, bx					; ��।�� ����⥫� �����
		out 42h, al
		mov al, ah
		out 42h, al
		
		cmp bx, 6000
		jne za
		xor bx, bx
		
		mov al, ah					; ⥯��� ���� �몫����, ��頣� ᯨ�
		out 61h, al
		
		pop bx
		pop ax						; ����⠭�������� AX
		
		mov save_ax, ax
		mov ax, save_ss
		mov ss, ax					; ����⠭�������� �⥪ �ணࠬ��
		mov sp, save_sp
		mov ax, save_ax
		
		mov al, 20h					; �����頥� ����������� �ࠢ����� ��㣨� ���뢠��� (� ����� ������ �ਮ��⮬)
		out 20h, al
		
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
		looper:
		
		mov ah, 1h
		int 21h
		cmp al, 1bh
		je next
		jmp looper
		
		next:
		
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
	