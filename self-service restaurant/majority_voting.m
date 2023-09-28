clear;
function OUT = Majority_voting(IN, w_dia)
   OUT =zeros(size(IN));
   for x=1:w_dia:size(IN,1)
       for y=1:w_dia:size(IN,2)
           start_x=x;
           start_y=y;
           end_x=min(x+w_dia-1,size(IN,1));
           end_y=min(y+dia-1,size(IN,1));
           selected_window =IN(start_x:end_x,start_y:end_y);
           majority_value =mode(selected_window,'all');
           OUT(start_x:end_x,start_y:end_y) = majority_value;
       end
   end

        

end
