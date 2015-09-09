functor
import
    Browser(browse: Browse)
define
    % Stack < Statement, Environment > Pair of stmt and env
    \insert 'SemanticStack.oz'
    \insert 'SingleAssignmentStore.oz'
    Current = {NewCell nil}
    fun {DeclareIdent X Env}
        {Adjoin Env env(X:{AddKeyToSAS})}
    end

    proc {Interpret AST}
        {Push sepair(stmt:AST env:nil)}
        local Execute in
            proc {Execute}
                Current := {Pop}
                {Browse @Current}
                if @Current \= nil then
                    case @Current.stmt
                    of nil then {Browse 'Complete'}
                    % 'nop' : skip. Do nothing
                    [] [nop] then {Execute}
                    [] [localvar ident(X) S] then
                        {Push sepair(stmt:S env:{DeclareIdent X @Current.env})}
                        {Execute}
                    [] [bind ident(X) ident(Y)] then
                        % TODO {Unify @Current.env.X @Current.env.Y}
                    % TODO add other statements here and handle them
                    % S -> S1 S2. Push S2 first. Then S1
                    [] X|Xr then
                        if Xr \= nil then
                            {Push sepair(stmt:Xr env:@Current.env)}
                        else skip end
                        {Push sepair(stmt:X env:@Current.env)}
                        {Execute}
                    end
                else
                    {Browse 'Complete'}
                end
            end
            {Execute}
        end
    end
    % {Interpret [[[[nop]]]]}
    % {Interpret [[nop] [nop] [nop]]}

    % {Interpret [[nop] [localvar ident(x) [nop]] [nop]]}
    % {Interpret [localvar ident(x)
    %              [localvar ident(y)
    %                 [
    %                     [localvar ident(x)
    %                         [nop]
    %                     ]
    %                     [nop]
    %                 ]
    %             ]
    %         ]}

    X = {AddKeyToSAS}
    {BindValueToKeyInSAS X 42}
    {BindValueToKeyInSAS X 84}
    {Browse {RetrieveFromSAS X}}
end
