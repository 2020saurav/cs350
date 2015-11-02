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
  fun lazy {LFilter Xs F Pivot}
   case Xs
   of nil then nil
   [] X|Xr then
   if {F X Pivot} then X|{LFilter Xr F Pivot} else {LFilter Xr F Pivot} end
   end
  end
  fun {IsSmaller X Pivot}
     if X=<Pivot then true else false end
  end
  fun {IsGreater X Pivot}
     if X>Pivot then true else false end
  end
  fun  lazy {QuickSort Xs}
     case Xs
     of nil then nil
     [] Pivot|Xr then
            {LAppend {QuickSort {LFilter Xr IsSmaller Pivot}} Pivot|{QuickSort  {LFilter Xr IsGreater Pivot}}}
     end
  end
  L = {QuickSort [1 5 2 6 3]}
  {Browser.browse L.2.2.1}
end
