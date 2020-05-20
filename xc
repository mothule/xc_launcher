#!/usr/bin/env ruby
require 'open3'

VERSION = '0.0.1'
APP_NAME = 'xc'

def main(dry_mode: false)
  if %w[-h --help].any? { |cmd| (ARGV&.first || "") == cmd }
    help
  elsif %w[-v --version].any? { |cmd| (ARGV&.first || "") == cmd }
    version
  end

  target_dir = Dir.pwd
  unless ARGV.first.nil?
    dir = ARGV.first
    error "Not found specified directory path. #{dir}" unless Dir.exist?(dir)
    target_dir = File.expand_path(dir, Dir.pwd)
    error "Not found directory. path: #{target_dir}" unless Dir.exist?(target_dir)
  end

  paths = collect_paths_of_xcode_proj_or_ws(dir: target_dir)
  error 'Not found any Xcode project or workspace.' if paths.empty?
  target_path = path_of_xcodeproj_or_xcworkspace(path: paths.first)

  # puts "target_dir: #{target_dir}"
  # puts "target_path: #{target_path}"

  open_xcode(target_path, dry_mode: dry_mode)
  exit 0
end


def help
  string = <<"EOS"
This command will open xcodeproj or xcworkspace via Xcode.app.

Example usage: 
  #{APP_NAME} -h                       This help
  #{APP_NAME} -v 
  #{APP_NAME} DIRECTORY_PATH           Open first hit xcodeproj or xcworkspace in DIRECTORY_PATH
  #{APP_NAME}                          Open first hit xcodeproj or xcworkspace in current directory
EOS
  puts string
  exit 0
end

def version
  puts "#{APP_NAME} #{VERSION}"
  exit 0
end

def error(str, do_exit: true)
  puts str
  exit -1 if do_exit
end

def open_xcode(path, dry_mode: false)
  if dry_mode
    puts "open #{path} (dry mode)"
  else
    puts "open #{path}"
    stdout, stderr, status = Open3.capture3("open #{path}")
    unless status.success?
      error stderr
    end
  end
end

def collect_paths_of_xcode_proj_or_ws(dir: nil)
  dir = dir || Dir.pwd
  paths = Dir.glob(%w[*.xcodeproj *.xcworkspace], base: dir)
             .map { |name| File.expand_path(name, dir) }
  paths.tap {|paths| error 'Not found any Xcode project or workspace.' if paths.empty? }
end

def path_of_xcodeproj_or_xcworkspace(path:)
  name = File.basename(path, '.*')
  dir = File.dirname(path)

  xcworkspace_path = File.join(dir, name + '.xcworkspace')
  return xcworkspace_path if File.exist?(xcworkspace_path)
  xcodeproj_path = File.join(dir, name + '.xcodeproj')
  return xcodeproj_path if File.exist?(xcodeproj_path)
end

main(dry_mode: false)
