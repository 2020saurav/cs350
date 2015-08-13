functor
import
	Browser(browse:Browse)
define
	fun lazy {Sin X}
		local SinAux in
			fun {SinAux X NextTerm Term}
				NextTerm | {SinAux X NextTerm*(~1.0)*X*X/((Term+1.0)*(Term+2.0)) Term+2.0}
			end
			{SinAux X X 1.0}
		end
	end
	fun {EvalUptoN N PartialResult SinX}
		if N =< 0 then PartialResult
		else 
			{EvalUptoN (N-1) (PartialResult+SinX.1) SinX.2}
		end
	end
	fun {Abs X}
		if X >= 0.0 then X else ~X end
	end
	fun {EvalUptoEps Eps PartialResult Last SinX}
		if {Abs (Last - SinX.1)} =< Eps then PartialResult
		else
			{EvalUptoEps Eps (PartialResult+SinX.1) SinX.1 SinX.2}
		end
	end
	{Browse {EvalUptoN 5 0.0 {Sin 0.523}}}
	{Browse {EvalUptoN 5 0.0 {Sin ~0.523}}}
	{Browse {EvalUptoN 5 0.0 {Sin 1.569}}}
	{Browse {EvalUptoEps 0.1 0.0 0.0 {Sin 0.523}}}
	{Browse {EvalUptoEps 0.01 0.0 0.0 {Sin 0.523}}}
end
