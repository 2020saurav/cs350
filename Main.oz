functor
import
    Browser(browse: Browse)
define
    % Stack < Statement, Environment > Pair of stmt and env
    \insert 'SemanticStack.oz'

    Current = {NewCell nil}
    
    proc {Interpret AST}
        {Push sepair(stmt:AST env:nil)}
        local Recurse in
            proc {Recurse}
                {Browse @SemanticStack}
                Current := {Pop}
                if @Current \= nil then
                    case @Current.stmt
                    of nil then {Browse 'Complete'}
                    % 'nop' : skip. Do nothing
                    [] [nop] then {Recurse}

                    % TODO add other statements here and handle them

                    % S -> S1 S2. Push S2 first. Then S1
                    [] X|Xr then
                        if Xr \= nil then
                            {Push sepair(stmt:Xr env:@Current.env)}
                        else skip end
                        {Push sepair(stmt:X env:@Current.env)}
                        {Recurse}
                    end                    
                else
                    {Browse 'Complete'}
                end                
            end
            {Recurse}
        end
    end
    {Interpret [[nop] [nop] [nop]]}
end
