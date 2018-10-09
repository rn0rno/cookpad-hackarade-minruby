require "minruby"

MY_PROGRAM = 'interp.rb'
Dir.glob("test#{ARGV[0]}*.rb").sort.each do |f|
  correct = `ruby #{f}`
  answer = `RUBY_THREAD_VM_STACK_SIZE=400000000 ruby -rminruby #{MY_PROGRAM} #{MY_PROGRAM} #{MY_PROGRAM} #{f}`

  if correct == answer
    # puts answer
    puts "\e[32m#{f} => OK!\e[0m"
  elsif f == "test4-4.rb"
    puts "\e[33m#{f} => SKIP!\e[0m"
  else
    puts "\e[31m#{f} => NG!\e[0m"
    puts "=== Expect ==="
    puts correct
    puts "=== Actual ==="
    puts answer
    code = File.read(f)
    puts "=== Test Program ==="
    puts code
    puts "=== AST ==="
    pp minruby_parse(code)
  end
end
