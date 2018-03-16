#main

require "fileutils"

LIB = "#{ENV['HOME']}/bin/src/move/lib"
STACK = "#{LIB}/filestack"
FileUtils.touch STACK

filestack = []

File.open(STACK) do |fin|
  while line = fin.gets
    filestack << line.chomp
  end
end

case __FILE__
when /u/
  if File.exist? ARGV[0]
    FileUtils.mv ARGV[0], LIB
    filestack << File.basename(ARGV[0])
  else
    puts "#{ARGV[0]}: does not exist"
    exit(1)
  end
when /o/
  if ARGV[0] =~ /^-(l|-list)$/
    puts filestack
    exit(0)
  end
  if not filestack.empty?
    FileUtils.mv "#{LIB}/#{filestack.pop}", "."
  else
    puts "File stack is empty. No file to pop"
    exit(2)
  end
end

File.open(STACK, "w") do |fout|
  fout.puts filestack
end
