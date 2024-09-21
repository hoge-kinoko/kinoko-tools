require "rake"

desc "テンプレからツール作成"
task :create_tool, [:tool_name] do |t, args|
  tool_name = args[:tool_name]
  if tool_name.nil? || tool_name.strip.empty?
    puts "ERROR: フォルダ名を指定してください"
    exit(1)
  end

  template_file_path = "templates/index.html"
  html_template = File.read(template_file_path)

  FileUtils.mkdir_p(tool_name)

  File.write("#{tool_name}/index.html", html_template)
  puts "SUCCESS: #{tool_name}/index.html"
end
