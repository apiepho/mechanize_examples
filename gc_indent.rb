# add copyright header

# indent control
class Indent
    attr_reader :str

    def initialize
        @str = ""
        #puts "==%d" % @str.length if $options.debug
    end

    def increase
        @str = "  " + @str
        #puts "++%d" % @str.length if $options.debug
    end

    def decrease
        @str = @str[2..-1] if not @str.empty?
        #puts "--%d" % @str.length if $options.debug
    end
end

