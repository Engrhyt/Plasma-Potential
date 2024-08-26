function [Vout,Iout,not_reject]=reject_anormally2(Vin,Iin,not_reject)
if(not_reject)
  bad_count=0;
  zero_count=0;
  point_accept=true;
  gg=0;
  Iout=zeros(8,1);
  Vout=zeros(8,1);
  Vin_long=length(Vin);
  for kk=1:Vin_long

    if(abs(imag(Iin(kk)))>abs(real(Iin(kk)))*100)
      not_reject=false;
      disp('error: complex anormally')
      kk
      bad_count
      break
    elseif(bad_count>50)
      not_reject=false;
      disp('error: bad point')
      bad_count
      break
    elseif(zero_count>floor(Vin_long/2))
      not_reject=false;
      disp('error: no data')
      zero_count
      break
    end

    point_accept=true;

    if(abs(Vin(kk))>10^150)
      point_accept=false;
      bad_count=bad_count+1;
    end

    if(abs(Iin(kk))>10^150)
      point_accept=false;
      bad_count=bad_count+1;
    end

    if(isinf(Vin(kk)))
      point_accept=false;
      bad_count=bad_count+1;
    end

    if(isinf(Iin(kk)))
      point_accept=false;
      bad_count=bad_count+1;
    end

    if(isnan(Vin(kk)))
      point_accept=false;
      bad_count=bad_count+1;
    end

    if(isnan(Iin(kk)))
      point_accept=false;
      bad_count=bad_count+1;
    end

    if(abs(Iin(kk))==0&&abs(Vin(kk))==0)
      point_accept=false;
      zero_count=zero_count+1;
    end

    if(point_accept)
      gg=gg+1;
      Iout(gg)=Iin(kk);
      Vout(gg)=Vin(kk);
    end

    end

else
  Iout=Iin;
  Vout=Vin;
end

end
