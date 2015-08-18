opal_filter "Float" do
  fails "Float#fdiv performs floating-point division between self and a Bignum"
  fails "Float#fdiv performs floating-point division between self and a Complex"
  fails "Float#fdiv performs floating-point division between self and a Rational"
  fails "Float#round raises FloatDomainError for exceptional values when passed a non-positive precision"
  fails "Float#round raises FloatDomainError for exceptional values"
  fails "Float#round raises RangeError for NAN when passed a non-positive precision"
  fails "Float#round raises a TypeError when its argument can not be converted to an Integer"
  fails "Float#round returns rounded values for big argument"
  fails "Float#round returns rounded values for big values"
  fails "Float#round returns the nearest Integer"
  fails "Float#round rounds self to an optionally given precision"
  fails "Float#round works for corner cases"
  fails "Float#to_i returns self truncated to an Integer"
  fails "Float#to_int returns self truncated to an Integer"
  fails "Float#to_s uses e format for a negative value with fractional part having 6 significant figures"
  fails "Float#to_s uses e format for a negative value with whole part having 18 significant figures"
  fails "Float#to_s uses e format for a positive value with fractional part having 6 significant figures"
  fails "Float#to_s uses e format for a positive value with whole part having 18 significant figures"
  fails "Float#to_s uses non-e format for a negative value with whole part having 15 significant figures"
  fails "Float#to_s uses non-e format for a negative value with whole part having 16 significant figures"
  fails "Float#to_s uses non-e format for a negative value with whole part having 17 significant figures"
  fails "Float#to_s uses non-e format for a positive value with whole part having 15 significant figures"
  fails "Float#to_s uses non-e format for a positive value with whole part having 16 significant figures"
  fails "Float#to_s uses non-e format for a positive value with whole part having 17 significant figures"
  fails "Float#truncate returns self truncated to an Integer"

  # precision errors caused by Math.frexp and Math.ldexp
  fails "Float#rationalize returns self as a simplified Rational with no argument"
  fails "Float#divmod returns an [quotient, modulus] from dividing self by other"
end