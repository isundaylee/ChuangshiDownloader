class Epubifier

  require 'gepub'

  def self.epubify(btitle, path, bauthor, output)

    pages = []

    Dir[File.join(path, '*')].each do |vol|
      vtitle = File.basename(vol).split(' ')[1..-1].join(' ')
      Dir[File.join(vol, '*.html')].each do |chap|
        ctitle = File.basename(chap, '.html').split(' ')[2..-1].join(' ')
        pages << {title: ctitle, file: File.join(Dir.getwd, chap)}
      end
    end

    FileUtils.mkdir_p '/tmp/epubs'

    builder = GEPUB::Builder.new {
      unique_identifier 'http:/example.jp/bookid_in_url', 'BookID', 'URL'
      title btitle
      creator bauthor

      date DateTime.now.to_s

      resources(:workdir => '/tmp/epubs/') {
        ordered {
          pages.each do |p|
            file p[:file]
            heading p[:title]
          end
        }
      }
    }

    epubname = File.join(File.dirname(__FILE__), output)
    builder.generate_epub(epubname)

  end

end

