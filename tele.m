%% script desarrollado por el ing. Andres Felipe Pelaez.
%% Realiza la busqueda del numero del frame, la longitud del frame y el tiempo del mismo, dados los datos obtenidos
%% en wireshark.
clc;
clear all;
close all;
format long;
%% se obtienen los datos del archivo de texto generado en wireshark
fid=fopen('TramasAudioMP3.txt','r');%se abre el archivo para su lectura.
a=fscanf(fid,'%c');%se alamacena en una varible tipo caracter.
info=strfind(a,'Info');%se busca los indices donde se encuentra la palabra clave "Info".
rtp=strfind(a,'RTP');%se obtiene las posiciones donde se encuentran los caracteres "RTP".
aux=[];
for i=1:length(info)%%ciclo principal donde se lleva acabo todo el procesamiento
    aux=[];
    for l=7:20%%se busca el siguiente caracter diferente de espacio.
           if(a(info(i)+l) ~= ' ')
                break;
           end
    end
    for j=l:40
        if(a(info(i)+j) ~= ' ')
        aux=strcat(aux,a(info(i)+j));%se almacena concatenando caracater a caracter.
        else
            break;
        end
    end
    num(i)=str2double(aux);%se almacena el valor de cada numero de trama en una variable tipo doble.
    aux=[];
    for n=j+1:60
        if(a(info(i)+n) ~= ' ')
        aux=strcat(aux,a(info(i)+n));
        else
            break;
        end
    end
    timef(i)=str2double(aux);%se almacena en una variable tipo doble el valor del tiempo que tiene cada frame.
    aux=[];
    for l=4:20
           if(a(rtp(i)+l) ~= ' ')
                break;
           end
    end
    for j=l:40
        if(a(rtp(i)+j) ~= ' ')
        aux=strcat(aux,a(rtp(i)+j));
        else
            break;
        end
    end
    lent(i)=str2double(aux);%se almacena cada una de las longitudes de las tramas.
end
for i=1:length(rtp)-1
   timef(i)=timef(i+1)-timef(i);%se calcula el tiempo que dura en aparecer una nueva trama de audio.
end
%% En la segunda parte del código se realiza la escritura del fichero en donde se almacenaran los datos.
file_audio=fopen('audio_frame.txt','w');
fprintf(file_audio,'N° trama\tlongitud\ttiempo\n');
for i=1:length(rtp)
   fprintf(file_audio,'%i\t\t%i\t\t%f\n',num(i),lent(i),timef(i)); 
end
