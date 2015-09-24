% Assignment 3 : Interpreter for Kernel Language
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
    fun {Declare X Env}
        case X
        of ident(X1) then {Adjoin Env env(X1:{AddKeyToSAS})}
        [] [record Label Features] then
            {DeclareListItems Features {Declare Label Env}}
        else raise declarationError(X) end
        end
    end

    fun {DeclareListItems ListItems Env}
        case ListItems
        of nil then Env
        [] Item | Items then
            {DeclareListItems Items {Declare Item.2.1 {Declare Item.1 Env}}}
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
                        {Push sepair(stmt:S env:{Declare X @Current.env})}
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
                    % 'case x of p then s1 else s2 end'
                    [] [match X P S1 S2] then
                        try % if unification fails, do S2
                            {Unify X P @Current.env} % P==X ? S1 : S2
                            {Push sepair(stmt:S1 env:@Current.env)}
                        catch incompatibleTypes(_ _) then
                            {Push sepair(stmt:S2 env:@Current.env)}
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
    % ------------------------------------ Test Cases ------------------------------------
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

    % Problem 7
    % {Interpret  [localvar ident(x)
    %                 [localvar ident(y)
    %                     [localvar ident(z)
    %                         [
    %                             [bind ident(x) [record literal(a) [[literal(f1) literal(100)]]]]
    %                             [match ident(x) [record literal(a) [[literal(f1) ident(y)]]]
    %                                 [bind ident(z) literal(42)]
    %                                 [bind ident(z) literal(0)]
    %                             ]
    %                         ]
    %                     ]
    %                 ]
    %             ]}
    % {Interpret  [localvar ident(x)
    %                 [localvar ident(y)
    %                     [localvar ident(z)
    %                         [
    %                             [bind ident(x) [record literal(a) [[literal(f1) literal(100)]]]]
    %                             [match ident(x) [record literal(b) [[literal(f1) ident(y)]]]
    %                                 [bind ident(z) literal(42)]
    %                                 [bind ident(z) literal(0)]
    %                             ]
    %                         ]
    %                     ]
    %                 ]
    %             ]}

    % {Interpret  [localvar ident(x)
    %                 [localvar ident(y)
    %                     [localvar ident(z)
    %                         [
    %                             [bind ident(x) [record literal(a) [
    %                                 [literal(f1) literal(100)]
    %                                 [literal(f2) [record literal(b) [
    %                                     [literal(f3) literal(42)]
    %                                 ]]]
    %                             ]]]
    %                             [match ident(x) [record literal(b) [[literal(f1) ident(y)]]]
    %                                 [bind ident(z) literal(42)]
    %                                 [bind ident(z) literal(0)]
    %                             ]
    %                         ]
    %                     ]
    %                 ]
    %             ]}

    % {Interpret  [localvar ident(x)
    %                 [localvar ident(y)
    %                     [localvar ident(z)
    %                         [
    %                             [bind ident(x) [record literal(a) [
    %                                 [literal(f1) literal(100)]
    %                                 [literal(f2) [record literal(b) [
    %                                     [literal(f3) literal(42)]
    %                                 ]]]
    %                             ]]]
    %                             [match ident(x) [record literal(a) [
    %                                                 [literal(f1) literal(100)]
    %                                                 [literal(f2) ident(y)]
    %                                             ]] % y will bind to record corresponding to literal(b)
    %                                 [bind ident(z) literal(42)]
    %                                 [bind ident(z) literal(0)]
    %                             ]
    %                         ]
    %                     ]
    %                 ]
    %             ]}
    % --------------------------------- Test Cases End ------------------------------------
end
