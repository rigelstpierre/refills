module SnippetHelpers
  SOURCE_DIR = File.expand_path('../../source', __FILE__)

  class Snippet
    def initialize(name)
      @name = name
    end

    private

    attr_reader :name
  end

  class HtmlSnippet < Snippet
    def path
      snippet_filename = "_#{name.gsub(/-/, '_')}.html.erb"

      File.join(SOURCE_DIR, snippet_filename)
    end

    def language_name
      'markup'
    end
  end

  class ScssSnippet < Snippet
    def path
      snippet_filename = "_#{name.gsub(/_/, '-')}.scss"

      File.join(SOURCE_DIR, 'stylesheets', 'refills', snippet_filename)
    end

    def language_name
      'scss'
    end
  end

  class JavaScriptSnippet < Snippet
    def path
      snippet_filename = "#{name.gsub(/-/, '_')}.js"

      File.join(SOURCE_DIR, 'javascripts', 'refills', snippet_filename)
    end

    def language_name
      'javascript'
    end
  end

  def code_for(snippet_name)
    partial 'code', locals: { snippets: snippets_for(snippet_name) }
  end

  private_constant :SOURCE_DIR

  private

  def snippets_for(name)
    snippets(name).map do |snippet|
      if File.exists?(snippet.path)
        partial 'snippet', locals: {
          snippet: File.read(snippet.path),
          language: snippet.language_name,
        }
      end
    end.join("\n")
  end

  def snippets(name)
    [HtmlSnippet, ScssSnippet, JavaScriptSnippet].map do |snippet_factory|
      snippet_factory.new(name)
    end
  end
end
