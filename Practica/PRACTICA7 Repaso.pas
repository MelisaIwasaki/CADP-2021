{
1. Una productora nacional realiza un casting de personas para la selección de actores extras de una
nueva película, para ello se debe leer y almacenar la información de las personas que desean
participar de dicho casting. De cada persona se lee: DNI, apellido y nombre, edad y el código de
género de actuación que prefiere (1: drama, 2: romántico, 3: acción, 4: suspenso, 5: terror). La lectura
finaliza cuando llega una persona con DNI 33555444, la cual debe procesarse.
Una vez finalizada la lectura de todas las personas, se pide:
a. Informar la cantidad de personas cuyo DNI contiene más dígitos pares que impares.
b. Informar los dos códigos de género más elegidos.
c. Realizar un módulo que reciba un DNI, lo busque y lo elimine de la estructura. El DNI puede no
existir. Invocar dicho módulo en el programa principal.
}
program casting; 
const
  tipo=5;
  corte=335;//55444;
type
  cadena=string[60];
  rango=1..tipo;
  actores=record
    dni:integer;
    apeYnom:cadena;
    edad:integer;
    genero:rango;
  end;
  lista=^nodo;
  nodo=record
    dato:actores;
    sig:lista;
  end;
  vcont=array[rango ]of integer;
  
procedure leer(var a:actores);
begin
  writeln('Ingrese el dni');
  readln(a.dni);
  writeln('Ingrese el apellido y nombre');
  readln(a.apeYnom);
  writeln('Ingrese la edad');
  readln(a.edad);
  writeln('Ingrese el genero');
  readln(a.genero);
end;
procedure agregarAdelante(var L:lista;a:actores);
var nue:lista;
begin
  new(nue);
  nue^.dato:=a;
  nue^.sig:=L;
  L:=nue;
end;
procedure cargarLista(var L:lista);
var a:actores;
begin
  repeat
    leer(a);
    agregarAdelante(L,a);
  until(a.dni=corte);
end;
function masPares(dni:integer):boolean;
var dig,par,impar:integer;
begin
  par:=0;impar:=0;
  while(dni<>0)do begin
    dig:=dni mod 10;
    if(dig mod 2= 0)then  par:=par+1
                    else  impar:=impar+1;
    dni:=dni div 10;
  end;
  if(par>impar)then
    masPares:=true
  else
    masPares:=false;
end;
procedure inicializar(var v:vcont);
var i:rango;
begin
  for i:=1 to tipo do
    v[i]:=0;
end;
procedure maximo(var max1,max2:integer;var cod1,cod2:rango;v:vcont);
var i:rango;
begin
  for i:=1 to tipo do 
    if(v[i]>max1)then begin
      max2:=max1;
      max1:=v[i];
      cod2:=cod1;
      cod1:=i;
    end
    else if(v[i]>max2)then begin
           max2:=v[i];
           cod2:=i;
    end;
end;
procedure recorrerLista(L:lista);
var cant,max1,max2:integer;
    cod1,cod2:rango;
    v:vcont;
begin
  cant:=0;
  max1:=-1;
  inicializar(v);
  while(L<>nil)do begin
    if(masPares(L^.dato.dni))then
      cant:=cant+1;
    v[L^.dato.genero]:=v[L^.dato.genero]+1;
  
    L:=L^.sig;
  end;
  maximo(max1,max2,cod1,cod2,v);
  writeln('Los dos códigos de género más elegidos:',cod1,' y ',cod2);
  writeln('Cantidad de personas cuyo DNI contiene más dígitos pares que impares:',cant);
end;
procedure eliminarDNI(var L:lista; dni:integer; var exito:boolean);
var  ant,act:lista;
begin
     exito:= false;
     act:= L;
     while(act <> nil)and(act^.dato.dni <> dni )do begin
          ant:= act;
          act:= act^.sig;
     end;
     if(act <> nil)then begin
          exito:= true;
          if(act = L)then   L:= act^.sig
                     else   ant^.sig:= act^.sig;
          dispose(act);
     end;
end;          
procedure mostrar(L:lista);
begin
  while(L<>nil)do begin
    writeln(L^.dato.dni,' ',L^.dato.apeYnom,' ',L^.dato.edad,' ',L^.dato.genero);
    L:=L^.sig;
  end;
end;
var
  L:lista;
  dni:integer;
  ok:boolean;
begin
  L:=nil;
  cargarLista(L);
  mostrar(L);   //prueba
  recorrerLista(L);
  writeln('Ingrese el DNI a eliminar');
  readln(dni);
  eliminarDNI(L,dni,ok);
  mostrar(L);   //prueba
end.
{
2. Implementar un programa que lea y almacene información de clientes de una empresa aseguradora
automotriz. De cada cliente se lee: código de cliente, DNI, apellido, nombre, código de póliza
contratada (1..6) y monto básico que abona mensualmente. La lectura finaliza cuando llega el cliente
con código 1122, el cual debe procesarse.
La empresa dispone de una tabla donde guarda un valor que representa un monto adicional que el
cliente debe abonar en la liquidación mensual de su seguro, de acuerdo al código de póliza que tiene
contratada.
Una vez finalizada la lectura de todos los clientes, se pide:
a. Informar para cada cliente DNI, apellido, nombre y el monto completo que paga mensualmente
por su seguro automotriz (monto básico + monto adicional).
b. Informar apellido y nombre de aquellos clientes cuyo DNI contiene al menos dos dígitos 9.
c. Realizar un módulo que reciba un código de cliente, lo busque (seguro existe) y lo elimine de la
estructura.
}  
program automotriz;
const
  poliza=6;
type
  rango=1..poliza;
  cadena=string[30];
  cliente=record
    codigo:integer;
    dni:integer;
    apellido:cadena;
    nombre:cadena;
    codPol:rango;
    monto:real;
  end;
  lista=^nodo;
  nodo=record
    dato:cliente;
    sig:lista;
  end;
  tabla=array[rango]of real;//se dispone

procedure montoAdicional(var v:tabla); //se dispone, lo cargue para probar
begin
  v[1]:=100;
  v[2]:=200;
  v[3]:=300;
  v[4]:=400;
  v[5]:=500;
  v[6]:=600;
end;
procedure leer(var c:cliente);
begin
  writeln('Ingrese el codigo');
  readln(c.codigo);
  writeln('Ingrese el dni');
  readln(c.dni);
  writeln('Ingrese el apellido');
  readln(c.apellido);
  writeln('Ingrese el nombre');
  readln(c.nombre);
  writeln('Ingrese el codigo de poliza');
  readln(c.codPol);
  writeln('Ingrese el monto');
  readln(c.monto);
end;
procedure agregarAdelante(var L:lista;c:cliente);
var nue:lista;
begin
  new(nue);
  nue^.dato:=c;
  nue^.sig:=L;
  L:=nue;
end;
procedure cargar(var L:lista);
var c:cliente;
begin
  repeat
    leer(c);
    agregarAdelante(L,c);
  until(c.codigo=1122);
end;
procedure informar(L:lista;v:tabla);
var  completo:real;
begin
    completo:=L^.dato.monto+v[L^.dato.codPol];
    writeln('DNI:',L^.dato.dni,'Apellido:',L^.dato.apellido,'Nombre:',L^.dato.nombre);
    writeln('Monto completo:',completo:2:2);
end;
function dosDigNueve(dni:integer):boolean;
var dig,nueve:integer;
begin
  nueve:=0;
  while(dni<>0)and(nueve<2)do begin
    dig:=dni mod 10;
    if(dig=9)then nueve:=nueve+1;
    dni:=dni div 10;
  end;
  if(nueve>=2)then
    dosDigNueve:=true
  else
    dosDigNueve:=false;
end;
procedure recorrer(L:lista);
var v:tabla;
begin
  montoAdicional(v);
  while(L<>nil)do begin
    informar(L,v);
    if(dosDigNueve(L^.dato.dni))then
      writeln('Apellido y nombre de clientes cuyo DNI contiene al menos dos dígitos 9:',L^.dato.apellido,' ',L^.dato.nombre);
    L:=L^.sig;
  end;
end;
procedure eliminar(var L:lista);
var ant,act:lista;codigo:integer;
begin
  writeln('Ingrese un codigo a eliminar');
  readln(codigo);
  act:=L;
  while(act<>nil)and(act^.dato.codigo<>codigo)do begin
    ant:=act;
    act:=act^.sig;
  end;
  if(act<>nil)then begin
    if(act=L)then  L:=L^.sig
    else   ant^.sig:=act^.sig;
    dispose(act);
    writeln('El valor se elimino de la lista');
  end;
end;
procedure mostrar(L:lista);
begin
  while(L<>nil)do begin
    writeln(L^.dato.codigo,' ',L^.dato.apellido,' ',L^.dato.codPol,' ',L^.dato.monto);
    L:=L^.sig;
  end;
end;
var
  L:lista;
begin
  L:=nil;
  cargar(L);
  mostrar(L);  //para probar si se cargo
  recorrer(L);
  eliminar(L);
  mostrar(L);  //para probar si se borro
end.
{
3. Una remisería dispone de información acerca de los viajes realizados durante el mes de mayo de
2020. De cada viaje se conoce: número de viaje, código de auto, dirección de origen, dirección de
destino y kilómetros recorridos durante el viaje. Esta información se encuentra ordenada por código
de auto y para un mismo código de auto pueden existir 1 o más viajes. Se pide:
a. Informar los dos códigos de auto que más kilómetros recorrieron.
b. Generar una lista nueva con los viajes de más de 5 kilómetros recorridos, ordenada por número
de viaje.
}
program remiseria;
type
  cadena=string[30];
  viaje=record
    numero:integer;
    codigo:integer;
    origen:cadena;
    destino:cadena;
    km:real;
  end;
  lista=^nodo;  //se dispone la lista de viaje
  nodo=record
    dato:viaje;
    sig:lista;
  end;

procedure leer(var v:viaje); //se dispone,para probar
begin
  writeln('Ingrese numero de viaje');
  readln(v.numero);
  writeln('Ingrese codigo de auto');
  readln(v.codigo);
  writeln('Ingrese la direccion de origen');
  readln(v.origen);
  writeln('Ingrese la direccion de destino');
  readln(v.destino);
  writeln('Ingrese el km recorrido');
  readln(v.km);
end;
procedure insertarOrdenado(var L:lista;v:viaje);
var ant,act,nue:lista;
begin
  new(nue);
  nue^.dato:=v;
  ant:=L;
  act:=L;
  while(act<>nil)and(act^.dato.numero<v.numero)do begin
    ant:=act;
    act:=act^.sig;
  end;
  if(ant=act)then L:=nue
    else ant^.sig:=nue;
  nue^.sig:=act;
end;
procedure cargarLista(var L:lista);  //se dispone,para probar
var v:viaje;
begin
  repeat
    leer(v);
    insertarOrdenado(L,v);
  until(v.numero=1122);
end;
procedure maximos(var max1,max2:real;var cod1,cod2:integer;km:real;codigo:integer);
begin
  if(km>max1)then begin
    max2:=max1;
    max1:=km;
    cod2:=cod1;
    cod1:=codigo;
  end
  else if(km>max2)then begin
         max2:=km;
         cod2:=codigo;
  end;
end;

procedure recorrer(L:lista;var nueva:lista);
var codActual,cod1,cod2:integer;
    kmTotal,max1,max2:real;
begin
  max1:=-1;cod1:=0;
  while(L<>nil)do begin
    kmTotal:=0;
    codActual:=L^.dato.codigo;
    while(L<>nil)and(codActual=L^.dato.codigo)do begin
      kmTotal:=kmTotal+L^.dato.km;
      if(L^.dato.km>5)then
        insertarOrdenado(nueva,L^.dato);
      L:=L^.sig;
    end;
    maximos(max1,max2,cod1,cod2,kmTotal,codActual);
  end;
  writeln('Los dos códigos de auto que más kilómetros recorrieron ',cod1,' y ',cod2);
end;
procedure mostrarNuevaLista(L:lista);
begin
  writeln('Lista nueva con los viajes de más de 5 kilómetros recorridos, ordenada por número de viaje.');
  while(L<>nil)do begin
    writeln(L^.dato.numero,' ',L^.dato.origen,' a ',L^.dato.destino,' km recorridos:',L^.dato.km:2:2);
    L:=L^.sig;
  end;
end;
var
  L:lista;
  nueva:lista;
begin
  L:=nil; //se dispone
  cargarLista(L);  //se dispone
  recorrer(L,nueva);
  mostrarNuevaLista(nueva);
end.
{
4. Una maternidad dispone información sobre sus pacientes. De cada una se conoce: nombre, apellido y
peso registrado el primer día de cada semana de embarazo (a lo sumo 42). La maternidad necesita un
programa que analice esta información, determine e informe:
a. Para cada embarazada, la semana con mayor aumento de peso.
b. El aumento de peso total de cada embarazada durante el embarazo.
}
program maternidad;
const
  sem=42;
type
  cadena=string[30];
  vector=array[1..sem]of real;
  paciente=record    //se dispone informacion sobre sus pacientes
    nombre:cadena;
    apellido:cadena;
    peso:vector;
    dimL:integer;
  end;
  lista=^nodo;
  nodo=record
    dato:paciente;
    sig:lista;
  end;
  
procedure LeerVector(var v:vector;dimL:integer); //se dispone
var i:integer;
begin
  writeln('Ingrese el peso');
  for i:=1 to dimL do begin
    writeln('Peso de la semana:',i,':');
    readln(v[i]);
  end;
end;
procedure leer(var p:paciente); //se dispone,para probar
begin
  writeln('Ingrese el nombre');
  readln(p.nombre);
  writeln('Ingrese el apellido');
  readln(p.apellido);
  writeln('Ingrese dias de semanas registrados');
  readln(p.dimL);
  LeerVector(p.peso,p.dimL);
end;
procedure agregarAdelante(var L:lista;p:paciente); //se dispone
var nue:lista;
begin
  new(nue);
  nue^.dato:=p;
  nue^.sig:=L;
  L:=nue;
end;
procedure cargarLista(var L:lista);  //se dispone
var p:paciente;
begin
  repeat
    leer(p);
    agregarAdelante(L,p);
  until(p.nombre='Fulano');
end;
procedure maximo(var max:real;var maxSem:integer;v:vector;dimL:integer;var pesoTotal:real);
var i:integer;
begin
  max:=-1;
  pesoTotal:=0;
  for i:=1 to dimL do begin
    if(v[i]>max)then begin
      max:=v[i];
      maxSem:=i;
    end;
    pesoTotal:=pesoTotal+v[i];
  end;
end;
procedure recorrer(L:lista);
var max,pesoTotal:real;
    maxSem:integer;
begin
  while(L<>nil)do begin
    maximo(max,maxSem,L^.dato.peso,L^.dato.dimL,pesoTotal);
    writeln('Paciente:',L^.dato.nombre,' ',L^.dato.apellido);
    writeln('Semana con mayor aumento de peso:',maxSem);
    writeln('Peso total:',pesoTotal:2:2);
    L:=L^.sig;
  end;
end;
var 
  L:lista;
begin
  L:=nil; //se dispone
  cargarLista(L);  //se dispone, se carga la lista y el vector de peso.
  recorrer(L);
end.
{
5. Una empresa de transporte de cargas dispone de la información de su flota compuesta por 100
camiones. De cada camión se tiene: patente, año de fabricación y capacidad (peso máximo en
toneladas que puede transportar).
Realizar un programa que lea y almacene la información de los viajes realizados por la empresa. De
cada viaje se lee: código de viaje, código del camión que lo realizó (1..100), distancia en kilómetros
recorrida, ciudad de destino, año en que se realizó el viaje y DNI del chofer. La lectura finaliza cuando
se lee el código de viaje -1.
Una vez leída y almacenada la información, se pide:
1. Informar la patente del camión que más kilómetros recorridos posee y la patente del camión que
menos kilómetros recorridos posee.
2. Informar la cantidad de viajes que se han realizado en camiones con capacidad mayor a 30,5
toneladas y que posean una antigüedad mayor a 5 años al momento de realizar el viaje (año en
que se realizó el viaje).
3. Informar los códigos de los viajes realizados por choferes cuyo DNI tenga sólo dígitos impares.
Nota: Los códigos de viaje no se repiten.
}
program Hello;
const dimF=3;    //100 camiones
type  rango=1..dimF;
      cadena20=string[20];
      camion=record 
        patente:cadena20;
        aniof:integer;
        capacidad:real;
      end;
      viaje=record 
        codviaje:integer;
        codcamion:rango;
        distancia:real;
        ciudad:cadena20;
        aniov:integer;
        dni:integer;
      end;
      vector=array[rango]of camion;
      lista=^nodo;
      nodo=record
        dato:viaje;
        sig:lista;
      end;
procedure leerCamion(var c:camion);
begin
 write('Ingrese patente del camion:');
 readln(c.patente);
 write('Ingrese anio de fabricacion:');
 readln(c.aniof);
 write('Ingrese capacidad');
 readln(c.capacidad);
end;
procedure cargarVcamion(var v:vector);
var i:integer;c:camion;
begin
  for i:=1 to dimF do begin
    leerCamion(c);
    v[i]:=c;
  end;
end;
procedue mostrarVectorCamion(v:vector);
var i:integer;
begin
  for i:=1 to dimF do begin
    writeln('Camion numero:',i,':');
    writeln('Patente:',v[i].patente);
    writeln('Anio de fabricacion:',v[i].aniof);
    writeln('Capacidad:',v[i].Capacidad);
  end;
end;
procedure leerViaje(var v:viaje);
begin
  write('Ingrese codigo de vije:');
  readln(v.codviaje);
  if(v.codviaje<>-1)then begin
    write('Ingrese codigo de camion:');
    readln(v.codcamion);
    write('Ingrese distancia recorrida:');
    readln(v.distancia);
    write('Ingrese ciudad de destino:');
    readln(v.ciudad);
    write('Ingrese el anio en que se realizo el viaje:');
    readln(v.aniov);
    write('Ingrese el dni del chofer:');
    readln(v.dni);
  end;
end;
procedure agregarAdelante(var L:lista;v:viaje);
var nue:lista;
begin
  new(nue);
  nue^.dato:=v;
  nue^.sig:=L;
  L:=nue;
end;
procedure crearLista(var L:lista);
var v:viaje;
begin 
  leerViaje(v);
  while(v.codviaje<>-1)do begin
    agregarAdelante(L,v);
    leerViaje(v);
  end;
end;
procedure maximo(var max,min:real,var patmax,patmin:cadena20;v:vector;km:real;codcamion:integer);
begin
  if(km>max)then begin
    max:=km;
    patmax:=v[codcamion].patente;
  end;
  if(km<min)then begin
    min:=km;
    patmin:=v[codcamion].patente;
  end;
end;
function cumpleInciso2(v:vector;cod,aniov:integer):boolean;
var  antiguedad:integer;
begin
  antiguedad:=aniov-v[cod].aniof;
  if(v[cod].capacidad>30.5)and(antiguedad>5)then
    cumpleInciso2:=true
  else
    cumpleInciso2:=false;
end;
function cumpleInciso3(dni:integer):boolean;
var resto:integer;
begin
  while(dni<>0)do begin
    resto:=dni mod 10;
    if(resto mod 2<>0)then
      dni:=dni div 10;
    else
      cumpleInciso3:=false;
  end;
  cumpleInciso3:=true;
end;
procedure informar(patmax,patmin:cadena20;cantv:integer);
begin
  writeln('Patente del camion que mas km recorridos tiene:',patmax);
  writeln('Patente del camion que menos km recorridos tiene:',patmin);
  writeln('Cantidad de viajes realizado con camiones con capacidad mayor a 30.5 toneladas con antiguedad mayor a 5 anios',cantv);
end;
procedure recorrerLista(L:lista,v:vector);
var max,min:real;patmin,patmax:cadena20;cantv:integer;
begin
  max:=-1;
  min:=999;
  cantv:=0;
  while(L<>nil)do begin
    maximo(max,min,patmax,patmin,v,L^.dato.distancia,L^.dato.codcamion);
    if(cumpleInciso2(v,L^.dat.codcamion,L^.dato.aniov))then
      cantv:=cantv+1;
      if(cumpleInciso3(L^.dato.dni))then
        writeln('Codigo de viaje realizado por chofer con digitos impares:',L^.dato.codviaje);
    L:=L^.sig;
  end;
  informar(patmax,patmin,cantv);
end;
var  L:lista;
     v:vector;
begin
   L:=nil;
   cargarVcamion(v);//se dispone
   mostrarVectorCamion(v);
   crearLista(L);
   recorrerLista(L,v);
end.
{
6. El Observatorio Astronómico de La Plata ha realizado un relevamiento sobre los distintos objetos
astronómicos observados durante el año 2015. Los objetos se clasifican en 7 categorías: 1: estrellas,
2: planetas, 3: satélites, 4: galaxias, 5: asteroides, 6: cometas y 7: nebulosas.
Al observar un objeto, se registran los siguientes datos: código del objeto, categoría del objeto (1..7),
nombre del objeto, distancia a la Tierra (medida en años luz), nombre del descubridor y año de su
descubrimiento.
A. Desarrolle un programa que lea y almacene la información de los objetos que han sido
observados. Dicha información se lee hasta encontrar un objeto con código -1 (el cual no
debe procesarse). La estructura generada debe mantener el orden en que fueron leídos los
datos.
B. Una vez leídos y almacenados todos los datos, se pide realizar un reporte con la siguiente
información:
1. Los códigos de los dos objetos más lejanos de la tierra que se hayan observado.
2. La cantidad de planetas descubiertos por "Galileo Galilei" antes del año 1600.
3. La cantidad de objetos observados por cada categoría.
4. Los nombres de las estrellas cuyos códigos de objeto poseen más dígitos pares que
impares.
}
program Hello;
const tam=7;
type  rango=1..tam;
      cadena20=string[20];
      objeto=record
        cod:integer;
        categoria:rango;
        nomObjeto:cadena20;
        distancia:real;
        nomDescubridor:cadena20;
        anio:integer;
      end;
      vector=array[rango]of integer;
      lista=^nodo;
      nodo=record
        dato:objeto;
        sig:lista;
      end;
procedure inicializar(var v:vector);
var i:integer;
begin
  for i:=1 to tam do 
    v[i]:=0;
end;
procedure leerObjeto(var o:objeto);
begin
  write('Ingrese el codigo:');
  readln(o.cod);
  if(o.cod<>-1)then begin
    write('Ingrese la categoria:');
    readln(o.categoria);
    write('Ingrese el nombre del objeto:');
    readln(o.nomObjeto);  
    write('Ingrese la distancia:');
    readln(o.distancia);
    write('Ingrese el nombre del descubridor:');
    readln(o.nomDescubridor);
    write('Ingrese el anio :');
    readln(o.anio);
  end;
end;
procedure agregarAtras(var L:lista;o:objeto;var ult:lista);
var nue:lista;
begin
  new(nue);
  nue^.dato:=o;
  nue^.sig:=nil;
  if(L<>nil)then  L:=nue;
            else  ult^.sig:=nue;
  ult:=nue;
end;
procedure crearLista(var L:lista);
var o:objeto;ult:lista;
begin
  leerObjeto(o);
  while(o.cod<>-1)do begin
    agregarAtras(L,o,ult);
    leerObjeto(o);
  end;
end;
procedure mostrarListaCargada(L:lista);
begin
  while(L<>nil)do begin
    writeln('Codigo de objeto:',L^.dato.cod);
    writeln('Categoria del objeto:',L^.dato.categoria);
    writeln('Nombre del objeto:',L^.dato.nomObjeto);
    writeln('Nombre del descubridor:',L^.dato.nomDescubridor);
    writeln('Distancia a la tierra:',L^.dato.distancia);
    writeln('Anio de descubrimiento:',L^.dato.anio);
    L:=L^.sig;
  end;
end;
procedure maximos(var max1,max2:real;var codmax1,codmax2:integer;dist:real;cod:integer);
begin
  if(dist>max1)then begin
    max2:=max1;
    max1:=dist;
    codmax2:=codmax1;
    codmax1:=cod;
  end
  else if(dist>max2)then begin
         max2:=dist;
         codmax2:=cod;
  end;
end;
function cumpleInciso2(nom:cadena20;anio:integer;categ:integer):boolean;
begin
  if(nom='Galileo Galilei')and(anio<1600)and(categ=2)then
    cumpleInciso2:=true;
  else
    cumpleInciso2:=false;
end;
procedure informoInciso3(v:vector);
var i:integer;
begin
  for i:=1 to tam do 
    writeln('La cantidad de objetos observados en categoria ',i,' es de ',v[i]);
end;
function cumpleInciso4(codigo:integer):boolean;
var resto,cantp,canti:integer;
begin
  while(codigo<>0)do begin
    resto:=codigo mod 10;
    if(resto mod 2=0)then
      cantp:=cantp+1;
    else
      canti:=canti+1;
    codigo:=codigo div 10;
  end;
  if(cantp>canti)then 
    cumpleInciso4:=true;
  else
    cumpleInciso4:=false;
end;
procedure informo(codmax1,codmax2,cantGalileo:integer;v:vector);
begin
  writeln('Codigo de los dos objetos mas lejano a la tierra:',codmax1,codmax2);
  writeln('La cantidad de planetas descubiertos por "Galileo Galilei" antes del año 1600',cantGalileo);
  informoInciso3(v);
end;
procedure recorrerLista(L:lista;v:vector);
var max1,max2:real;codmax1,codmax2,cantGalileo:integer;
begin
  cantGalileo:=0;
  while(L<>nil)do begin
    maximos(max1,max2,codmax1,codmax2,L^.dato.distancia,L^.dato.cod);
    if(cumpleInciso2(L^.dato.nomDescubridor,L^.dato.anio,L^.dato.categoria))then
      cantGalileo:=cantGalileo+1;
    v[L^.dato.categoria]:=v[L^.dato.categoria]+1;
    if(L^.dato.categoria=1)and(cumpleInciso4(L^.dato.cod))then
      writeln('Los nombres de las estrellas cuyos códigos de objeto poseen más dígitos pares que
impares.',L^.dato.nomObjeto);
    L:=L^.sig;
  end;
  informo(codmax1,codmax2,cantGalileo,v);
end;
var  L:lista;
     v:vector;
begin
  L:=nil;
  inicializar(v);
  crearLista(L);
  mostrarListaCargada(L);
  recorrerLista(L,v);
end.
{
7. La Facultad de Informática desea procesar la información de los alumnos que finalizaron la carrera de
Analista Programador Universitario. Para ello se deberá leer la información de cada alumno, a saber:
número de alumno, apellido, nombres, dirección de correo electrónico, año de ingreso, año de egreso
y las notas obtenidas en cada una de las 24 materias que aprobó (los aplazos no se registran).
1. Realizar un módulo que lea y almacene la información de los alumnos hasta que se ingrese el
alumno con número de alumno -1, el cual no debe procesarse. Las 24 notas correspondientes a
cada alumno deben quedar ordenadas de forma descendente.
2. Una vez leída y almacenada la información del inciso 1, se solicita calcular e informar:
a. El promedio de notas obtenido por cada alumno.
b. La cantidad de alumnos ingresantes 2012 cuyo número de alumno está compuesto
únicamente por dígitos impares.
c. El apellido, nombres y dirección de correo electrónico de los dos alumnos que más rápido
se recibieron (o sea, que tardaron menos años)
3. Realizar un módulo que, dado un número de alumno leído desde teclado, lo busque y elimine de
la estructura generada en el inciso 1. El alumno puede no existir.
}
program Hello;
const  dimF=24;
type   rango=1..dimF;
       cadena30=string[30];
       vector=array[rango]of real;
       alumno=record
         numero:integer;
         apnom:cadena30;
         mail:cadena30;
         anioIngreso:integer;
         anioEgreso:integer;
         notas:vector;
       end;
       lista=^nodo;
       nodo=record
         dato:alumno;
         sig:lista;
       end;
procedure cargarVector(var v:vector);
var i:integer;nota:real;
begin
  for i:=1 to dimF do begin
    writeln('Ingrese la nota de la materia:',i,':');
    readln(nota);
    v[i]:=nota;
  end;
end;
procedure ordenarVector(var v:vector);
var i,j,p:integer;item:real;
begin
  for i:=1 to dimF-1 do begin
    p:=i;
    for j:=i+1 to dimF do
      if(v[j]>v[p])then
        p:=j;
    item:=v[p];
    v[p]:=v[i];
    v[i]:=item;
  end;
end;
procedure leerAlumno(var a:alumno);
begin
  write('Ingrese el numero de alumno:');
  readln(a.numero);
  if(a.numero<>-1)then begin
    write('Ingrese el apellido y nombre de alumno:');
    readln(a.apnom);
    write('Ingrese el mail de alumno:');
    readln(a.mail);
    write('Ingrese el anio de ingreso:');
    readln(a.anioIngreso);
    write('Ingrese el anio de egreso:');
    readln(a.anioEgreso);
    write('Ingrese la nota de alumno:');
    cargarVector(a.notas);
    ordenarVector(a.notas);
  end;
end;
procedure agregarAdelante(var L:lista;a:alumno);
var nue:lista;
begin
  new(nue);
  nue^.dato:=a;
  nue^.sig:=L;
  L:=nue;
end;
procedure cargarLista(var L:lista);
var a:alumno;
begin
  leerAlumno(a);
  while(a.numero<>-1)do begin
    agregarAdelante(L,a);
    leerAlumno(a);
  end;
end;
procedure mostrarVectorCargado(v:vector);
var i: integer;
begin
  for i:=1 to dimF do
    writeln('Nota numero:',i,':',v[i]:2:2);
end;
procedure mostrarListaCargada(L:lista);
begin
  while(L<>nil)do begin
    writeln('Numero de alumno:',L^.dato.numero);
    writeln('Apellido y nombre de alumno:',L^.dato.apnom);
    writeln('Mail de alumno:',L^.dato.mail);
    writeln('Anio de ingreso:',L^.dato.anioIngreso);
    writeln('Anio de egreso:',L^.dato.anioEgreso);
    writeln('Notas:');
    mostrarVectorCargado(L^.dato.notas);
    L:=L^.sig;
  end;
end;
procedure incisoA(v:vector;apnom:cadena30);
var i:integer;suma,promedio:real;
begin
  suma:=0;
  for i:=1 to dimF do 
    suma:=suma+v[i];
  promedio:=suma/dimF;
  writeln('Alumno:',apnom);
  writeln('Promedio de notas:',promedio);
end;
function incisoB(num:integer):boolean;
var resto:integer;
begin
  while(num<>0 )do begin
    resto:=num mod 10;
    if(resto mod 2<>0 )then
      num:=num div 10
    else 
      incisoB:=false;
    end;
      incisoB:=true;
end;
procedure incisoC(L:lista;var min1,min2:integer;var apnom1,apnom2,mail1,mail2:cadena30);
var resta:integer;
begin
  resta:=L^.dato.anioEgreso-L^.dato.anioIngreso;
  if(resta<min1)then begin 
    min2:=min1;
    min1:=resta;
    apnom2:=apnom1;
    apnom1:=L^.dato.apnom;
    mail2:=mail1;
    mail1:=L^.dato.mail;
  end
  else if(resta<min2)then begin
         min2:=resta;
         apnom2:=L^.dato.apnom;
         mail2:=L^.dato.mail;
  end;
end;
procedure informo(cant:integer;apnom1,mail1,apnom2,mail2:cadena30);
begin
  writeln('Cantidad de alumnos cuyo numero de alumno tiene solo digitos impares:',cant);
  writeln('Datos del primer alumno que menos tardo en recibirse:',apnom1,mail1);
  writeln('Datos del segundo alumno que menos tardo en recibirse:',apnom2,mail2);
end;
procedure recorrerLista(L:lista);
var  cant,min1,min2:integer;apnom1,apnom2,mail1,mail2:cadena30;
begin
  cant:=0;
  min1:=999;min2:=999;
  apnom1:='';apnom2:='';mail1:='';mail2:='';
  while(L<>nil)do begin
    incisoA(L^.dato.notas,L^.dato.apnom);
    if(L^.dato.anioIngreso=2012)and(incisoB(L^.dato.numero))then
      cant:=cant+1;
    incisoC(L,min1,min2,apnom1,apnom2,mail1,mail2);
    L:=L^.sig;
  end;
  informo(cant,apnom1,mail1,apnom2,mail2);
end;
procedure eliminarNumero(var L:lista;numero:integer);
var ant,act:lista;ok:boolean;
begin
  ant:=L;
  act:=L;
  ok:=false;
  while(act<>nil)and(not ok)do begin
    if(act^.dato.numero=numero)then
      ok:=true
    else begin
      ant:=act;
      act:=act^.sig;
    end;
  end;
  if(ok=true)then begin
    if(ant=act)then  L:=act^.sig
               else  ant^.sig:=act^.sig;
    dispose(act);
    writeln('El alumno se elimino correctamente.');
  end
  else
    writeln('No se encotro el alumno.');
end;
var  L:lista;
     numElimino:integer;
begin
  L:=nil;
  cargarLista(L);
  mostrarListaCargada(L);
  recorrerLista(L);
  writeln('Ingrese el numero de alumno a eliminar:');
  readln(numElimino);
  eliminarNumero(L,numElimino);
  mostrarListaCargada(L);  //para corroborar si se elimino el numero.
end.
{
8. Una entidad bancaria de la ciudad de La Plata solicita realizar un programa destinado a la
administración de transferencias de dinero entre cuentas bancarias, efectuadas entre los meses de
Enero y Noviembre del año 2018.
El banco dispone de una lista de transferencias realizadas entre Enero y Noviembre del 2018. De cada
transferencia se conoce: número de cuenta origen, DNI de titular de cuenta origen, número de cuenta
destino, DNI de titular de cuenta destino, fecha, hora, monto y el código del motivo de la
transferencia (1: alquiler, 2: expensas, 3: facturas, 4: préstamo, 5: seguro, 6: honorarios y 7: varios).
Esta estructura no posee orden alguno.
Se pide:
a) Generar una nueva estructura que contenga sólo las transferencias a terceros (son aquellas en las
que las cuentas origen y destino no pertenecen al mismo titular). Esta nueva estructura debe
estar ordenada por número de cuenta origen.
Una vez generada la estructura del inciso a), utilizar dicha estructura para:
b) Calcular e informar para cada cuenta de origen el monto total transferido a terceros.
c) Calcular e informar cuál es el código de motivo que más transferencias a terceros tuvo.
d) Calcular e informar la cantidad de transferencias a terceros realizadas en el mes de Junio en las
cuales el número de cuenta destino posea menos dígitos pares que impares.
}
program Hello;
const tam=7;
type  rango=1..tam;
      fecha=record
        dia:1..31;
        mes:1..12;
        anio:integer;
      end;
      hora=record
        horas:1..24;
        min:0..59;
      end;
      transferencia=record
        numOrigen:integer;
        dniOrigen:integer;
        numDestino:integer;
        dniDestino:integer;
        f:fecha;
        h:hora;
        monto:real;
        cod:rango;
      end;
      vector=array[rango]of integer;
      lista=^nodo;
      nodo=record
        dato:transferencia;
        sig:lista;
      end;
procedure inicializar(var v:vector);
var i:integer;
begin
  for i:=1 to tam do 
    v[i]:=0;
end;
function cumple(dniOrigen,dniDestino:integer):boolean;
begin
  cumple:=(dniOrigen<>dniDestino);
end;
procedure insertarOrdenado(var L2:lista;trans:transferencia);
var  nue,act,ant:lista;
begin
  new(nue);
  nue^.dato:=trans;
  nue^.sig:=nil;
  if(L2=nil)then  L2:=nue
            else begin  
                  act:=L2;
                  ant:=L2;
    while(act<>nil)and(act^.dato.numOrigen<nue^.dato.numOrigen)do begin
      ant:=act;
      act:=act^.sig;
    end;
    if(ant=act)then begin
      nue^.sig:=L2;
      L2:=nue;
    end
    else if(act<>nil)then begin
           ant^.sig:=nue;
           nue^.sig:=act;
         end
         else begin
           ant^.sig:=nue;
           nue^.sig:=nil;
         end;
    end;
end;
procedure leerTransferencia(var t:transferencia);  //se dispone
begin
  write('Ingrese numero cuenta origen:');
  readln(t.numOrigen);
  if(t.numOrigen<>-1)then begin
    write('DNI de titular de cuenta origen:');
    readln(t.dniOrigen);
    write('Ingrese numero cuenta destino:');
    readln(t.numDestino);
    write('DNI de titular de cuenta destino:');
    readln(t.dniDestino);
    write('Ingrese el dia:');
    readln(t.f.dia);
    write('Ingrese el mes:');
    readln(t.f.mes);
    write('Ingrese el anio:');
    readln(t.f.anio);
    write('Ingrese la hora:');
    readln(t.h.horas);
    write('Ingrese el minuto:');
    readln(t.h.min);
    write('Ingrese el monto:');
    readln(t.monto);
    write('Ingrese código del motivo de la transferencia:');
    readln(t.cod);
  end;
end;
procedure insertarPrincipio(var L:lista;t:transferencia);
var nue:lista;
begin
  new(nue);
  nue^.dato:=t;
  nue^.sig:=nil;
  if(L=nil)then  L:=nue;
           else  nue^.sig:=L;
  L:=nue;
  end;
end;
procedure cargarLista(var L:lista);
var t:transferencia;
begin
  leerTransferencia(t);
  while(t.numOrigen<>-1)do begin
    insertarPrincipio(L,t);
    leerTransferencia(t);
  end;
end;
procedure recorrerLista(L:lista;var L2:lista);
begin
  while(L<>nil)do begin
    if(cumple(L^.dato.dniOrigen,L^.dato.dniDestino))then
      insertarOrdenado(L2,L^.dato);
      L:=L^.sig
  end;
end;
procedure calcularMaximo(v:vector;var codmax:integer);
var i,max:integer;
begin
  max:=-1;
  for i:=1 to tam do begin
    if(v[i]>max)then begin
      max:=v[i];
      codmax:=i;
    end;
  end;
end;
function cumpleMenosPares(numero:integer):boolean;
var resto,cantp,canti:integer;
begin
  cantp:=0;canti:=0;
  while(numero<>0)do begin
    resto:=numero mod 10;
    if(resto mod 2=0)then
      cantp:=cantp+1
    else
      canti:=canti+1;
    numero:=numero div 10;
  end;
  if(canti>cantp)then
     cumpleMenosPares:=true
  else
     cumpleMenosPares:=false;
end;
procedure recorrerLista2(L2:lista;v:vector);
var codmax,cant,aux:integer;suma:real;
begin
  cant:=0;
  while(L2<>nil)do begin
    aux:=L2^.dato.numOrigen;
    suma:=0;
    while(L2<>nil)and(aux=L2^.dato.numOrigen)do
      suma:=suma+L2^.dato.monto;
    v[L2^.dato.cod]:=v[L2^.dato.cod]+1;
    if(L2^.dato.mes=6)and(cumpleMenosPares(L2^.dato.numDestino))then
      cant:=cant+1;
    L2:=L2^.sig;
    writeln('Monto total:',suma:2:2);
  end;
  calcularMaximo(v,codmax);
  writeln('Código de motivo que más transferencias a terceros tuvo:',codmax);
  writeln('la cantidad de transferencias a terceros realizadas en el mes de Junio en las
cuales el número de cuenta destino posea menos dígitos pares que impares:',cant);
end;
var  L:lista;
     L2:lista;
     v:vector;
begin
  L:=nil;
  L2:=nil;
  inicializar(v);
  cargarLista(L);  //se dispone
  recorrerLista(L,L2);
  recorrerLista2(L2,v);
end.
{ 
9. Un cine posee la lista de películas que proyectará durante el mes de Febrero. De cada película se
tiene: código de película, título de la película, código de género (1: acción, 2: aventura, 3: drama, 4:
suspenso, 5: comedia, 6: bélica, 7: documental y 8: terror) y puntaje promedio otorgado por las
críticas. Dicha estructura no posee orden alguno.
Se pide:
a) Actualizar (en la lista que se dispone) el puntaje promedio otorgado por las críticas. Para ello se
debe leer desde teclado las críticas que han realizado críticos de cine, de cada crítica se lee: DNI
del crítico, apellido y nombre del crítico, código de película y el puntaje otorgado. La lectura
finaliza cuando se lee el código de película -1 y la información viene ordenada por código de
película.
b) Informar el código de género que más puntaje obtuvo entre todas las críticas.
c) Informar el apellido y nombre de aquellos críticos que posean la misma cantidad de dígitos pares
que impares en su DNI.
d) Realizar un módulo que elimine de la lista que se dispone una película cuyo código se recibe
como parámetro (el mismo puede no existir).
}
program Hello;
const  dimF=8;
type   rango=1..dimF;
       cadena50=string[50];
       pelicula=record
         codigo:integer;
         nombre:cadena50;
         codGenero:rango;
         puntaje:real;
       end;
       lista=^nodo;
       nodo=record
         dato:pelicula;
         sig:lista;
       end;
       critico=record
         dni:integer;
         nomape:cadena50;
         cod:integer;
         punto:real;
       end;
       vector=array[rango]of real;
procedure inicializar(var v:vector);
var i:integer;
begin
  for i:=1 to dimF do
    v[i]:=-1;
end;
procedure leerCritico(var c:critico);
begin
  write('Ingrese el codigo:');
  readln(c.cod);
  if(c.cod<>-1)then begin
    write('Ingrese el DNI:');
    readln(c.cod);
    write('Ingrese nombre y apellido:');
    readln(c.cod);
    write('Ingrese el puntaje:');
    readln(c.cod);
  end;
end;
procedure leerPelicula(var p:pelicula);
begin
  write('Ingrese el codigo:');
  readln(p.codigo);
  if(p.codigo<>-1)then begin
    write('Ingrese el nombre:');
    readln(p.nombre);
    write('Ingrese el codigo de genero:');
    readln(p.codGenero);
    write('Ingrese el punteje:');
    readln(p.puntaje);
  end;
end;
procedure insertarPrincipio(var L:lista;p:pelicula);
var nue:lista;
begin
  new(nue);
  nue^.dato:=p;
  nue^.sig:=nil;
  if(L=nil)then 
    L:=nue
  else 
    nue^.sig:=L;
  L:=nue;
end;
procedure cargarLista(var L:lista);
var p:pelicula;
begin
  leerPelicula(p);
  while(p.codigo<>-1)do begin
    insertarPrincipio(L,p);
    leerPelicula(p);
  end;
end;
function parImpar(dni:integer):boolean;
var par,impar,dig:integer;
begin
  par:=0;impar:=0;
  while(dni<>0)do begin
    dig:=dni mod 10;
    if(dig mod 2=0)then
      par:=par+1
    else
      impar:=impar+1;
    dni:=dni div 10;
  end;
  parImpar:=(par=impar);
end;
procedure masPuntaje(v:vector);
var i,cod:integer;max:real;
begin
  max:=-1;
  for i:=1 to dimF do  
    if(v[i]>max)then begin
      cod:=i;
      max:=v[i];
    end;
    writeln(cod,' tuvo el mayor puntaje:',max:2:2);
end;
procedure actualizar(var v:vector;L:lista);
var c:critico;Actual,cant:integer;promedio,suma:real;
begin
  leerCritico(c);
  suma:=0;cant:=0;
  while(c.cod<>-1)do begin
    Actual:=c.cod;
    while(c.cod<>-1)and(Actual=c.cod)do begin
      if(parImpar(c.dni))then
        writeln('Nombre y apellido de aquellos críticos con cantidad de dígitos pares que impares en su DNI:',c.nomape);
      suma:=suma+c.punto;
      cant:=cant+1;
      leerCritico(c);
    end;
    promedio:=suma/cant;
    while(L<>nil)do begin
      if(L^.dato.codigo=c.cod)then
        L^.dato.puntaje:=promedio;
      if(v[L^.dato.codigo]<L^.dato.puntaje)then
        v[L^.dato.codigo]:=L^.dato.puntaje;
      L:=L^.sig;
    end;
  end;
end;
procedure Eliminar(var L:lista;numero:integer);
var act,ant:lista;ok:boolean;
begin
  act:=L;ant:=L;ok:=false;
  while(act<>nil)and(not ok)do 
    if(act^.dato.codigo=numero)then
      ok:=true
    else begin
      ant:=act;
      act:=act^.sig;
    end;
    if(ok=true)then begin
      if(act=L)then
        L:=act^.sig
      else
        ant^.sig:=act^.sig;
      dispose(act);
  end;
end;
var L:lista;
    v:vector;
    cod:integer;
begin
  L:=nil;
  inicializar(v);
  cargarLista(L);
  actualizar(v,L);
  masPuntaje(v);
  write('Ingrese el codigo a borrar:');
  readln(cod);
  Eliminar(L,cod);
end.

