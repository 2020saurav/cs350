functor
import
	Browser(browse:Browse)

define
	fun {Merge A B}
		case A
		of nil then B
		[] P|Ps then
			case B
			of nil then A
			[] Q|Qs then
				if P < Q then (P|{Merge Ps B}) else (Q|{Merge A Qs}) end
			end
		end
	end

	{Browse {Merge [1 100 1000 10000] [2 99 101 1030 9999]}}
	{Browse {Merge [~200 ~5 0 90] [~88 5 100]}}
	{Browse {Merge nil [2 99 101 1030 9999]}}
	{Browse {Merge [100] [2 99 101 1030 9999]}}
end
