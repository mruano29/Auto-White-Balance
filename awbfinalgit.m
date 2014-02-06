function[salida] = awb(I,Z)
%Function to calculate auto white balance, based on the medium energy of each channel.
%. It works with the discrete cosine transform; 
%We load two images, I is which we use to work, and Z is used to calculate the measure error.

%extraction of color layers
MR=I(:,:,1);
MG=I(:,:,2);
MB=I(:,:,3);

%dct2 for each component
DCTMR=dct2(MR);
DCTMG=dct2(MG);
DCTMB=dct2(MB);

%Medium energy level for channel
r=DCTMR(1,1);
g=DCTMG(1,1);
b=DCTMB(1,1);

%energy relaition between channels
sum=r+g+b;
r=r/sum;
g=g/sum;
b=b/sum;

%Channel gain
if (r>g && r<b) || (r<g && r>b)
   gr=1;
   gg=r/g;
   gb=r/b;
   
elseif (g>r && g<b) || (g<r && g>b)
   gg=1;
   gr=g/r;
   gb=g/b;
   
elseif (b>r && b<g) || (b<r && b>g)
   gb=1;
   gr=b/r;
   gg=b/g;
   
end

%each gain multiplied by each channel
salida(:,:,1)=gr*I(:,:,1);
salida(:,:,2)=gg*I(:,:,2);
salida(:,:,3)=gb*I(:,:,3);

%Error image
diferencia=abs(double(Z)-double(salida));%utilizamos double para poder 


%balance result
figure(1);
subplot(2,2,1);
imshow(Z);
title('imagen original');
subplot(2,2,2);
imshow(I);
title('imagen con error');
subplot(2,2,3);
imshow(salida);
title('imagen balanceada');
subplot(2,2,4);
imshow(uint8(diferencia));%we convert to 8 bits to represent
title('diferencia balanceada-original');

%figure with the difference by channels
figure(2);
subplot(1,3,1);
imshow(diferencia(:,:,1));
title('diferencia en rojo');
subplot(1,3,2);
imshow(diferencia(:,:,2));
title('diferencia en verde');
subplot(1,3,3);
imshow(diferencia(:,:,3));
title('diferencia en azul');

%histogram  for each channel before and after of balance
figure(3)
subplot(2,3,1)
imhist(MR)
title('Entrada Rojo')
subplot(2,3,2)
imhist(MG)
title('Entrada Verde')
subplot(2,3,3)
imhist(MB)
title('Entrada Azul')
subplot(2,3,4)
imhist(salida(:,:,1))
title('Salida Rojo')
subplot(2,3,5)
imhist(salida(:,:,2))
title('Salida Verde')
subplot(2,3,6)
imhist(salida(:,:,3))
title('Salida Azul')

figure(4)
imshow(salida);
end