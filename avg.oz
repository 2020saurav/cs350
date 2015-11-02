functor
import
    Browser
    OS
define
    fun lazy {GenRand}
        {OS.rand} mod 2|{GenRand}
    end
    fun lazy {Avg LastAvg RandList N}
        local X in
            X = (LastAvg*N + {Int.toFloat RandList.1}) / (N + 1.0)
            X|{Avg X RandList.2 (N+1.0)}
        end
    end
    local A L in
        thread L = {GenRand} end
        thread A = {Int.toFloat L.1} | {Avg A.1 L.2 1.0} end
        {Browser.browse [L.1 L.2.1 L.2.2.1 L.2.2.2.1]}
        {Browser.browse [A.1 A.2.1 A.2.2.1 A.2.2.2.1]}
    end
end
