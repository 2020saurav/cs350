functor
import
    Browser(browse: Browse)
define
    % Stack < Statement, Environment > Pair of stmt and env
    \insert 'SemanticStack.oz'
    \insert 'SingleAssignmentStore.oz'
    \insert 'ProcessRecords.oz'
    \insert 'Unify.oz'
    Current = {NewCell nil}
    fun {DeclareIdent X Env}
        case X
        of ident(X1) then {Adjoin Env env(X1:{AddKeyToSAS})}
        else raise declarationError(X) end
        end
    end

    proc {Interpret AST}
        {Push sepair(stmt:AST env:nil)}
        local Execute in
            proc {Execute}
                Current := {Pop}
                {Browse @Current}
                % {Browse {Dictionary.toRecord store Store}}
                if @Current \= nil then
                    case @Current.stmt
                    of nil then {Browse 'Complete'}
                    % 'nop' : skip. Do nothing
                    [] [nop] then {Execute}
                    [] [localvar X S] then
                        {Push sepair(stmt:S env:{DeclareIdent X @Current.env})}
                        {Execute}
                    [] [bind X Y] then
                        {Unify X Y @Current.env}
                        {Execute}
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

    {Interpret [localvar ident(x)
                 [localvar ident(y)
                    [[bind ident(x) ident(y)] [nop]]
                ]
            ]}
end
