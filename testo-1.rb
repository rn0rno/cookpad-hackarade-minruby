def increment(n,m)
  if (n == 50)
    99
  else
    increment(n+1,m)
    m = m+100
  end
  m
end

p(increment(2,50))
