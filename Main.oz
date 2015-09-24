% Assignment 2 : Interpreter for Kernel Language
% Authors: Abhilash (12014), Anusha (12148), Saurav (12641)
% Compilation: This codes compiles stand-alone using ozc compiler
% Compile: ` ozc -c Main.oz -f Main `
% Run : ` ozengine Main `

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
            % Procedure to execute top statement on semantic stack
            proc {Execute}
                Current := {Pop}
                {Browse @Current}
                {Browse {Dictionary.toRecord store Store}}
                if @Current \= nil then
                    case @Current.stmt
                    of nil then {Browse 'Complete'}
                    % 'nop' : skip. Do nothing
                    [] [nop] then {Execute}
                    % 'local block declaration': Push S, add X to env
                    [] [localvar X S] then
                        {Push sepair(stmt:S env:{DeclareIdent X @Current.env})}
                        {Execute}
                    % 'bind operation' using unification
                    [] [bind X Y] then
                        {Unify X Y @Current.env}
                        {Execute}
                    % 'if-then-else'
                    [] [conditional X S1 S2] then
                        local Predicate in
                            case X
                            of ident(P) then
                                Predicate = {RetrieveFromSAS @Current.env.P}
                            else
                                Predicate = X
                            end
                            if Predicate == literal(true) then
                                {Push sepair(stmt:S1 env:@Current.env)}
                            else
                                if Predicate == literal(false) then
                                    {Push sepair(stmt:S2 env:@Current.env)}
                                else raise conditionNotBoolean(X) end
                                end
                            end
                        end
                        {Execute}

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
    % Problem 1
    % {Interpret [[[[nop]]]]}
    {Interpret [[nop] [nop] [nop]]}

    % Problem 2
    % {Interpret [[nop] [localvar ident(x) [nop]] [nop]]}
    % {Interpret  [localvar ident(x)
    %                 [localvar ident(y)
    %                     [
    %                         [localvar ident(x)
    %                             [nop]
    %                         ]
    %                         [nop]
    %                     ]
    %                 ]
    %             ]}

    % Problem 3
    % {Interpret  [localvar ident(x)
    %                 [localvar ident(y)
    %                     [bind ident(x) ident(y)]
    %                 ]
    %             ]}

    % Problem 4a
    % {Interpret  [localvar ident(x)
    %                 [bind ident(x) [record literal(a) [literal(f1) ident(x)]]]
    %             ]}
    % {Interpret  [localvar ident(x)
    %                 [localvar ident(y)
    %                     [
    %                         [bind ident(x) [record literal(a) [[literal(f1) ident(y)]]]]
    %                         [bind ident(y) literal(100)]
    %                     ]
    %                 ]
    %             ]}

    % Problem 5a
    % {Interpret  [localvar ident(x)
    %                 [bind ident(x) literal(100)]
    %             ]}

    % Problem 6
    % {Interpret  [localvar ident(x)
    %                 [conditional literal(true) [bind ident(x) literal(42)] [bind ident(x) literal(0)]]
    %             ]}
    % {Interpret  [localvar ident(x)
    %                 [localvar ident(y)
    %                     [
    %                         [bind ident(x) literal(true)]
    %                         [conditional ident(x)
    %                             [bind ident(y) literal(42)]
    %                             [bind ident(y) literal(0)]
    %                         ]
    %                     ]
    %                 ]
    %             ]}

end
