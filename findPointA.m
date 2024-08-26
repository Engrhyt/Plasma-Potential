function [point_out d]=findPointA(p,in,b,c)
iii=1;
point_out=0;
no_such_loop=true;

if(floor(length(in)*b(1))<=0)
a=1;
else
a=floor(length(in)*b(1));
end

if(ceil(length(in)*b(2))>=length(in))
g=length(in);
else
g=ceil(length(in)*b(2));
end

while(no_such_loop)
 for i=a:g
    if (in(i)<=p+c*iii&&in(i)>=p-c*iii)
      no_such_loop=false;
      point_out=i;
      break
    end
 end
iii=iii+1;
end
d=c*iii*2;
end
