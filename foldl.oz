functor
import
	Browser(browse:Browse)

define
	fun {Plus X Y}
		X + Y
	end
	fun {Mul X Y}
		X * Y
	end
	fun {NonAssociative X Y}
		2*X + 3*Y
	end
	fun {FoldL List BinOp Partial}
		case List
		of nil then Partial
		[] H|T then {FoldL T BinOp {BinOp Partial H}}
		end
	end
	{Browse {FoldL [1 2 3] Plus 0}}
	{Browse {FoldL [1 2 3 4] Mul 1}}
	{Browse {FoldL [1 2 3] NonAssociative 0}}
end
