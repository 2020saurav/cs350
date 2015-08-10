functor
import Browser
define
	local Drop in 
		fun {Drop Xs N}
			if 0 >= N then Xs
			else 
				case Xs
				of nil then Xs
				[] H|T then {Drop T N-1}
				end
			end
		end
		{Browser.browse {Drop [1 2 3 4 5] 3}}
		{Browser.browse {Drop [1 2 3 4 5] 5}}
		{Browser.browse {Drop [1 2 3 4 5] ~5}}
		{Browser.browse {Drop [1 2 3 4 5] 7}}
	end
end
