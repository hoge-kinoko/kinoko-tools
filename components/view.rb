require "js"

class View
  def document
    JS.global["document"]
  end

  def delimited(number)
    return number.to_s if number.abs.to_s.length <= 3

    number.to_s.reverse.scan(/.{1,3}/).join(",").reverse
  end

  def create_elem(tag, parent)
    elem = document.createElement(tag)

    yield(elem) if block_given?

    parent&.appendChild(elem)

    elem
  end
end
