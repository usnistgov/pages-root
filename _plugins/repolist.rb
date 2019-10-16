module Jekyll

  require 'nokogiri'

  class RepoListTag < Liquid::Tag

    @@repodir = '/srv/web/pages-generated'        # Where all the published repos reside

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def _gettitle(filename)
      title = ""
      if File.exist?(filename)
        doc = Nokogiri::HTML(open(filename))
        doc.search('title').each do |t|
	  title = t.content
	  break
        end
        return title
      end
    end

    def render(context)
      repos = Dir.entries(@@repodir).select {|entry| File.directory? File.join(@@repodir, entry) and !(entry == '.' || entry == '..') }
      repos = repos.sort
      if repos.empty?
        s = "<p>(No published repos found!)</p>"
      else
        s = '<table class="table table-striped"><thead><tr><th>Repo Name</th><th>Description</th></tr></thead><tbody>'
        repos.each do |repo|
          title = ""
          indexfiles = ['index.html', 'index.htm']
          indexfiles.each do |x|
	    fn = File.join(@@repodir, repo, x)
	    title =  _gettitle(fn)
            break if title != ""
          end
          s += "<tr><td><a href='/" + repo + "/'>" + repo + "</a></td><td>#{title}</td></tr>"
        end
        s += "</tbody></table>"
      end
      return s
    end

  end

end

Liquid::Template.register_tag('repolist', Jekyll::RepoListTag)
