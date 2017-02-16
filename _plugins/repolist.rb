module Jekyll

  class RepoListTag < Liquid::Tag

    @@repodir = '/srv/web/pages-generated'        # Where all the published repos reside

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def _gettitle(filename)
      title = ""
      if File.exist?(filename)
        f = File.open(filename, "r")
        foundtitle = false
        while line = f.gets and !foundtitle do
          m = /<title>\s*(.*)\s*(<\/title>)?/.match(line)
          if m != nil
            title = m[1]
            foundtitle = true
          end
        end
        f.close
      end
      return title
    end

    def render(context)
      repos = Dir.entries(@@repodir).select {|entry| File.directory? File.join(@@repodir, entry) and !(entry == '.' || entry == '..') }
      repos = repos.sort
      if repos.empty?
        s = "<p>(No published repos found!)</p>"
      else
        s = "<br><h3>#{@text}</h3><br><table><tbody>"
        repos.each do |repo|
          title = _gettitle(File.join(@@repodir, repo, "index.html"))
          s += "<tr><th><a href='/" + repo + "/'>" + repo + "</a></th><th>#{title}</th></tr>"
        end
        s += "</tbody></table><br>"
      end
      return s
    end

  end

end

Liquid::Template.register_tag('repolist', Jekyll::RepoListTag)
