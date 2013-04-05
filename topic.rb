class Topic
  attr_accessor :item, :first_line, :extra_lines

  def initialize topic, item, first_line="", extra_lines=""
    @topic = topic
    @item = item
    @first_line = first_line
    @extra_lines =  extra_lines
  end

  def to_hash
    result = {}
    result[:topic] = @topic
    result[:item] = @item
    result[:first_line] = @first_line
    result[:extra_lines] = @extra_lines
    result
  end
end
