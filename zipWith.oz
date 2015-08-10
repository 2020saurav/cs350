functor
import
	Browser(browse:Browse)

define

	fun {ZipWith BinOp Xs Ys}
		% TODO warning/error when lengths are unequal
		case Xs
		of nil then nil
		[] X|Xr then
			case Ys
			of nil then nil
			[] Y|Yr then {BinOp X Y}|{ZipWith BinOp Xr Yr}
			end
		end
	end

	fun {Add X Y}
		X + Y
	end

	fun {Multiply X Y}
		X * Y
	end
	
	{Browse {ZipWith Add [1 2 10 ~90] [3 4 5 12]}}
	{Browse {ZipWith Multiply [1 2 10 ~90 0] [3 4 5 12 33]}}

end
