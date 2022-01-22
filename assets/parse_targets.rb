#!/usr/bin/ruby
# coding: utf-8

# Parse release targets for PWM allocations etc.
# (c) Jonathan Hudson
# Public domain or equivalent, e.g. [Zero Clause BSD](https://tldrlegal.com/license/bsd-0-clause-license)
#

require 'find'

def parse_output lines
  pwms=[]
  n = 0
  lines.each do |l|
    if l.match(/TIM_USE_.._(MOTOR|SERVO)/)
      deftims = l.split(',')
      alloc = deftims[3]
      allocs = alloc.split('|').collect{|z| z.strip.gsub('TIM_USE_','')}
      pwms << allocs.join(', ')
      n += 1
    end
  end
  pwms
end

def build_target defs
  opts=[]
  File.open(File.join(defs[:name], "target.c")) do |f0|
    File.open("/tmp/_target.c","w") do |f1|
      f0.each do |l|
	next if l.match(/#include/)
	f1.puts l
      end
    end
  end
  dshot=false
  File.open(File.join(defs[:name], "target.h")) do |f0|
    f0.each do |l|
      if l.match(/^\s*#define\s+USE_DSHOT/)
	dshot = true
      end
    end
  end

  defs[:variants].each do |v|
    optd = (v == defs[:name]) ? '' : "-D#{v}=1"
    lines = IO.readlines("|gcc #{optd} -E -o- /tmp/_target.c")
    res = parse_output lines
    opts << {name: v, pwms: res, dshot: dshot}
  end
  opts
end

def write_out_md targets
  now = Time.now.utc.strftime("%F")
  puts DATA.read % now
  puts

  targets.each do |t0|
    bname = t0[0][:name]
    t0.each_with_index do |t,i|
      if i == 0
	puts "## Board: #{bname}"
	puts
        if t[:dshot]
	  puts "Board is DSHOT enabled."
	else
	  puts "Board is not DSHOT enabled."
	end
        puts
      end
      puts "### Target: #{t[:name]}"
      puts ""
      puts "| PWM | Usage |"
      puts "| --- | ----- |"
      t[:pwms].each_with_index do |p,n|
	puts "| #{n+1} | #{p} |"
      end
      puts
    end
  end
end

abort "parse_targets.rb [dir]" if ARGV[0] and ARGV[0].match?(/\-h/)

root = (ARGV[0]||"inav")
Dir.chdir(root)
alltargets=[]

tlist=[]

Dir.chdir("build") || abort("Need build directory")

lname=""
vset={}
IO.popen("ninja -t query release") do |pp|
  pp.each do |l|
    next unless m=l.match(/src\/main\/target\/(\S+?)\/(\S+)/)
    bname=m[1]
    vname=m[2]
    if bname != lname
      lname = bname
      unless vset.empty?
        tlist << vset
      end
      vset={:name => bname, :variants => [bname]}
    end
    if vname != bname
      vset[:variants] << vname
    end
  end
  unless vset.empty?
    tlist << vset
  end
end

Dir.chdir("../src/main/target")

tlist.each do |ti|
  res = build_target(ti)
  if res
    alltargets << res
  end
end

#puts alltargets
#alltargets.each do |ta|
#  puts "==> #{ta}"
#end

write_out_md alltargets

__END__
# Inav Boards, Targets and PWM allocations

It can be difficult for an aircraft builder to determine if a particular board / target will meet their needs.

In order to offer some guidance, the following list is machine generated from the files under `inav/source/main/target` to provide a list of the options offered by supported boards.

The usage is taken directly from the source code, the following interpretation is offered:

| Symbol | Interpretation |
| ------ | -------------- |
| MC_MOTOR | Multi-rotor motor |
| FW_MOTOR | Fixed wing motor |
| MC_SERVO | Multi-rotor servo |
| FW_SERVO | Fixed wing servo |
| LED      | LED strip  |
| PWM, ANY | Some other PWM function |

*List generated %s from the [inav master branch](https://github.com/iNavFlight/inav/) by [`parse_targets.rb`](http://seyrsnys.myzen.co.uk/parse_targets.rb). Some targets may not be available in official or prior releases.* **E&OE.**

You are strongly advised to check the board documentation as to the suitability of any particular board.

The configurations listed above are those supported by the inav developers; other configurations may be possible with a custom target. The source tree contains other, unofficial targets that may (or not) work.

Note also that due to the complexity of output options available in inav, dynamic resource allocation is not available. Paweł Spychalski has published a [video](https://www.youtube.com/watch?v=v4R-pnO4srU) explaining why resource allocation is not supported by inav; [see also #1154](https://github.com/iNavFlight/inav/issues/1145)
