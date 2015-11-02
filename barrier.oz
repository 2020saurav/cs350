functor
import
    Browser
define
  % Soultion taken from class notes
  proc {Barrier Procs}
     fun {BarrierLoop Procs L}
        case Procs
          of  Proc|Procr then
              M
          in
              thread {Proc} M=L end
              {BarrierLoop Procr M}
          [] nil then L
        end
     end

     S = {BarrierLoop Procs unit}
  in
     {Wait S}
  end

  %------------- Example Usage-------------------
  X = proc {$} {Browser.browse hi} end
  Y = proc {$} {Browser.browse hello} end
  Z = proc {$} {Browser.browse bye} end
  {Barrier [X Y Z]}
  {Browser.browse late}
end
