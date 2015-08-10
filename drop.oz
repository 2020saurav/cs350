functor
import
	Browser(browse:Browse)

define
	local Drop in 
		fun {Drop Xs N}
			if 0 >= N then Xs
			else 
				case Xs
				of nil then Xs
				[] _|T then {Drop T N-1}
				end
			end
		end
		{Browse {Drop [1 2 3 4 5] 3}}
		{Browse {Drop [1 2 3 4 5] 5}}
		{Browse {Drop [1 2 3 4 5] ~5}}
		{Browse {Drop [1 2 3 4 5] 7}}
	end
end
