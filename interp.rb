require "minruby"

# An implementation of the evaluator
def evaluate(exp, env, fdenv)
  # exp: A current node of AST
  # env: An environment (explained later)

  case exp[0]

#
## Problem 1: Arithmetics
#

  when "lit"
    exp[1] # return the immediate value as is

  when "+"
    evaluate(exp[1], env, fdenv) + evaluate(exp[2], env, fdenv)
  when "-"
    evaluate(exp[1], env, fdenv) - evaluate(exp[2], env, fdenv)
  when "*"
    evaluate(exp[1], env, fdenv) * evaluate(exp[2], env, fdenv)
  when "%"
    evaluate(exp[1], env, fdenv) % evaluate(exp[2], env, fdenv)
  when "/"
    evaluate(exp[1], env, fdenv) / evaluate(exp[2], env, fdenv)
  when "<"
    evaluate(exp[1], env, fdenv) < evaluate(exp[2], env, fdenv)
  when ">"
    evaluate(exp[1], env, fdenv) > evaluate(exp[2], env, fdenv)
  when "=="
    evaluate(exp[1], env, fdenv) == evaluate(exp[2], env, fdenv)

#
## Problem 2: Statements and variables
#

  when "stmts"
    rtn = nil
    exp[1..-1].each do |_exp|
      rtn = evaluate(_exp, env, fdenv)
    end

    rtn
  when "var_ref"
    env[exp[1]]

  when "var_assign"
    env[exp[1]] = evaluate(exp[2], env, fdenv)


#
## Problem 3: Branchs and loops
#

  when "if"
    evaluate(exp[1], env, fdenv) ? evaluate(exp[2], env, fdenv) : evaluate(exp[3], env, fdenv)

  when "while"
    evaluate(exp[2], env, fdenv) while evaluate(exp[1], env, fdenv)

#
## Problem 4: Function calls
#

  when "func_call"
    # Lookup the function definition by the given function name.
    func = $function_definitions[exp[1]]

    if func.nil?
      case exp[1]
      when "p"
        p(evaluate(exp[2], env, fdenv))
      when "Integer"
        evaluate(exp[2], env, fdenv).to_i
      when "fizzbuzz"
        num = evaluate(exp[2], env, fdenv)
        if num % 15 == 0
          "fizzbuzz"
        elsif num % 3 == 0
          "fizz"
        elsif num % 5 == 0
          "buzz"
        else
          num
        end
      else
        raise("unknown builtin function")
      end
    else
      tmp_fdenv = fdenv
      fdenv = {}
      if exp[2..-1].size == func[0].size
        exp[2..-1].each_with_index do |_exp, i|
          fdenv[func[0][i]] = Integer(evaluate(_exp, env, tmp_fdenv))
        end

        k = evaluate(func[1], fdenv, {})
        fdenv = tmp_fdenv
        k
      else
        raise("引数の個数が違います")
      end
    end

  when "func_def"
    $function_definitions[exp[1]] = [exp[2], exp[3]]

#
## Problem 6: Arrays and Hashes
#

  # You don't need advices anymore, do you?
  when "ary_new"
    raise(NotImplementedError) # Problem 6

  when "ary_ref"
    raise(NotImplementedError) # Problem 6

  when "ary_assign"
    raise(NotImplementedError) # Problem 6

  when "hash_new"
    raise(NotImplementedError) # Problem 6

  else
    p("error")
    pp(exp)
    raise("unknown node")
  end
end


$function_definitions = {}
env = {}
fdenv = {}

# `minruby_load()` == `File.read(ARGV.shift)`
# `minruby_parse(str)` parses a program text given, and returns its AST
evaluate(minruby_parse(minruby_load()), env, fdenv)
