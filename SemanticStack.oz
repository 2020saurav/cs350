SemanticStack = {NewCell nil}

proc {Push StmtEnvPair}
    SemanticStack := StmtEnvPair | @SemanticStack
end

fun {Pop}
    case @SemanticStack
    of nil then nil
    [] StmtEnvPair | RemainingStack then
        SemanticStack := RemainingStack
        StmtEnvPair
    end
end
