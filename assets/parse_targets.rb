#!/usr/bin/ruby
# coding: utf-8

# Parse release targets for PWM allocations etc.
# (c) Jonathan Hudson
# Public domain or equivalent, e.g. [Zero Clause BSD](https://tldrlegal.com/license/bsd-0-clause-license)
#

require 'find'
require 'optparse'

def parse_output lines,name
  pwms=[]
  n = 0
  lines.each do |l|
    if l.match(/TIM_USE_(.._MOTOR|.._SERVO|OUTPUT_AUTO)/)
      deftims = l.split(',')
      alloc = deftims[3]
      allocs = alloc.split('|').collect{|z| z.strip.gsub('TIM_USE_','').gsub('OUTPUT_','')}
      allocs.each_with_index do |a,j|
        if a == 'AUTO'
          tm = deftims[0].match(/TIM(\d+)/)
          if !tm.nil?
            allocs[j] = "AUTO TIMER #{tm[1]}"
          end
        end
      end
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
    optd = "-D#{v}=1" #(v == defs[:name]) ? '' : "-D#{v}=1"
    lines = IO.readlines("|gcc #{optd} -E -o- /tmp/_target.c")
    res = parse_output lines,v
    opts << {name: v, pwms: res, dshot: dshot, skip: defs[:skip]}
  end
  opts
end

def write_out_md targets, branch
  now = Time.now.utc.strftime("%F")
  puts DATA.read % {:now => now, :branch => branch}
  puts

  targets.each do |t0|
    bname = t0[0][:name]
    t0.each_with_index do |t,i|
      if i == 0
	puts "## Board: #{bname}"
	puts
        if t[:skip]
	  puts "Board is not a release target."
        end
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

def get_targets all=false
  tlist=[]
  skip = nil
  Find.find('./src/main/target') do |f|
    if m= f.match(/target\/(\w+)\/CMakeLists\.txt/)
      dnam = m[1]
      next if dnam == "SITL"
      vset = {name: dnam, variants: [], skip: nil}
      File.open(f) do |fh|
        fh.each do |l|
          l.chomp!
          if m = l.match(/^target_\S{2,3}32\S+\((\w+)[\) ]/)
            bname = m[1]
            if dnam == bname
              skip = l.match(/SKIP_RELEASES/)
              vset[:skip] = !skip.nil?
            end
            vset[:variants] << bname
          end
        end
      end
      if all or skip.nil?
        tlist << vset  if vset[:name]
      end
    end
  end
  tlist
end

all = false
branch = "master"
ARGV.options do |opt|
  opt.banner = "Usage: parse_targets.rb [options] [root-dir]"
  opt.on('--branch=BRANCH', 'Use branch)') {|o| branch=o}
  opt.on('--all', 'Show all targets (not just release targets)') {all=true}
  opt.on('-?', "--help", "Show this message") {puts opt; exit}
  begin
    opt.parse!
  rescue
    puts opt ; exit
  end
end

root = (ARGV[0]||"inav")

Dir.chdir(root)
alltargets=[]
tlist=nil

system "git checkout #{branch} >/dev/null"

tlist = get_targets all

Dir.chdir("src/main/target")

tlist.each do |ti|
  res = build_target(ti)
  if res
    alltargets << res
  end
end

File.open("/tmp/allt.txt", "w") do |fh|
  fh.puts alltargets
  alltargets.each do |ta|
    fh.puts "==> #{ta}"
  end
end

write_out_md alltargets, branch

__END__
# INAV Boards, Targets and PWM allocations

It can be difficult for an aircraft builder to determine if a particular board / target will meet their needs.

In order to offer some guidance, the following list is machine generated from the files under `inav/source/main/target` to provide a list of the options offered by supported boards.

The usage is taken directly from the source code, the following interpretation is offered:

| Symbol | Interpretation |
| ------ | -------------- |
| AUTO | Automatic motor / servo allocation |
| MC_MOTOR | Multi-rotor motor |
| FW_MOTOR | Fixed wing motor |
| MC_SERVO | Multi-rotor servo |
| FW_SERVO | Fixed wing servo |
| LED      | LED strip  |
| PWM, ANY | Some other PWM function |

`AUTO` is used by INAV 7.0 and later. Hardware timer number is shown againt each `AUTO` line; a common function (`MOTOR`, `SERVO`) may be assigned by the user for a given timer number.

`MC_MOTOR`, `MC_SERVO`, `FW_MOTOR`, `FW_SERVO` are used prior to INAV 7.0.

See project [Cli](https://github.com/iNavFlight/inav/blob/master/docs/Cli.md) and [ESC and servo outputs](https://github.com/iNavFlight/inav/blob/master/docs/ESC%%20and%%20servo%%20outputs.md) documentation.

*List generated %{now} from the [INAV %{branch} branch](https://github.com/iNavFlight/inav/) by [`parse_targets.rb`](assets/parse_targets.rb). Some targets may not be available in official or prior releases.* **E&OE.**

You are strongly advised to check the board documentation as to the suitability of any particular board.

The configurations listed above are those supported by the INAV developers; other configurations may be possible with a custom target. The source tree contains other, unofficial targets that may (or not) work. A full report, including non-release targets may be generated with `parse_targets.rb --all`.

Note also that due to the complexity of output options available in INAV, dynamic resource allocation is not available. Paweł Spychalski has published a [video](https://www.youtube.com/watch?v=v4R-pnO4srU) explaining why resource allocation is not supported by INAV; [see also #1154](https://github.com/iNavFlight/inav/issues/1145)
