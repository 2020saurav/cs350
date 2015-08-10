functor
import
	Browser(browse:Browse)

define
	% O(N) time and O(N) stack depth
	local Take in
		fun {Take Xs N}
			if 0 >= N then nil
			else
				case Xs
				of nil then nil
				[] H|T then H|{Take T N-1}
				end
			end
		end
		{Browse {Take [1 2 3 4 5] 3}}
		{Browse {Take [1 2 3 4 5] 5}}
		{Browse {Take [1 2 3 4 5] ~5}}
		{Browse {Take [1 2 3 4 5] 7}}
	end

	% O(N) time and O(1) stack depth
	local Take in
		fun {Take Xs N}
			local TakeAux in
				fun {TakeAux Xs N Ys}
					if 0 >= N then Ys
					else 
						case Xs
						of nil then Ys
						[] H|T then {TakeAux T N-1 H|Ys}
						end
					end
				end
				{Reverse {TakeAux Xs N nil}}
			end
		end
		{Browse {Take [1 2 3 4 5] 3}}
		{Browse {Take [1 2 3 4 5] 5}}
		{Browse {Take [1 2 3 4 5] ~5}}
		{Browse {Take [1 2 3 4 5] 7}}
	end
end
