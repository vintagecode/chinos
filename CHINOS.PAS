Program prac2;

{
	Laboratorio de Programaci¢n 1 - Pr ctica 2
        Dise¤ada por:
                     Jorge Cordero (1§A)
                     Sergio Ruiz   (1§C)
}

Uses
    CRT, Strings;

Const
    Pmax = 10;
    jugadoresArchivo = 100;
    fichSalida = 'datos.txt';

Type
    tJugador = record
    fichas : byte;
    machine : boolean;   {Si/NO}
    prediccion : byte;
    victorias : integer;
    nombre : String;
    partidas : integer;
    media : real;
End;

Type
    tPartida = record
    players : byte;
    jugador : array [0..Pmax-1] of tJugador;
End;

Type
    tJugadas = record
    jugada : array [0..Pmax-1] of integer;
    nJugadas : integer;
End;

Type
    tPartidaAux = record
    playersAux : byte;
    jugadorAux : Array[0..jugadoresArchivo - 1] of tJugador;
End;

Var
    partida : tPartida;
    partidaAux : tPartidaAux;
    presentacion, soloMaq, soloHum, exp, infinito, iradechuck: boolean;
    jugadas : tJugadas;
    hum, maq, totalPartidas, contador, i, inf, sup : byte;
    fichOut : text;
    Q : char;

{Procedures}
Procedure MostrarActual(var partida : tPartida;
		            jugadas : tJugadas);
Var
    i : byte;
Begin {Mostrar}
    clrscr;
    WriteLn('//---------------------------------------------------------------------//');
    WriteLn('//     Ronda actual: ',jugadas.nJugadas:3,'                                               //');
    WriteLn('//                                                                     //');
    WriteLn('//---------------------------------------------------------------------//');
    WriteLn;
    WriteLn('//---------------------------------------------------------------------//');
    WriteLn('                         Lista de los jugadores                        //');
    WriteLn('                                                                       //');
    WriteLn('//---------------------------------------------------------------------//');
    WriteLn;
    WriteLn('    Jugador                 Victorias  ---  Apuesta Actual');
    For i := 0 To partida.players - 1 Do
    Begin
	Write(partida.jugador[i].nombre);
	WriteLn(partida.jugador[i].victorias:3,partida.jugador[i].prediccion:18);
    End;
    WriteLn('//---------------------------------------------------------------------//');
End; {Mostrar}

Procedure IntroducirDatosHum(Var hum : byte);
Var
    x : byte;
    aux, code : integer;
    O : String;
Begin {IntroducirDatosHum}
    i := 1;
    If soloHum Then x := 2
    Else x := 1;
    While i = 1 DO
    Begin
        i := 0;
        Write('Introduzca el n£mero de jugadores humanos (de ',x,' a ',Pmax,'): ');
        ReadLn(O);
        Val(O,aux,code);
        If (aux < x) OR (aux > Pmax) Then i := 1
	Else
	Begin
	    hum := aux;
	End;
    End;
    i:=0;
    While i < hum Do
    Begin
        Write('Dame el nombre del jugador ',i + 1,': ');
	ReadLn(partida.jugador[i].nombre);
	For x := Length(partida.jugador[i].nombre) To 29 Do
	Begin
    	    partida.jugador[i].nombre := partida.jugador[i].nombre + ' ';
	End;
	i:=i+1;
    End;

    partida.players := hum;

    i := 0;
    For i := 0 To hum - 1 Do partida.jugador[i].machine := false;
    If presentacion Then WriteLn('DATOS: Se ha puesto a los jugadores como humanos, y se ha almacenado sus nombres.');
End; {IntroducirDatosHum}

Procedure FichasHum(var x : byte);
Var
    p : byte;
    aux, code : integer;
Begin {FichasHum}
    p := 0;
    While p = 0 Do
    Begin
        p := 1;
        ClrScr;
        MostrarActual(partida,jugadas);
        WriteLn('Turno de ',partida.jugador[i].nombre);
        Write('Pon tus fichas: ');
        ReadLn(Q);
        If (Q < '0') OR (Q > '3') Then p := 0
        Else
        Begin
            Val(Q,aux,code);
            partida.jugador[i].fichas := aux;
        End;
    End;
    If presentacion Then
    Begin
	WriteLn('DATOS: Se han guardado las fichas de ',partida.jugador[i].nombre);
	ReadLn;
    End;
End; {FichasHum}

Procedure CompruebaApuestasHum(VAR x : byte);
Var
    a, RP, RG, m : byte;
Begin {CompruebaApuestasHum}
    If presentacion Then
    Begin
	WriteLn('DATOS: Comprobando apuestas de los humanos.');
	ReadLn;
    End;
    RP := 1;
    RG := 1;
    While (RP = 1) OR (RG = 1) Do
    Begin
	RP := 0;
	RG := 0;
	a := partida.jugador[x].fichas;
	If (partida.jugador[x].prediccion < a) OR (partida.jugador[x].prediccion > (partida.players*3 - 3 + a)) Then
	Begin
	    RG := 1;
	    Write('Debe introducir un valor entre ',a,' y ',(partida.players*3 - 3 + a),': ');
	    ReadLn(partida.jugador[x].prediccion);
        End
	Else
        Begin
	    For m := 0 To x Do
	    Begin
	        If (partida.jugador[x].prediccion = partida.jugador[m].prediccion) AND (x<>m) Then
	        Begin
		    RP:=1;
		    Write('Esa apuesta ya existe, debe dar un valor distinto: ');
		    ReadLn(partida.jugador[x].prediccion);
	        End;
	    End;
        End;
    End;
End; {CompruebaApuestasHum}

Procedure Burbuja(Var partida : tPartida);
Var
    aux : tPartida;
    i, j : byte;
Begin {Burbuja}
    If presentacion Then
    Begin
	WriteLn('DATOS: Ordenando jugadores mediante el criterio de la burbuja.');
	ReadLn;
    End;
    For i := 0 To partida.players-1 Do
    Begin
	For j := 0 To partida.players-2 Do {bucle que compara cada par consecutivo de elementos y los ordena}
	Begin
	    If(partida.jugador[j].media > partida.jugador[j+1].media) Then
	    Begin
                aux.jugador[j+1] := partida.jugador[j+1]; {guardamos el segundo valor en una variable auxiliar}
		partida.jugador[j+1] := partida.jugador[j]; {ponemos el primer valor en segundo lugar}
		partida.jugador[j] := aux.jugador[j+1]; {recuperamos el auxiliar y lo ponemos en el primer lugar}
	    End;
	End;
    End;
End; {Burbuja}

Procedure BurbujaAux(Var partidaAux : tPartidaAux);
Var
    aux : tPartida;
    p, q : byte;
Begin {BurbujaAux}
    If presentacion Then
    Begin
	WriteLn('DATOS: Ordenando jugadores mediante el criterio de la burbuja.');
	ReadLn;
    End;
    For p := 0 To partidaAux.playersAux - 1 Do
    Begin
        For q := 0 To partidaAux.playersAux - 2 Do {bucle que compara cada par consecutivo de elementos y los ordena}
	Begin
	    If(partidaAux.jugadorAux[q].media > partidaAux.jugadorAux[q+1].media) Then
	    Begin
                aux.jugador[q+1] := partidaAux.jugadorAux[q+1]; {guardamos el segundo valor en una variable auxiliar}
		partidaAux.jugadorAux[q+1] := partidaAux.jugadorAux[q]; {ponemos el primer valor en segundo lugar}
		partidaAux.jugadorAux[q] := aux.jugador[q+1]; {recuperamos el auxiliar y lo ponemos en el primer lugar}
	    End;
	End;
    End;
End; {BurbujaAux}

Procedure ReordenaJugadores;
Begin {ReordenaJugadores}
    If presentacion Then
    Begin
	WriteLn('DATOS: Reordenando aleatoriamente los jugadores.');
	ReadLn;
    End;
    For i := 0 to partida.players - 1 Do
    Begin
	partida.jugador[i].media := random(200);
    End;
    Burbuja(partida);
End; {ReordenaJugadores}

Procedure IniciaValoresJugadores;
Begin {IniciaValoresJugadores}
    For i := 0 to partida.players - 1 Do
    Begin
	partida.jugador[i].partidas := 0;
	partida.jugador[i].victorias := 0;
	partida.jugador[i].media := 0;
	ReordenaJugadores;
    End;
End; {IniciaValoresJugadores}

Procedure CompruebaApuestasMaq(VAR x : byte);
VAR
    a, RP, RG, i : byte;
Begin {CompruebaApuestasMaq}
    If presentacion Then
    Begin
	WriteLn('DATOS: Comprobando la apuesta de ',partida.jugador[x].nombre);
	ReadLn;
    End;
    RP := 1;
    RG := 1;
    While (RP = 1) OR (RG = 1) Do
    Begin
	RP := 0;
	RG := 0;
	a := partida.jugador[x].fichas;
	If (partida.jugador[x].prediccion < a) OR (partida.jugador[x].prediccion > (partida.players*3 - 3 + a)) Then
	Begin
	    RG := 1;
	    If exp Then
	    Begin
		partida.jugador[x].prediccion := random(sup+1-inf);
		partida.jugador[x].prediccion := partida.jugador[x].prediccion + inf;
	    End
	    Else partida.jugador[x].prediccion := random((partida.players*3) + 1);
        End
	Else
        Begin
	    For i := 0 To x Do
	    Begin
	        If (partida.jugador[x].prediccion = partida.jugador[i].prediccion) AND (x<>i) Then
	        Begin
		    RP:=1;
		    If exp Then
	            Begin
		        partida.jugador[x].prediccion := random(sup+1-inf);
		        partida.jugador[x].prediccion := partida.jugador[x].prediccion + inf;
	            End
	            Else partida.jugador[x].prediccion := random((partida.players*3) + 1);
	        End;
	    End;
        End;
    End;
End; {CompruebaApuestasMaq}

Procedure ApuestasHum(var hum : byte);
Var
    p : byte;
    fich, max : String;
    aux, code : integer;
    O : String;
Begin {ApuestasHum}
    p := 0;
    While p = 0 Do
    Begin
        p := 1;
        ClrScr;
        MostrarActual(partida,jugadas);
        WriteLn('Turno de ',partida.jugador[i].nombre);
        Write('Introduce tu apuesta: ');
        ReadLn(O);
        Val(O,aux,code);
        If (aux < partida.jugador[i].fichas) OR (aux > partida.players*3 - (3 - partida.jugador[i].fichas)) Then p:= 0
        Else
        Begin
            Val(O,aux,code);
            partida.jugador[i].prediccion := aux;
        End;
    End;
    CompruebaApuestasHum(i);
End; {ApuestasHum}

Procedure AsignaNombresMaq;
Var
	i, j, Q, RP, RG : byte;
Begin {AsignaNombresMaq}
    If soloMaq then hum := 0;
    RP := 1;
    While RP = 1 DO
    Begin
	RP:=0;
	For i := hum To partida.players - 1 Do {esto lo hemos cambiado ///////////////////////}
	Begin
	    Q := random(Pmax);
	    Case Q of
		0 : partida.jugador[i].nombre := '[BOT]Aragorn, Hijo de Arathorn';
		1 : partida.jugador[i].nombre := '[BOT]Ray McCoy                ';
		2 : partida.jugador[i].nombre := '[BOT]John Locke               ';
		3 : partida.jugador[i].nombre := '[BOT]McGyver                  ';
		4 : partida.jugador[i].nombre := '[BOT]Don Vito Corleone        ';
		5 : partida.jugador[i].nombre := '[BOT]Paul Atreides            ';
		6 : partida.jugador[i].nombre := '[BOT]Tony Montana             ';
		7 : partida.jugador[i].nombre := '[BOT]Fox Mulder               ';
		8 : partida.jugador[i].nombre := '[BOT]Chuck Norris             ';
		9 : partida.jugador[i].nombre := '[BOT]Darth Vader              ';
	    End;
    	For j := hum To {partida.players - 1}i Do
	Begin
	    If (partida.jugador[i].nombre = partida.jugador[j].nombre) AND (i <> j) Then
	    Begin
		RP:=1;
		Q := random(Pmax);
		Case Q of
		    0 : partida.jugador[i].nombre := '[BOT]Aragorn, Hijo de Arathorn';
		    1 : partida.jugador[i].nombre := '[BOT]Ray McCoy                ';
		    2 : partida.jugador[i].nombre := '[BOT]John Locke               ';
		    3 : partida.jugador[i].nombre := '[BOT]McGyver                  ';
		    4 : partida.jugador[i].nombre := '[BOT]Don Vito Corleone        ';
		    5 : partida.jugador[i].nombre := '[BOT]Paul Atreides            ';
		    6 : partida.jugador[i].nombre := '[BOT]Tony Montana             ';
		    7 : partida.jugador[i].nombre := '[BOT]Fox Mulder               ';
		    8 : partida.jugador[i].nombre := '[BOT]Chuck Norris             ';
		    9 : partida.jugador[i].nombre := '[BOT]Darth Vader              ';
		End;
	    End;
	End;
	End;
	For i := hum To partida.players - 1 Do partida.jugador[i].machine := true;
    End;
End; {AsignaNombresMaq}

Procedure FichasMaq(VAR x : byte);
Begin {FichasMaq}
    partida.jugador[x].fichas := random(4);
    If presentacion Then
    Begin
        WriteLn(partida.jugador[x].nombre,' tiene ',partida.jugador[x].fichas,' fichas.');
        ReadLn;
    End;
End; {FichasMaq}

Procedure Principiante(Var x : byte);
Var
    p : byte;
Begin
    partida.jugador[x].prediccion := random((partida.players*3) + 1);
    p := 0;
    While p = 0 Do
    Begin
	If (partida.jugador[x].prediccion < partida.jugador[x].fichas) Then
	    partida.jugador[x].prediccion := random((partida.players*3) + 1)
	Else p := 1;
    End;
    MostrarActual(partida,jugadas);
    CompruebaApuestasMaq(x);
    If presentacion Then WriteLn('DATOS: ',partida.jugador[x].fichas,' fichas tiene ',partida.jugador[x].nombre);
    If presentacion Then WriteLn('DATOS: ',partida.jugador[x].prediccion,' es la apuesta de ',partida.jugador[x].nombre);
End;

Procedure Experto(Var x : byte);
Var
    suma, i, media, c : byte;
Begin
    {Randomize;}
    suma := 0;
    media := 0;
    inf := partida.players DIV 2; {comenzamos a acotar por la izquierda valores que no son posibles que salgan}
    sup := partida.players*3 - inf; {comenzamos a acotar por la derecha valores que no son posibles que salgan}
    c := 0; {ser  la predicci¢n}
    If x <> 0 Then
    Begin
	For i := 0 To (x - 1) Do suma := suma + partida.jugador[i].prediccion;
	media := suma DIV x;
	media := media DIV partida.players;
	inf := inf + partida.jugador[x].fichas + media;
        { a lo ya acotado, le quitamos primero lo imposible (las fichas) y luego lo improbable (la media)}
	sup := sup - (3 - partida.jugador[x].fichas - media);
	c := random(sup+1-inf); {si no tira, encima ponemos c := sup+1-inf; }
	c := c + inf;
    End
    Else
    Begin
	inf := inf + partida.jugador[x].fichas;
	sup := sup - (3 - partida.jugador[x].fichas);
	c := random(sup+1-inf); {si no tira, encima ponemos c := sup+1-inf; }
	c := c + inf;
    End;

    partida.jugador[x].prediccion := c;
    MostrarActual(partida,jugadas);
    CompruebaApuestasMaq(x);
    If presentacion Then WriteLn('DATOS: ',partida.jugador[x].fichas,' fichas tiene ',partida.jugador[x].nombre);
    If presentacion Then WriteLn('DATOS: ',partida.jugador[x].prediccion,' es la apuesta de ',partida.jugador[x].nombre);
End;

Procedure IntroducirDatosMaq(var soloMaq, exp : boolean); {hemos quitado maq}
Var
    OK : byte;
    eleccion : Char;
    aux, code : integer;
    maquinas : String;
Begin {IntroducirDatosMaq}
    i := 0;
    While i = 0 Do
    Begin
        ClrScr;
	WriteLn('//---------------------------------------------------------------------//');
	WriteLn('                       ¨Qu‚ nivel de dificultad desea?');
	WriteLn('                               1 - Principiante');
	WriteLn('                               2 - Experto');
	WriteLn('//---------------------------------------------------------------------//');
	Write('Esperando que el usuario introduzca datos: ');
	ReadLn(eleccion);
	If (eleccion = '1') Then
	Begin
	    exp := false;
	    i := 1;
	End
	Else
	Begin
	    If (eleccion = '2') Then
	    Begin
		exp := true;
		i := 1;
	    End;
	End;
    End;
    i := 0;
    While i = 0 Do
    Begin
        i := 1;
	If (soloMaq) Then
	Begin
	    Write('Introduzca el n£mero de m quinas (de 2 a ',Pmax,'): ');
	    ReadLn(maquinas);
            Val(maquinas,aux,code);
	    If (aux < 2) OR (aux > Pmax) Then i := 0;
	End
	Else
	Begin
	    Write('Introduzca el n£mero de m quinas (de 1 a ',Pmax - partida.players,'): ');
	    ReadLn(maquinas);
            Val(maquinas,aux,code);
	    If (aux < 1) OR (aux > (Pmax - partida.players)) Then i := 0;
	End;
    End;
    maq := aux;
    partida.players := partida.players + maq;
    AsignaNombresMaq;
End; {IntroducirDatosMaq}

Procedure MenuPrincipal;
Var
    eleccion : char;
    total : String;
    code, aux : integer;
Begin {MenuPrincipal}
    i := 0;
    While i = 0 Do
    Begin
        ClrScr;
        If presentacion Then WriteLn('Ha activado el modo presentaci¢n.');
        If iradechuck Then WriteLn('Ha desatado la Ira de Chuck.');
	WriteLn('//---------------------------------------------------------------------//');
	WriteLn('//                 Juego de los Chinos©');
	WriteLn('//---------------------------------------------------------------------//');
	WriteLn('     Introduzca el modo de juego que desea:');
	WriteLn('               1 - S¢lo Humanos');
	WriteLn('               2 - Solo M quinas');
	WriteLn('               3 - Humanos y Maquinas');
        WriteLn('               4 - Modo Presentaci¢n');
        WriteLn('                                                           /0 - EXIT   //');
	WriteLn('//---------------------------------------------------------------------//');
	Write('Esperando que el usuario introduzca datos: ');
	ReadLn(eleccion);
	If eleccion = '1' Then
	Begin
	    soloHum := true;
	    IntroducirDatosHum(hum);
	    i := 1;
	End;
	If eleccion = '2' Then
	Begin
	    soloMaq := true;
	    IntroducirDatosMaq(soloMaq, exp);
	    i := 1;
	End;
	If eleccion = '3' Then
	Begin
	    soloMaq := false;
	    IntroducirDatosHum(hum);
	    IntroducirDatosMaq(soloMaq, exp);
	    i := 1;
	End;
	If eleccion = 'c' Then
	Begin
	    iradechuck := true;
	End;
        If eleccion = '0' Then halt(1);
        If eleccion = '4' Then
	Begin
	    presentacion := true;
        End;
    End;
    i := 0;
    While i = 0 Do
    Begin
        ClrScr;
	WriteLn('//---------------------------------------------------------------------//');
	WriteLn('     Introduzca cuantas partidas desea jugar:');
	WriteLn('        - M¡nimo ',partida.players);
	WriteLn('        - M ximo 200');
	WriteLn('        - 0 para infinitas');
	WriteLn('//---------------------------------------------------------------------//');
	Write('Esperando que el usuario introduzca datos: ');
	ReadLn(total);
        Val(total,aux,code);
	If (aux >= partida.players) AND (aux <= 200) Then
	Begin
	    totalPartidas := aux;
	    infinito := false;
	    i := 1;
	End;
	If total = '0' Then
	Begin
	    infinito := true;
	    i := 1;
	End;
    End;
    IniciaValoresJugadores;
    If presentacion Then
    Begin
	ClrScr;
	WriteLn('DATOS: Mostrando la partida ya creada.');
	If (maq <> 0) AND (exp) Then WriteLn('DATOS: Se ha elegido la dificultad Experto.')
	Else If (maq <> 0) AND (NOT exp) Then WriteLn('DATOS: Se ha elegido la dificultad Principiante.');
	If (hum <> 0) AND (maq <> 0) Then WriteLn('DATOS: Van a jugar humanos y m quinas.');
	If (hum <> 0) AND (maq = 0) Then WriteLn('DATOS: Van a jugar s¢lo humanos.');
	If soloMaq Then WriteLn('DATOS: Van a jugar s¢lo maquinas.');
	WriteLn('DATOS: Hay ',partida.players,' jugadores.');
	If hum <> 0 Then WriteLn('DATOS: ',hum,' son humanos.');
	If maq <> 0 Then WriteLn('DATOS: ',maq,' son m quinas.');
	WriteLn('DATOS: Los nombres de los jugadores reordenados aleatoriamente son: ');
	For i := 0 To partida.players - 1 Do WriteLn('DATOS: [',i+1,'] ',partida.jugador[i].nombre);
	If infinito Then
	Begin
	    WriteLn('DATOS: Se ha elegido jugar un n£mero ilimitado de partidas.');
	    WriteLn('DATOS: Se solicitar  al usuario que llegadas ',partida.players,' partidas, diga si seguir jugando o no.');
	End
	Else
	    WriteLn('DATOS: Se ha elegido jugar ',totalPartidas,' partidas.');
	WriteLn('DATOS: Pulse ENTER para comenzar la partida...');
	ReadLn;
	MostrarActual(partida,jugadas);
    End;
End; {MenuPrincipal}

Procedure QuienGana;
Var
    suma : integer;
    m, i : byte;
Begin {QuienGana}
    suma := 0;
    For i := 0 To (partida.players - 1) Do suma := suma + partida.jugador[i].fichas; {es el valor ganador}
    m := 255;
    For i := 0 to (partida.players - 1) Do
    Begin
	If partida.jugador[i].prediccion = suma Then
	Begin
	    partida.jugador[i].victorias := partida.jugador[i].victorias + 1;
	    m := i;
	End;
    End;
    MostrarActual(partida,jugadas);
    If presentacion Then WriteLn('DATOS: La suma es ',suma,'.');
    If (m <> 255) Then
    Begin
        WriteLn('Ha ganado ',partida.jugador[m].nombre);
        WriteLn('­­­Enhorabuena!!!');
    End
    Else
        WriteLn('­­­No ha habido ganador!!!');
End; {QuienGana}

Procedure RotarTurno;
Var
    aux : tJugador;
Begin {RotarTurno}
    If presentacion Then WriteLn('DATOS: Rotando el turno de los jugadores.');
    aux := partida.jugador[0];
    For i := 0 To partida.players - 1 Do partida.jugador[i] := partida.jugador[i+1];
    partida.jugador[partida.players - 1] := aux;
End; {RotarTurno}

Procedure Chuck(Var x : byte);
Begin {Chuck}
    If iradechuck Then
    Begin
	If (partida.jugador[x].nombre = '[BOT]Chuck Norris             ') Then
	Begin
	    ClrScr;
            If presentacion Then WriteLn('DATOS: Mostrando a Chuck.');
	    WriteLn('MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMMMMMMW0xolcccldOWMMMMMMMMMMMMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMMMMMO','          .OWMMMMMMMMMMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMMMMo              ;KMMMMMMMMMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMMMO                .OMMMMMMMMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMMM:                 .:;,,,;cok0WMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMWOl;','..',';:::cc.                            .:kNMMMMMMMM');
            Delay(10);
            WriteLn('MMMX,                                              .OWMMMMMM');
            Delay(10);
            WriteLn('MMMo                                                 kMMMMMM');
            Delay(10);
            WriteLn('MMMd                     .                           ','WMMMMM');
            Delay(10);
            WriteLn('MMMX.             ',':.   .X0:   :oONo','                .NMMMMM');
            Delay(10);
            WriteLn('MMMMK.           oKlll.;XMMMKOkkKMMMW:               ;MMMMMM');
            Delay(10);
            WriteLn('MMMMMK.          kNWMWkKMMMMMMMMMMMMMk              .0MMMMMM');
            Delay(10);
            WriteLn('MMMMMMNd','        kMMMMWWWNWMMMMMMMMMWl  ,.         .OMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMW0l.     OMMMN;','lxKMMMMMMMMMo .kWWl       :KMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMW0l.  kMWd.    .cxNMMMMMW,.0XWx      ,0MMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMNk;dX,.','cll;,..,OMNx. ;MWk   .,oKWMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMX','. 0WMWNWMMMX;.l.   o0,   ;NMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMl  .,,. .,,,,.      Ox    :WMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMX,                ;OMXd.  ,WMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMMNd.            ;0MMNl.  .xWMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMMMMNKd,','...',';oONWMWO','    oWMMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMMMMNkNMMMMMMMMMMWO,       dWMMMMMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMMMWKo. lMMMM0KWMXx,          :x0XWMMMMMMMMMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMW0;    .NMMMWXd;.                .',';codOKWMMM');
            Delay(10);
            WriteLn('MMMMMMMMMMMMMMMWK0000OONMMMMXOOOOOOOOOOOOOOOOOOOOOOOOOOONMMM');
            Delay(10);
	    WriteLn;
            Delay(10);
	    WriteLn;
            Delay(10);
	    Write('CHUCK SIEMPRE GANA!!!');
	    ReadLn;
	    Halt(1);
	End;
    End;
End; {Chuck}

Procedure ActualizaDatosPartida;
Var
    i, P, j, m : byte;
Begin {ActualizaDatosPartida}
    If partidaAux.playersAux = 0 Then m := partida.players
    Else m := partidaAux.playersAux;
    For i := 0 To partida.players - 1 Do
    Begin
	P := 0;
	While P = 0 Do
        Begin
	    For j := 0 To m - 1 Do
	    Begin
	        If partida.jugador[i].nombre = partidaAux.jugadorAux[j].nombre then
		Begin
		    With partidaAux.jugadorAux[j] Do
		    Begin
		    	partidas := partidas + partida.jugador[i].partidas;
			victorias := victorias + partida.jugador[i].victorias;
			media := (victorias*100)/partidas;
			P := 1;
                        partidaAux.playersAux := partidaAux.playersAux - 1;
		    End;
		End;
	    End;
	    If P = 0 Then
	    Begin
		partidaAux.jugadorAux[partidaAux.playersAux] := partida.jugador[i];
		P := 1;
	    End;
	End;
	partidaAux.playersAux := partidaAux.playersAux + 1;
    End;
End; {ActualizaDatosPartida}

Procedure ActualizaDatosDB;
Var
    lineaOut : String;
    code, x : Integer;
    y : Real;
    p : byte;
Begin {ActualizaDatosDB}
    Assign(fichOut,fichSalida);
    {$I-}                          { Desactiva errores de E/S }
    Reset(fichOut);                { e intenta leer }
    {$I+}
    partidaAux.playersAux := 0;
    p := 0;
    If ioresult = 0 Then          {Si existen los datos}
    Begin
        Repeat
	Begin
	    ReadLn(fichOut,lineaOut);
	    partidaAux.jugadorAux[p].nombre := lineaOut;
	    ReadLn(fichOut,lineaOut);
            Val(lineaOut,x,code);
	    partidaAux.jugadorAux[p].partidas := x;
	    ReadLn(fichOut,lineaOut);
	    Val(lineaOut,x,code);
	    partidaAux.jugadorAux[p].victorias := x;
	    ReadLn(fichOut,lineaOut);
	    Val(lineaOut,y,code);
	    partidaAux.jugadorAux[p].media := y;
	    partidaAux.playersAux := partidaAux.playersAux + 1;
            p := p + 1;
	End;
	Until eof(fichOut);
	Close(fichOut);
	ActualizaDatosPartida;
    End
    Else
    Begin
	ActualizaDatosPartida;
    End;
End; {ActualizaDatosDB}

Procedure CreaDB;
Begin {CreaDB}
    Assign(fichOut,fichSalida);
    Rewrite(fichOut);
    For i := 0 To partidaAux.playersAux - 1 Do
    Begin
	WriteLn(fichOut,partidaAux.jugadorAux[i].nombre);
	WriteLn(fichOut,partidaAux.jugadorAux[i].partidas);
	WriteLn(fichOut,partidaAux.jugadorAux[i].victorias);
	WriteLn(fichOut,partidaAux.jugadorAux[i].media:3:1);
    End;
    Close(fichOut);
End; {CreaDB}

Procedure MenuFinal;
Var
    fin : boolean;
    lineaExit : String;
    eleccion : char;
Begin {MenuFinal}
    If not presentacion Then
    Begin
        ActualizaDatosDB;
        Burbuja(partida);
	BurbujaAux(partidaAux);
        CreaDB;
    End;
    Repeat
    Begin
	ClrScr;
    	WriteLn('//---------------------------------------------------------------------//');
    	WriteLn('//     ¨C¢mo desea mostrar los resultados?                             //');
    	WriteLn('//          1 - Mostrar los de esta partida                            //');
    	WriteLn('//          2 - Mostrar el registro de todos los jugadores             //');
    	WriteLn('//                                                    /o - EXIT        //');
    	WriteLn('//---------------------------------------------------------------------//');
    	Write('Esperando que el usuario introduzca datos: ');
    	ReadLn(eleccion);
    	If eleccion = '1' Then
    	Begin
            For i := 0 To partida.players - 1 Do
	    Begin
	    	Write(partida.jugador[i].nombre,'==>Total:',partida.jugador[i].partidas:3);
		Write('==>Ganadas:',partida.jugador[i].victorias:3);
		WriteLn('==>Media:',partida.jugador[i].media:3:1,'%');
    	    End;
            ReadLn;
        End;
        If eleccion = '2' Then
        Begin
            If NOT presentacion Then
            Begin
                Assign(fichOut,fichSalida);
                Reset(fichOut);
	        fin := false;
	        While (not eof(fichOut)) Do
                Begin
		    ReadLn(fichOut,lineaExit);
		    Write(lineaExit);
		    ReadLn(fichOut,lineaExit);
		    Write('==>Total:',lineaExit:3);
		    ReadLn(fichOut,lineaExit);
		    Write('==>Ganadas:',lineaExit:3);
		    ReadLn(fichOut,lineaExit);
		    WriteLn('==>Media: ',lineaExit:3,'%');
		    fin := true;
                End;
	        Close(fichOut);
                ReadLn;
            End
            Else
            Begin
                WriteLn('DATOS: En modo presentacion no puedes acceder a la base de datos.');
                ReadLn;
            End;
        End;
    End;
    Until (eleccion = '0');
    halt(1);
End; {MenuFinal}

Procedure Juego;
Var
    Q : char;
Begin {Juego}
    jugadas.nJugadas := 0;
    If infinito Then totalPartidas := 200;
    While jugadas.nJugadas < totalPartidas Do
    Begin
        jugadas.nJugadas := jugadas.nJugadas + 1;
	For i := 0 To partida.players - 1 Do partida.jugador[i].prediccion := 0;
        For i := 0 to partida.players - 1 Do
        Begin
            If partida.jugador[i].machine then FichasMaq(i)
            Else FichasHum(i);
        End;
        For i := 0 to partida.players - 1 Do
        Begin
            If partida.jugador[i].machine then
            Begin
                If exp Then Experto(i)
                Else Principiante(i);
                Chuck(i);
            End
            Else ApuestasHum(i);
        End;
        QuienGana;
        If (jugadas.nJugadas >= partida.players) AND infinito Then
        Begin
            Write('¨Desea terminar la partida? (s/n)');
            ReadLn(Q);
            If (Q = 's') OR (Q = 'S') Then totalPartidas := 0;
	    If (Q = 'n') OR (Q = 'N') Then Write;
        End;
        RotarTurno;
        ReadLn;
    End;
    For i := 0 To partida.players - 1 Do
    Begin
        partida.jugador[i].partidas := partida.jugador[i].partidas + jugadas.nJugadas;
        partida.jugador[i].media := (partida.jugador[i].victorias * 100) / partida.jugador[i].partidas;
    End;
    MenuFinal;
End; {Juego}

Begin {prac2}
    iradechuck := false;
    Randomize;
    MenuPrincipal;
    Juego;
End. {prac2}