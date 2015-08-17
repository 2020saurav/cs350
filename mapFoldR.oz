functor
import
	Browser(browse:Browse)
define
	fun {FoldR L B I}
		case L
		of nil then I
		[] H|T then {B H {FoldR T B I}}
		end
	end
	fun {Map F L}
		{FoldR L fun {$ X Y}{F X}|Y	end nil}
	end
	fun {Sq X}
		X*X
	end
	{Browse {Map Sq [1 2 3]}}
	{Browse {Map Sq [3 4 5 6 7]}}
end