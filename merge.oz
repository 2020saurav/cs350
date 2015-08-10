functor
import
	Browser(browse:Browse)

define
	fun {Merge X Y}
		fun {MergeAux A B}
			case A
			of nil then B
			[] P|Ps then
				case B
				of nil then A
				[] Q|Qs then
					if P < Q then (P|{MergeAux Ps B}) else (Q|{MergeAux A Qs}) end
				end
			end
		end
	in
		{MergeAux X Y}
	end
	{Browse {Merge [1 100 1000 10000] [2 99 101 1030 9999]}}
end