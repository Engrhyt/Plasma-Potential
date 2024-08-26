function [out]=block_i(in)
 out=zeros(length(in),1);
 for i=1:length(in)
  if(in(i)<=0)
   out(i)=1e-7;
  else
   out(i)=in(i);
  endif
 endfor
endfunction
