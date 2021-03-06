BASIC_NUMBER_RULES = let
    [@rule(identity(~x) => ~x)
     @rule(-(~x, ~y) => ~x + -1(~y))
     @rule(~x / ~y => ~x * pow(~y, -1))
     #@rule(*(~~x, *(~~y), ~~z) => *((~~x)..., (~~y)..., (~~z)...))
     @rule(*(~~x::isnotflat(*)) => flatten_term(*, ~~x))
     @rule(*(~~x::!(issortedₑ)) => sort_args(*, ~~x))
     @acrule(~a::isnumber * ~b::isnumber => ~a * ~b)

     #@rule(+(~~x, +(~~y), ~~z) => +((~~x)..., (~~y)..., (~~z)...))
     @rule(+(~~x::isnotflat(+)) => flatten_term(+, ~~x))
     @rule(+(~~x::!(issortedₑ)) => sort_args(+, ~~x))
     @acrule(~a::isnumber + ~b::isnumber => ~a + ~b)

     @acrule(*(~~x) + *(~β, ~~x) => *(1 + ~β, (~~x)...))
     @acrule(*(~α, ~~x) + *(~β, ~~x) => *(~α +  ~β, (~~x)...))
     @acrule(*(~~x, ~α) + *(~~x, ~β,) => *(~α +  ~β, (~~x)...))

     @acrule(~x + *(~β, ~x) => *(1 + ~β, ~x))
     @acrule(*(~α::isnumber, ~x) + ~x => *(~α + 1, ~x))

     # group stuff
     @rule(^(*(~~x), ~y) => *(map(a->pow(a, ~y), ~~x)...))
     @acrule((~y)^(~n) * ~y => (~y)^(~n+1))
     @acrule((~x)^(~n) * (~x)^(~m) => (~x)^(~n + ~m))
     @rule((((~x)^(~p))^(~q)) => (~x)^((~p)*(~q)))
     @rule(+(~~x::hasrepeats) => +(merge_repeats(*, ~~x)...))
     @rule(*(~~x::hasrepeats) => *(merge_repeats(^, ~~x)...))

     @acrule((~z::_iszero *  ~x) => ~z)

     # remove the idenitities
     @acrule((~z::_isone  * ~x) => ~x)
     @acrule((~z::_iszero + ~x) => ~x)
     @rule(^(~x, ~z::_iszero) => 1)
     @rule(^(~x, ~z::_isone) => ~x)
     @rule(+(~x) => ~x)
     @rule(*(~x) => ~x)
    ]
end

TRIG_RULES = let
    [
     @acrule(sin(~x)^2 + cos(~x)^2 => one(~x))
     @acrule(sin(~x)^2 + -1        => cos(~x)^2)
     @acrule(cos(~x)^2 + -1        => sin(~x)^2)

     @acrule(tan(~x)^2 + -1*sec(~x)^2 => one(~x))
     @acrule(tan(~x)^2 +  1 => sec(~x)^2)
     @acrule(sec(~x)^2 + -1 => tan(~x)^2)

     @acrule(cot(~x)^2 + -1*csc(~x)^2 => one(~x))
     @acrule(cot(~x)^2 +  1 => csc(~x)^2)
     @acrule(csc(~x)^2 + -1 => cot(~x)^2)
     ]
end


SIMPLIFY_RULES = vcat(BASIC_NUMBER_RULES, TRIG_RULES)


OLD_BASIC_NUMBER_RULES = let # Keep these around for benchmarking purposes
    [
     @rule(~x - ~y => ~x + (-1 * ~y)),
     @rule(~x / ~y => ~x * pow(~y, -1)),
     #@rule(*(~~x, *(~~y), ~~z) => *((~~x)..., (~~y)..., (~~z)...)),
     @rule(*(~~x::isnotflat(*)) => flatten_term(*, ~~x)),
     @rule(*(~~x::!(issortedₑ)) => sort_args(*, ~~x)),
     @rule(*(~a::isnumber, ~b::isnumber, ~~x) => *(~a * ~b, (~~x)...)),

     #@rule(+(~~x, +(~~y), ~~z) => +((~~x)..., (~~y)..., (~~z)...)),
     @rule(+(~~x::isnotflat(+)) => flatten_term(+, ~~x)),
     @rule(+(~~x::!(issortedₑ)) => sort_args(+, ~~x)),
     @rule(+(~a::isnumber, ~b::isnumber, ~~x) => +((~~x)..., ~a + ~b)),

     @rule(+(~~a, *(~~x), *(~β::isnumber, ~~x), ~~b) =>
           +((~~a)..., *(1 + ~β, (~x)...), (~b)...)),
     @rule(+(~~a, *(~α::isnumber, ~x), ~~b, ~x, ~~c) =>
           +((~~a)..., *(+(~α+1), ~x), (~~b)..., (~~c)...)),
     @rule(+(~~a, *(~α::isnumber, ~~x), *(~β::isnumber, ~~x), ~~b) =>
           +((~~a)..., *(~α + ~β, (~x)...), (~b)...)),

     # group stuff
     @rule(^(*(~~x), ~y) => *(map(a->a ^ (~y), ~~x)...)),
     @rule(*(~~x, ^(~y, ~n), ~y, ~~z) => *((~~x)..., ^(~y, ~n+1), (~~z)...)),
     @rule(*(~~a, ^(~x, ~e1), ^(~x, ~e2), ~~b) =>
           *((~~a)..., ^(~x, (~e1 + ~e2)), (~b)...)),
     @rule((((~x)^(~p))^(~q)) => (~x)^((~p)*(~q))),
     @rule(+(~~x::hasrepeats) => +(merge_repeats(*, ~~x)...)),
     @rule(*(~~x::hasrepeats) => *(merge_repeats(^, ~~x)...)),

     @rule(*(~z::_iszero, ~~x) => ~z),

     # remove the idenitities
     @rule(*(~z::_isone, ~~x::(!isempty)) => *((~~x)...)),
     @rule(+(~z::_iszero, ~~x::(!isempty)) => +((~~x)...)),
     @rule(^(~x, ~z::_iszero) => 1),
     @rule(^(~x, ~z::_isone) => ~x),
     ]
end
