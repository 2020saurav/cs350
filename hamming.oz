functor
import Browser
define
    % Soultion taken from class notes
    fun lazy {Merge Xs Ys}
       case Xs#Ys
       of(X|Xr)#(Y|Yr) then
          if(X>Y) then Y|{Merge Xs Yr}
          elseif (X<Y) then X|{Merge Xr Ys}
          else  X|{Merge Xr Yr} end
       end
    end
    fun lazy {Scale N H}
       case H
       of X|T then (N*X)|{Scale N T} end
    end
   local Xs Ys Zs M N H in
        H = 1 | N
        thread Xs={Scale 2 H} end
        thread Ys={Scale 3 H} end
        thread Zs={Scale 5 H} end
        thread M={Merge Ys Zs} end
        thread N={Merge Xs M} end
        {Browser.browse H.1}
        {Browser.browse H.2.1}
        {Browser.browse H.2.2.1}
        {Browser.browse H.2.2.2.1}
        {Browser.browse H.2.2.2.2.1}
        {Browser.browse H.2.2.2.2.2.1}
        {Browser.browse H.2.2.2.2.2.2.1}
        {Browser.browse H.2.2.2.2.2.2.2.1}
        {Browser.browse H.2.2.2.2.2.2.2.2.1}
   end
end
