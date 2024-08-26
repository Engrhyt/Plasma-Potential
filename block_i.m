function [test_index2]=block_i(test_index,in_index)
  if(test_index<1)
   test_index2=1;
  elseif(test_index>in_index)
   test_index2=in_index;
  else
   test_index2=test_index;
  endif
endfunction
