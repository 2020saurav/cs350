functor
import
	Browser(browse:Browse)
define
	fun {TakeAllLines Conf}
		case Conf
			of [[A1 A2 A3] [B1 B2 B3] [C1 C2 C3]] then
				[A1 B1 C1]|[A2 B2 C2]|[A3 B3 C3]|
				[A1 B2 C3]|[A3 B2 C1]|
				Conf
			else Conf
		end
	end
	fun {FindWinner Lines}
		case Lines
			of nil then draw
			[] [x x x]|_ then x
			[] [o o o]|_ then o
			[] _|Xs then {FindWinner Xs}
			else draw
		end
	end	
	fun {MatToList Conf}
		case Conf
			of [[A1 A2 A3] [B1 B2 B3] [C1 C2 C3]] then
				[A1 A2 A3 B1 B2 B3 C1 C2 C3]
			else nil
		end
	end
	fun {ListToMat Conf}
		case Conf
			of [A1 A2 A3 B1 B2 B3 C1 C2 C3] then
				[[A1 A2 A3] [B1 B2 B3] [C1 C2 C3]]
			else nil
		end
	end
	fun {Concat Xs Ys}
		case Xs
		of nil then Ys
		[] X|Xr then X|{Concat Xr Ys}
		end
	end
	fun {Moves Conf Player}
		local MovesAux in
			fun {MovesAux Skipped Left Player }
				case Left
				of nil then nil
				[] s|Xs then {ListToMat {Concat Skipped Player|Xs}}|{MovesAux {Append Skipped [s]} Xs Player}
				[] X|Xs then {MovesAux {Append Skipped [X]} Xs Player}
				end
			end						
			{MovesAux nil {MatToList Conf} Player}
		end
	end
	{Browse {FindWinner {TakeAllLines [[s s s] [o o s] [s o x]]}}}
	{Browse {FindWinner {TakeAllLines [[x x x] [o o s] [s o x]]}}}
	{Browse {FindWinner {TakeAllLines [[s s s] [o o o] [s o x]]}}}
	{Browse {FindWinner {TakeAllLines [[s o s] [o o s] [s o x]]}}}
	{Browse {FindWinner {TakeAllLines [[x s s] [o x s] [s o x]]}}}
	{Browse {Moves [[s s s] [s s s] [s s s ]] x}}
	{Browse {Moves [[s o o] [o o o] [o o o ]] x}}
end
