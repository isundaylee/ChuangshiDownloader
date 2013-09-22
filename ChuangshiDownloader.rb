class ChuangshiDownloader

  require 'nokogiri'
  require 'open-uri'
  require 'json'

  def self.download_chapter(link, title, output_path, cid)
    print "  Downloading Chapter #{title}: " 

    FileUtils.mkdir_p(output_path)

    filename = File.basename(URI.parse(link).path, '.html')
    match = filename.match(/^[0-9]*-m-([0-9]*)$/)

    if !match then
      puts "Failed to extract ID. "
      return
    end

    id = match[1]

    chapter = JSON.parse(open("http://chuangshi.qq.com/www/static/#{id[0...-3]}/#{id}.html").read)

    content = Nokogiri::HTML(chapter['Content'])

    title = content.css('.story_title').first.content

    File.open(File.join(output_path, "%03d %s.txt" % [cid, title]), 'w') do |f|

      content.css('.text p').each do |paragraph|
        next if paragraph.content =~ /创世中文网首发/
        f.puts "#{paragraph.to_s}"
      end

    end

    puts "Done. "
  end

  def self.download(root_url, output_path)
    menu = Nokogiri::HTML(open(root_url))

    FileUtils.mkdir_p(output_path)

    counter = 0

    menu.css('.index_area .list').each do |volume|
      volume_title = volume.css('h1').first.text
      volume_title = volume_title[0...-6] if volume_title =~ /\[分卷阅读\]$/
      
      puts "Downloading Volume: #{volume_title}"
      
      counter = counter + 1
      volume_path = File.join(output_path, "%03d %s" % [counter, volume_title])
      FileUtils.mkdir_p(volume_path) 

      ccounter = 0

      volume.css('.block_ul li').each do |chapter|
        next if chapter['class'] == 'short_block'

        title = chapter.css('b').first.content.strip
        link = "http://chuangshi.qq.com#{chapter.css('a').first['href']}"

        ccounter = ccounter + 1
        download_chapter(link, title, volume_path, ccounter)
      end
    end
  end

end

