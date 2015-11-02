MultiStack = {NewCell nil}
SemanticStack = {NewCell nil}
%thread level
proc {AddNewStack StmtEnvPair}
    % local NewSemanticStack in
    %     NewSemanticStack = {NewCell nil}
    %     NewSemanticStack := StmtEnvPair | nil
    %     MultiStack := {Append {Cell.access MultiStack} [{Cell.access NewSemanticStack}]}
    % end
    MultiStack := [StmtEnvPair] | @MultiStack
end

proc {DeleteCurSemanticStack}
    % MultiStack := {List.drop {Cell.access MultiStack} 1}
    MultiStack := @MultiStack.2
end

proc {SuspendCurrentThread}
    % SemanticStack := {Cell.access MultiStack}.1
    % MultiStack := {List.drop {Cell.access MultiStack} 1}
    % MultiStack := {Append {Cell.access MultiStack} [{Cell.access SemanticStack}]}

    MultiStack := {Append @MultiStack.2 [@MultiStack.1]}
end

%statement level
proc {Push StmtEnvPair}
    % {Browse push}
    % {Browse StmtEnvPair}
    % {Browse (@MultiStack)}
    % SemanticStack := {Cell.access MultiStack}.1
    % MultiStack := {List.drop {Cell.access MultiStack} 1}
    % SemanticStack := StmtEnvPair | {Cell.access SemanticStack}
    % MultiStack := SemanticStack | {Cell.access MultiStack}

    MultiStack := (StmtEnvPair|@MultiStack.1) | @MultiStack.2

end

fun {Pop}
    % {Browse pop}
    % {Browse  @MultiStack.1}
    % SemanticStack := {Cell.access MultiStack}.1
    % {DeleteCurSemanticStack}
    % case @SemanticStack
    % of nil then
    %     nil
    % [] StmtEnvPair | RemainingStack then
    %     MultiStack := RemainingStack | {Cell.access MultiStack}
    %     StmtEnvPair
    % else
    %     raise foo(@SemanticStack) end
    % end
    case @MultiStack.1
    of nil then
        {DeleteCurSemanticStack}
        nil
    [] StmtEnvPair | RemainingStack then
        MultiStack := RemainingStack | @MultiStack.2
        StmtEnvPair
    else
        raise foo(@SemanticStack) end
    end
end
