functor
import
    Browser
define
    local P1 P2 P3 P4 X1 X2 X3 NSelect in
        proc {P1}
            {Browser.browse hi}
        end
        proc {P2}
            {Browser.browse hii}
        end
        proc {P3}
            {Browser.browse hiii}
        end
        proc {P4}
            {Browser.browse hiiii}
        end
        X1 = false
        X2 = false
        X3 = false
        proc {NSelect L}
            local Run Done RunAndBind NSelectAux in
                proc {RunAndBind S}
                    Done = true
                    {S}
                end
                proc {Run Case}
                    if {Value.isFree Done} then
                        case Case
                            of X#P then
                                if X == true then {RunAndBind P} else skip end
                            else skip
                        end
                    else skip end
                end
                proc {NSelectAux L}
                    case L
                    of Ls|Lr then
                        thread {Run Ls} end
                        {NSelectAux Lr}
                    else skip
                    end
                end
                {NSelectAux L}
            end
        end
        {NSelect [X1#P1 X2#P2 X3#P3 true#P4]}
    end
end
