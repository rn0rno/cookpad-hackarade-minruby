# An implementation of the evaluator
def evaluate(exp, env, fdefs)
  # exp: A current node of AST
  # env: An environment (explained later)
  case exp[0]
  when "lit"
    exp[1]
  when "+"
    evaluate(exp[1], env, fdefs) + evaluate(exp[2], env, fdefs)
  when "-"
    evaluate(exp[1], env, fdefs) - evaluate(exp[2], env, fdefs)
  when "*"
    evaluate(exp[1], env, fdefs) * evaluate(exp[2], env, fdefs)
  when "%"
    evaluate(exp[1], env, fdefs) % evaluate(exp[2], env, fdefs)
  when "/"
    evaluate(exp[1], env, fdefs) / evaluate(exp[2], env, fdefs)
  when "<"
    evaluate(exp[1], env, fdefs) < evaluate(exp[2], env, fdefs)
  when ">"
    evaluate(exp[1], env, fdefs) > evaluate(exp[2], env, fdefs)
  when "=="
    evaluate(exp[1], env, fdefs) == evaluate(exp[2], env, fdefs)
  when "!="
    evaluate(exp[1], env, fdefs) != evaluate(exp[2], env, fdefs)
  when "stmts"
    rtn = nil
    idx = 1
    while exp[idx] != nil
      _exp = exp[idx]
      rtn = evaluate(_exp, env, fdefs)
      idx = idx + 1
    end
    rtn
  when "var_ref"
    env[exp[1]]
  when "var_assign"
    env[exp[1]] = evaluate(exp[2], env, fdefs)
  when "if"
    if evaluate(exp[1], env, fdefs)
      evaluate(exp[2], env, fdefs)
    else
      evaluate(exp[3], env, fdefs)
    end
  when "while"
    while evaluate(exp[1], env, fdefs) do
      evaluate(exp[2], env, fdefs)
    end
  when "func_call"
    func = fdefs[exp[1]]
    if func == nil
      case exp[1]
      when "p"
        p(evaluate(exp[2], env, fdefs))
      when "Integer"
        Integer(evaluate(exp[2], env, fdefs))
      when "fizzbuzz"
        num = evaluate(exp[2], env, fdefs)
        if num % 15 == 0
          "fizzbuzz"
        elsif num % 3 == 0
          "fizz"
        elsif num % 5 == 0
          "buzz"
        else
          num
        end
      when "minruby_parse"
        minruby_parse(evaluate(exp[2], env, fdefs))
      when "minruby_load"
        minruby_load()
      else
        raise("unknown builtin function")
      end
    else
      local_env = {}
      # TODO: argument size error
      idx = 2
      while exp[idx] != nil
        _exp = exp[idx]
        local_env[func[0][idx-2]] = evaluate(_exp, env, fdefs)
        idx = idx + 1
      end
      evaluate(func[1], local_env, fdefs)
    end
  when "func_def"
    fdefs[exp[1]] = [exp[2], exp[3]]
  when "ary_new"
    ary = {}
    idx = 1
    while exp[idx] != nil
      _exp = exp[idx]
      ary[idx-1] = evaluate(_exp, env, fdefs)
      idx = idx + 1
    end
    ary
  when "ary_ref"
    ary = evaluate(exp[1], env, fdefs)
    idx = evaluate(exp[2], env, fdefs)
    if ary == nil
      nil
    else
      ary[idx]
    end
  when "ary_assign"
    ary = evaluate(exp[1], env, fdefs)
    target_idx = evaluate(exp[2], env, fdefs)
    assign_val = evaluate(exp[3], env, fdefs)
    ary[target_idx] = assign_val
  when "hash_new"
    hsh = {}
    idx = 1
    while exp[idx] != nil
      key = evaluate(exp[idx], env, fdefs)
      hsh[key] = evaluate(exp[idx+1], env, fdefs)
      idx = idx + 2
    end
    hsh
  else
    p("error")
    pp(exp)
    raise("unknown node")
  end
end


fdefs = {}
env = {}
fdenv = {}

# `minruby_load()` == `File.read(ARGV.shift)`
# `minruby_parse(str)` parses a program text given, and returns its AST
evaluate(minruby_parse(minruby_load()), env, fdefs)
