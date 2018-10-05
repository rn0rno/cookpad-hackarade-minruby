require "minruby"

MY_PROGRAM = 'interp.rb'
Dir.glob("test#{ARGV[0]}*.rb").sort.each do |f|
  correct = `ruby #{f}`
  answer = `ruby #{MY_PROGRAM} #{f}`

  if correct == answer
    puts "\e[32m#{f} => OK!\e[0m"
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
