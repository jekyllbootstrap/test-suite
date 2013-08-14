# Full path to mock blog directory
JBSourcePath = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'jekyll-bootstrap'))
SampleSitePath = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '_source'))
CompilePath = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '_site'))

def compile
  Jekyll::Site.new(Jekyll.configuration({
     "source"      => @source,
     "destination" => CompilePath
   })).process
end

def make_config(data)
  path = File.join(@source, "_config.yml")
  File.open(path, "w+") { |file|
    file.puts data.to_yaml
  }
end

def make_file(opts)
  path = File.join(@source, opts[:path])
  FileUtils.mkdir_p(File.dirname(path))

  data = opts[:data] || {}
  if data['categories']
    data['categories'] = data['categories'].to_s.split(',').map(&:strip)
  end
  if data['tags']
    data['tags'] = data['tags'].to_s.split(',').map(&:strip)
    puts "tags #{data['tags']}"
  end
  data.delete('layout') if data['layout'].to_s.strip.empty?

  metadata = data.empty? ? '' : data.to_yaml.to_s + "\n---\n"

  File.open(path, "w+") { |file|
    file.puts <<-TEXT
#{ metadata }

#{ opts[:body] }
TEXT
  }
end

def get_compiled_file(path)
  FileUtils.cd(CompilePath) {
    File.open(path, 'r:UTF-8') { |f| 
      return f.read }
  }
end

def this_compiled_file
  unless @filepath
    raise "Your step definition is trying to reference 'this' compiled file" +
          " but you haven't provided a file reference." +
          " This probably just means using 'my compiled site should have the file \"sample.md\"' first."
  end
  get_compiled_file(@filepath)
end

Before do
  FileUtils.remove_dir(CompilePath,1) if Dir.exists? CompilePath
  Dir.mkdir CompilePath

  FileUtils.remove_dir(SampleSitePath,1) if Dir.exists? SampleSitePath
  Dir.mkdir SampleSitePath
end

After do
  #FileUtils.remove_dir(CompilePath,1) if Dir.exists? CompilePath
end