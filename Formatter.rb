class String
  alias strip_ws strip
  def strip chr=nil
    return self.strip_ws if chr.nil?
    self.gsub /^[#{Regexp.escape(chr)}]*|[#{Regexp.escape(chr)}]*$/, ''
  end
end

class Formatter

  def self.format(path)
    Dir[File.join(path, '**/*.txt')].each do |f|
      nf = File.join(File.dirname(f), "#{File.basename(f, '.txt')}.html")

      puts "Processing #{f}"

      File.open(nf, 'w') do |ouf|
        File.open(f, 'r') do |inf|
          title = File.basename(f, '.txt').split(' ')[2..-1].join(' ')
          ouf.puts("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/><title>#{title}</title></head><body>")
          ouf.puts("<h1>#{title}</h1>")
          inf.each_line do |l|
            next if l.strip.strip('　') == ' '
            ouf.puts("#{l.strip.strip('　')}")
          end
          ouf.puts("</html>")
        end
      end
    end

    puts "Done"
  end

end

