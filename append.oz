functor
import Browser
define
  fun lazy {LAppend Xs Ys}
     case Xs
      of X|Xr then
        X|{LAppend Xr Ys}
     [] nil then Ys
     end
  end
  L = {LAppend [1 2 3] [4 5 6]}
  {Browser.browse L.2.2.2.1}
end
