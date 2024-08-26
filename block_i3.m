function [test_index2]=block_i3(test_index,min_i,max_i)
  if(test_index<min_i)
   test_index2=min_i;
  elseif(test_index>max_i)
   test_index2=max_i;
  else
   test_index2=test_index;
  endif
endfunction
