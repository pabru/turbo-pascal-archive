program treework;
uses CRT,Graph;

const
    PathToDriver = '..\..\bgi'; { ���� � ���. �ࠩ���� [egavga.]bgi }

type PTree = ^TTree;
	 TTree = record
	 	info:byte;
		left,right: PTree;
	end;

function getint(ident:string):byte;
var s:byte;
begin
	write('������ ',ident,' : ');
	readln(s);
	getint:=s;
end;

procedure addelem(var root:PTree;info:byte);
var elem:PTree;
begin
	if (root=NIL) then (* �᫨ ��ॢ� ���⮥, � *)
		begin
			new(elem); (* ������� ���� ���� *)
			elem^.left:=NIL; 
			elem^.right:=NIL;
			elem^.info:=info; (* ������� �㤠 ���祭�� �ॡ㥬��� ������� *)
			root:=elem; (* ��ᮥ������ ���� ���� ����� ���⮣� ��ॢ� *)
		end 
	else  (* ���� *)
		begin
			if (info<root^.info) then  (* �᫨ ������塞�� ���祭�� ����� ⥪�饣� 㧫�, � *)
				addelem(root^.left,info) (* �������� ��� � ����� �����ॢ� *)
			else (* ���� *) 
				addelem(root^.right,info); (* �������� ��� � �ࠢ�� �����ॢ� *)
		end;
end;


procedure printLKP(root:PTree);
begin
	if (root<>NIL) then  (* �᫨ ��ॢ� �� ���⮥ *)
		begin
			printLKP(root^.left);  (* ��ᯥ���� ����� �����ॢ� *)
			write(root^.info,' '); (* ��ᯥ���� ��७� ��ॢ� *)
			printLKP(root^.right); (* ��ᯥ��� �ࠢ�� �����ॢ� *)
		end;
end;

procedure printLKP_wrapper(root:PTree);
begin
	clrscr;
	if (root=NIL) then (* �᫨ ��ॢ� ���⮥ *)
		writeln('��ॢ� ����!') (* ������� �� �⮬ *)
	else (* ���� *)
		PrintLKP(root); (* ��ᯥ����  ��ॢ� *)
	writeln;
	writeln('������ ���� ������� ��� ��室� � ������� ����');
	readkey;
end;

procedure printKLP(root:PTree);
begin
	if (root<>NIL) then (* �᫨ ��ॢ� �� ���⮥ *)
		begin
			write(root^.info,' '); (* ��ᯥ���� ��७� ��ॢ� *)
			printKLP(root^.left); (* ��ᯥ���� ����� �����ॢ� *)
			printKLP(root^.right);(* ��ᯥ���� �ࠢ�� �����ॢ� *)
		end;
end;

procedure printKLP_wrapper(root:PTree);
begin
	clrscr;
	if (root=NIL) then (* �᫨ ��ॢ� ���⮥ *)
		writeln('��ॢ� ����!') (* ������� �� �⮬ *)
	else  (* ���� *)
		PrintKLP(root); (* ��ᯥ���� ��ॢ� *)
	writeln;
	writeln('������ ���� ������� ��� ��室� � ������� ����');
	readkey;
end;

procedure printLPK(root:PTree);
begin
	if (root<>NIL) then (* �᫨ ��ॢ� �� ���⮥ *)
		begin
			printLPK(root^.left); (* ��ᯥ���� ����� �����ॢ� *)
			printLPK(root^.right); (* ��ᯥ���� �ࠢ�� �����ॢ� *)
			write(root^.info,' '); (* ��ᯥ���� ��७� ��ॢ� *)
		end; 
end;

procedure printLPK_wrapper(root:PTree);
begin
	clrscr;
	if (root=NIL) then (* �᫨ ��ॢ� ���⮥ *)
		writeln('��ॢ� ����!') (* ������� �� �⮬ *)
	else (* ���� *)
		PrintLPK(root); (* ��ᯥ���� ��ॢ� *)
	writeln;
	writeln('������ ���� ������� ��� ��室� � ������� ����');
	readkey;
end;

function countels(root:PTree):integer;
begin
	if (root<>NIL) then (* �᫨ ��ॢ� �� ���⮥ , � *)
		countels:=1+countels(root^.left)+countels(root^.right) (* ��᫮ ��� 㧫�� - �㬬� �᫠ 㧫�� ����� � �ࠢ�� ��⢥� +1 *)
	else (* ����, �᫨ ��ॢ� ���⮥ *)
		countels:=0; (* ��᫮ ��� 㧫�� = 0 *)
end;

procedure countels_wrapper(root:PTree);
begin
	writeln('��᫮ ���設 ��ॢ� : ',countels(root));
	writeln('������ ���� �������');
	writeln;
	readkey;
end;

function countleafs(root:PTree):integer;
begin
	if (root<>NIL) then (* �᫨ ��ॢ� �� ���⮥, � *)
		if (root^.left=NIL) and (root^.right<>NIL) then  (* �᫨ ��� - ����,� *)
			countleafs:=1 (* ������⢮ ���⮢ � �� = 1 *)
		else (* ���� *)
			countleafs:=countleafs(root^.left)+countleafs(root^.right) (* ������⢮ ���⮢ = �㬬� ���⮢ ����� � �ࠢ�� ��⢥� *)
	else (* ����, �᫨ ��ॢ� ���⮥ , *)
		countleafs:=0; (* ������⢮ ���⮢ � �� = 0 *)
end;

procedure countleafs_wrapper(root:PTree);
begin
	writeln('��᫮ ���⮢ ��ॢ� : ',countels(root));
	writeln;
	writeln('������ ���� �������');
	readkey;
end;

function getmostright(root:PTree):byte;
begin
	if (root^.right=NIL) then 		(* �᫨ ��� �ࠢ��� �����ॢ� *)
		getmostright:=root^.info (* �� ��� ������� - ᠬ� �ࠢ� � ��ॢ� *)
	else (* ���� *)
		getmostright:=getmostright(root^.right); (* ���� �ࠢ� ������� �⮣� ��ॢ� - ᠬ� �ࠢ� ������� ��� �ࠢ��� �����ॢ� *)
end;

procedure delelem(var root:PTree;info:byte);
var temp:PTree;
begin
	if (root<>NIL) then (* �᫨ ��ॢ� �� ���⮥, � *)
	  begin
		if (info<root^.info) then	(* �᫨ 㤠�塞� ������� ����� ⥪. 㧫�, � *)
			delelem(root^.left,info)	(* ������� ��� �� ������ �����ॢ� *)
		else		(* ���� *)
		if (info>root^.info) then (* �᫨ 㤠�塞� ������� ����� ⥪. 㧫�, � *)
			delelem(root^.right,info)	(* ������� ��� �� �ࠢ��� �����ॢ� *)
		else	(* ���� ⥪. 㧥� - 㤠�塞� ������� *)
			begin
				if (root^.left=NIL) and (root^.right=NIL) then (* �᫨ ⥪. 㧥� - ����, � *)
					begin
						dispose(root); (* ������� ��� *)
						root:=NIL;	(* ���⠢��� �� ��� ���� ���⮥ ��ॢ� *)
					end
				else
				if (root^.left=NIL) and (root^.right<>NIL) then (* �᫨ � ⥪.㧫� ���� ⮫쪮 �ࠢ�� ���� *)
					begin
						temp:=root; 	(* ��ᮥ������ �� ����� ⥪. 㧫� *)
						root:=root^.right;
						dispose(temp); (* ������� ⥪. 㧥� *)
					end
				else
				if (root^.left<>NIL) and (root^.right=NIL) then  (* �᫨ � ⥪.㧫� ���� ⮫쪮 ����� ���� *)
					begin
						temp:=root;     (* ��ᮥ������ �� ����� ⥪. 㧫� *)
						root:=root^.left;
						dispose(temp);  (* ������� ⥪. 㧥� *)
					end
				else (* ���� � 㧫� ���� ��� ��⢨ *)
					begin
						root^.info:=getmostright(root^.left); (* ��⠢��� �� ���� 㧫� ᠬ� �ࠢ� ��-� ������ �����ॢ� *)
						delelem(root^.left,root^.info); (* ������� ᠬ� �ࠢ� ��-� �� ������ �����ॢ� *)
					end;
						
			end;
	  end;
end;

procedure printlevel(root:Ptree;level,curlevel:integer);
begin
	if (root<>NIL) then		(* �᫨ ��ॢ� �� ���⮥, � *)
		begin
			if (curlevel=level) then	(* �᫨ ⥪.���設� �� �㦭�� �஢��, � *)
				write(root^.info,' ')		(* ��ᯥ���� �� *)
			else	(* ���� *)
				begin
					printlevel(root^.left,level,curlevel+1); (* ��ᯥ���� �� ���設� �ॡ. �஢�� � ����� �����ॢ� *)
					printlevel(root^.right,level,curlevel+1); (* ��ᯥ���� �� ���設� �ॡ. �஢�� � �ࠢ�� �����ॢ� *)
				end;
		end;
end;

procedure printlevel_wrapper(root:PTree;level:integer);
begin
	clrscr;
	writeln('�� ���設� �� �஢�� ',level,' : ');
	printlevel(root,level,0);
	writeln;
	writeln('������ ���� ������� ��� ��室� � ������� ����');
	readkey;
end;

function countdepth(root:PTree;level:integer):integer;
var dr,dl:integer;
begin
	if (root=NIL) then	(* �᫨ ��ॢ� ���⮥, � *)
		countdepth:=level-1	(* ��㡨�� ⥪�饩 ��⢨ = ⥪�饬� �஢�� - 1*)
	else	(* ���� *)
		begin
			dr:=countdepth(root^.left,level+1);
			dl:=countdepth(root^.right,level+1);
			if (dr>dl) then	(* ��㡨�� ⥪�饩 ��⢨ ࠢ�� ���ᨬ��쭮� �� ��㡨� �� �����ॢ쥢 *)
				countdepth:=dr
			else
				countdepth:=dl;
		end;

end;

procedure countdepth_wrapper(root:PTree);
begin
     if (root<>NIL) then
      begin
	writeln('��㡨�� ��ॢ� : ',countdepth(root,0));
	writeln;
	writeln('������ ���� �������');
      end
     else
         writeln('��ॢ� ����!');
	readln;
end;

procedure drawtree(root:PTree);
var Width,Height:integer;
    CurVPort:ViewPortType;
    s:string;
begin
     if (root<>NIL) then	(* �᫨ ��ॢ� �� ���⮥, � *)
        begin
             GetViewSettings(CurVPort);	
             width:=CurVPort.x2-CurVPort.x1;
             height:=CurVPort.y2-CurVPort.y1;
             str(root^.info,s);
             OutTextXY(width div 2,0,s);		(* �뢥�� ���祭�� ���設� � ����-業�� ⥪. ���� *)
             if (root^.left<>NIL) then		(* �᫨ � ���設� ���� ����� ���� *)
                line(width div 2,8,width div 4,height-3);	(* ���ᮢ��� ��१�� ��אַ� � ����� ��⢨ *)
             if (root^.right<>NIL) then		(* �᫨ � ���設� ���� �ࠢ�� ���� *)
                line(width div 2,8,3*width div 4,height-3);	(* ���ᮢ��� ��१�� ��אַ� � �ࠢ�� ��⢨ *)
             with CurVPort do (* ������� ⥪. ���� �� ��ਧ��⠫� �������, ����� ����� ����, ��३� � ᫥�. �஢�� *)
                  setviewport(x1,y2,x1+(width div 2),y2+height,ClipOff);	
             drawtree(root^.left);	 	(* �뢥�� ����� �����ॢ� *)
             with CurVPort do	(* ������� ⥪. ���� �� ��ਧ��⠫� �������, ����� �ࠢ�� ����, ��३� � ᫥�. �஢�� *)
                  setviewport(x1+(width div 2),y2,x2,y2+height,ClipOff);
             drawtree(root^.right);	(* �뢥�� �ࠢ�� �����ॢ� *)
        end;
end;

procedure drawtree_wrapper(root:PTree);
Var GraphDevice,GraphMode:integer;
begin
     if (root<>NIL) then	(* �᫨ ��ॢ� �� ���⮥ *)
        begin
             GraphDevice:=Detect;
             InitGraph(GraphDevice,GraphMode,PathToDriver); (* ���樠����஢��� ��䨪� *)
             if (GraphResult<>grOK) then		(* �᫨ ���樠������ �� 㤠����, � *)
               begin
                  Writeln('Error initializing graphics!');	(* ������� �� �⮬ *)
                  readkey;
               end
             else (* ���� *)
               begin
                  SetViewPort(0,0,GetMaxX,(GetMaxY div (countdepth(root,0)+1)),ClipOff); (*��⠭����� ���� �� ��� �ਭ� ��࠭�
                                                                                          � 0� �஢��� ��ॢ� *)
                  SetTextJustify(CenterText,TopText); 
                  drawtree(root); (* ���ᮢ��� ��ॢ� *)
                  readkey;
                  closegraph;
               end
        end
     else (* ���� *)
       begin
         writeln('��ॢ� ����!'); (* ������� �� �⮬ *)
         readkey;
       end;
end;

procedure showmenu;
begin
	clrscr;
	writeln(' ����୮� ��ॢ�');
	writeln;
	writeln('  1) �������� ������� � ��ॢ�');
	writeln('  2) ��ᯥ���� ��ॢ� � ���� ����� ���� - ��७� - �ࠢ�� ���� (���)');
	writeln('  3) ��ᯥ���� ��ॢ� � ���� ��७� - ����� ���� - �ࠢ�� ���� (���)');
	writeln('  4) ��ᯥ���� ��ॢ� � ���� ����� ���� - �ࠢ�� ���� - ��७� (���)');
	writeln('  5) �뢥�� �᫮ ���設 ��ॢ�');
	writeln('  6) �뢥�� �᫮ ���⮢ ��ॢ�');
	writeln('  7) ������� ������� �� ��ॢ�');
	writeln('  8) ��ᯥ���� �� ���設� �� �������� �஢��');
	writeln('  9) �뢥�� ��㡨�� ��ॢ�');
	writeln(' 10) ���ᮢ��� ��ॢ�');
	writeln(' 11) ��室');
	writeln;
	write('��� �롮� : ');

end;

Var Tree:PTree;
	selection:integer;

begin
	Tree:=NIL; (* ������� ���⮥ ��ॢ� *)
	repeat
		showmenu; (* �뢥�� �� ��࠭ ���� *)
		readln(selection);  (* ����� � ���������� �롮� ���짮��⥫� *)
		writeln;
		case selection of (* �믮����� ����⢨� � ᮮ⢥��⢨� � �⨬ �롮஬ *)
			1: addelem(Tree,getint('������� ��� ����������'));
			2: printLKP_wrapper(Tree);
			3: printKLP_wrapper(Tree);
			4: printLPK_wrapper(Tree);
			5: countels_wrapper(Tree);
			6: countleafs_wrapper(Tree);
			7: delelem(Tree,getint('������� ��� 㤠�����'));
			8: printlevel_wrapper(Tree,getint('�஢���, ����� �㦭� �ᯥ����'));
			9: countdepth_wrapper(Tree);
            10: drawtree_wrapper(Tree);
			11:clrscr;
		end;
	until selection=11;
end.