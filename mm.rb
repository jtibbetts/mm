#!/Users/johntibbetts/.rvm/rubies/ruby-1.9.3-p362/bin/ruby
require 'trollop'
require_relative 'topic'
require_relative 'emitter'

MEMENTO_STORE_DIR = File.expand_path "~/git/memento"
MEMENTO_STORE_ALL_MEM_FILES = File.join MEMENTO_STORE_DIR, "*.mem"

TOPIC_LEADER_PATTERN = /^#([[:alpha:]][[:word:]]*):(.*)$/

opts = Trollop::options do
  opt :list, "List of topics"
  opt :topic, "Topic name", :type => :string
  opt :margin, "Margin", :type => :int, :default => 2
  opt :format, "Format (topic, item, first_line, extra_lines)", :type => :string,
      :default => "%-24{item} %{first_line}\n%{extra_lines}"
end

#puts opts

topic_list_emitter = Emitter.new("  %{topic}")
topic_emitter = Emitter.new(opts[:format])

def load_topic topic_name
  topics = []
  #puts topic_name
  current_topic = nil
  f = File.open(File.join(MEMENTO_STORE_DIR, topic_name + ".mem")).each_line { |line|
    m = TOPIC_LEADER_PATTERN.match(line)
    if m
      current_topic = Topic.new topic_name, m[1], m[2].strip
      topics << current_topic
    else
      # if already content, linefeed then append
      #current_topic.extra_lines << "\n" if current_topic.extra_lines.length > 0
      current_topic.extra_lines << line
    end
  }
  topics
end

def show_topics results, emitter
  results.each {|result| puts emitter.emit(result.to_hash)}
end

def show_result sary
  sary.each {|s| puts "  #{s}"}
end

dir = Dir[MEMENTO_STORE_ALL_MEM_FILES]
topic_hashes = dir.entries.collect {|fname| {topic: File.basename(fname, ".mem")}}
if opts[:list]
  topic_hashes.each {|pair| puts topic_list_emitter.emit(pair)}
else
  if opts[:topic]
    results = load_topic(opts[:topic])
  else
    results = []
    topic_hashes.each do |topic_hash|
      results = results + load_topic(topic_hash[:topic])
    end
  end
  show_topics results, topic_emitter
end