#!/usr/bin/env ruby -w

class String
  def starts_with?(prefix)
    prefix.respond_to?(:to_str) && self[0, prefix.length] == prefix
  end
end

HEADER_REGEX = /^#import\s+["<](.*)[">]/

BUILD_DIR = `pwd`
BUILD_CMD = 'xcodebuild -workspace Omnibus.xcworkspace -scheme myChevrolet -configuration "Debug" build > /tmp/import_minimizer-build.log 2>&1'

FILE_TO_MINIMIZE = ARGV.shift
unless File.readable?(FILE_TO_MINIMIZE)
  puts "Usage: import_minimizer.rb FileToMinimize.m"
  puts "\t file path must be relative to #{BUILD_DIR} (or an absolute path)"
  exit 1
end

lines        = open(FILE_TO_MINIMIZE, "r").each_line.to_a
line_no      = 0
counter      = 0

puts "testing #{FILE_TO_MINIMIZE}"
printf ". checking for duplicates"
seen_headers = []
while line_no < lines.length
  line = lines[line_no]
  line_no += 1
  
  next unless line.starts_with? "#import "
  
  header = line[HEADER_REGEX, 1]
  
  if seen_headers.include?(header)
    lines.delete_at(line_no-1)
    counter += 1
  end
  
  seen_headers << header
end
puts " - found: #{counter}"

open(FILE_TO_MINIMIZE, "w+") { |f| f.write(lines.join) }
exit 0

line_no = 0
while line_no < lines.length
  line = lines[line_no]
  
  unless line.starts_with? "#import "
    line_no += 1
    next
  end
  
  orig_line = line
  header = line[HEADER_REGEX, 1]
  
  printf ". checking import: #{header}"
  
  lines[line_no] = "// #{orig_line.strip}  // -- not needed\n"
  open(FILE_TO_MINIMIZE, "w+") { |f| f.write(lines.join) }
  `#{BUILD_CMD}`
  if ($?.exitstatus != 0)
    lines[line_no] = orig_line
    puts "  -  needed"
  else
    puts "  -  NOT needed"
    counter += 1
  end
  
  line_no += 1
end
puts "\nFound #{counter} #import's that are not needed / duplicates"

open(FILE_TO_MINIMIZE, "w+") { |f| f.write(lines.join) }

exit 0