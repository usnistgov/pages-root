module Jekyll

  require 'nokogiri'
  require 'cgi'

  class RepoListTag < Liquid::Tag

    @@repodir = '/srv/web/pages-generated'        # Where all the published repos reside
    @@blacklist = '/home/ubuntu/repo-blacklist'   # Contains a list of repos NOT to include in the generated repo list

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def _toHTML(s)
      return CGI.escapeHTML(s).gsub('“', '&ldquo;').gsub('”', '&rdquo;').gsub('‘', '&lsquo;').gsub('’', '&rsquo;').gsub('–', '&ndash;').gsub('—', '&mdash;').gsub('·', '&bull;')
    end

    def _gettitle(filename)
      title = ""
      if FileTest.file?(filename)
        doc = Nokogiri::HTML(open(filename))
        doc.search('title').each do |t|
          # we will use the DataTables ellipis plugin to truncate long lines but leave them
          # viewable via tooltips and searchable
          title = _toHTML(t.content)
	  break
        end
        return title
      end
    end

    def _get_blacklist(filename)
      if FileTest.file?(filename)
        return File.readlines(filename).map(&:chomp)
      else
        return []
      end
    end

    def render(context)
      blist = _get_blacklist(@@blacklist)
      repos = Dir.entries(@@repodir).select {|entry| File.directory? File.join(@@repodir, entry) and !(entry == '' || entry == '.' || entry == '..' || blist.include?(entry)) }
      repos = repos.sort_by(&:downcase)
      if repos.empty?
        s = "<p>(No published repos found!)</p>"
      else
        s = '<table id="repotable" class="table table-striped"><thead><tr><th>Repo Name</th><th>Description</th></tr></thead><tbody>'
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
