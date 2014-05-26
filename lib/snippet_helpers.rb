module SnippetHelpers
  SOURCE_DIR = File.expand_path('../../source', __FILE__)

  private_constant :SOURCE_DIR

  class Snippet
    def initialize(name)
      @name = name
    end

    def exists?
      File.exists?(path)
    end

    def content
      File.read(path)
    end

    private

    attr_reader :name
  end

  class HtmlSnippet < Snippet
    def language_name
      'markup'
    end

    private

    def path
      filename = "_#{name.gsub(/-/, '_')}.html.erb"

      File.join(SOURCE_DIR, filename)
    end
  end

  class ScssSnippet < Snippet
    def language_name
      'scss'
    end

    private

    def path
      filename = "_#{name.gsub(/_/, '-')}.scss"

      File.join(SOURCE_DIR, 'stylesheets', 'refills', filename)
    end
  end

  class JavaScriptSnippet < Snippet
    def language_name
      'javascript'
    end

    private

    def path
      filename = "#{name.gsub(/-/, '_')}.js"

      File.join(SOURCE_DIR, 'javascripts', 'refills', filename)
    end
  end

  def code_for(snippet_name)
    partial 'code', locals: { snippets: snippets_for(snippet_name) }
  end

  def snippets_for(name)
    snippets(name).map { |snippet| markup_for(snippet) }.join("\n")
  end

  def snippets(name)
    [HtmlSnippet, ScssSnippet, JavaScriptSnippet].map do |snippet_factory|
      snippet_factory.new(name)
    end
  end

  def markup_for(snippet)
    if snippet.exists?
      partial 'snippet', locals: {
        snippet: snippet.content,
        language: snippet.language_name,
      }
    end
  end
end
