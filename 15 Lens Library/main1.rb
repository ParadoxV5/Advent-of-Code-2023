puts(
  File.foreach('input.txt', ',', chomp: true).sum do|step|
    step.each_byte.reduce 0 do|hash, byte|
      byte < 0x20 ? hash : (hash + byte) * 17 & 0xFF # `" \n".bytes #=> [32, 10]`
    end
  end
)
