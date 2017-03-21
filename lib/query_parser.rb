module QueryParser
  OPERATORS = ["*","/"];
  SIG_FIG = 60;
  def parse_query(string, starting=0)
    text = ""
    val = BigDecimal.new("1.0")
    previous_operator = "*"

    start_of_unit = starting
    current = starting
    while (current < string.length)
      if string[current] == ")"
        # return what you have so far
        if start_of_unit < current
          text += get_val([string[start_of_unit..current-1]])
          val = calc(val, previous_operator, get_conversion(string[start_of_unit..current-1]))
        end
        break
      elsif OPERATORS.include?(string[current+1]) || string[current+1].nil?
        # convert text from start_of_unit..current and add to the string
        # get conversion value and add to value
        text += get_val([string[start_of_unit..current]])
        val = calc(val, previous_operator, get_conversion(string[start_of_unit..current]))
      elsif OPERATORS.include?(string[current])
        text += string[current]
        previous_operator = string[current]
        start_of_unit = current+1 if string[current+1] # if the string is not ended (shouldn't need to be checked if well behaved)
      elsif string[current] == "("
        inner_text, inner_val, current = parse_query(string, current+1)
        start_of_unit = current+1
        text += "(#{inner_text})"
        val = calc(val, previous_operator, inner_val)
      end
      current += 1
    end
    return [text, val, current]
  end

private
  def calc(val, operator, operand)
    if operator == '*'
      val.mult(operand, SIG_FIG)
    elsif operator == '/'
      val.div(operand, SIG_FIG)
    end
  end

  def get_val(string)
    fetch(string)["unit"]
  end

  def get_conversion(string)
    fetch(string)["conversion_factor"]
  end

  def fetch(unit)
    @store ||= {}
    return @store[unit] if @store[unit]
    si_unit = SiUnit.where("other_unit=?", unit).first
    @store[unit] = { "unit" => si_unit.si_unit, "conversion_factor" => si_unit.conversion_factor} if si_unit
  end
end
