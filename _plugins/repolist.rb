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
        s = "<table><thead><tr><th>Repo Name</th><th>Description</th></tr></thead><tbody>"
        repos.each do |repo|
          title = ""
          indexfiles = ['index.html', 'index.htm']
          indexfiles.each do |x|
            title =  _getFile.join(@@repodir, repo, x)
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
