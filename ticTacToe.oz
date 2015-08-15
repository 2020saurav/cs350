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
			[] X|Xs then {FindWinner Xs}
			else draw
		end
	end	
	{Browse {FindWinner {TakeAllLines [[s s s] [o o s] [s o x]]}}}
	{Browse {FindWinner {TakeAllLines [[x x x] [o o s] [s o x]]}}}
	{Browse {FindWinner {TakeAllLines [[s s s] [o o o] [s o x]]}}}
	{Browse {FindWinner {TakeAllLines [[s o s] [o o s] [s o x]]}}}
	{Browse {FindWinner {TakeAllLines [[x s s] [o x s] [s o x]]}}}
end
