require! {
  process
  fs
}

{exec, mkdir, ls, rm, mv} = require 'shelljs'

query = process.argv[2]
if fs.existsSync('getsongtmp')
  rm '-r', 'getsongtmp'
mkdir 'getsongtmp'
process.chdir 'getsongtmp'
exec "you-get --itag=18 '#{query}'"
outfile = ls('*.mp4').stdout.trim()
mv outfile, 'tmp.mp4'
exec "ffmpeg -i tmp.mp4 -acodec copy -vn audio.m4a"
newname = outfile.substr(0, outfile.length - 4) + '.m4a'
mv 'audio.m4a', '../' + newname
process.chdir '..'
rm '-r', 'getsongtmp'
console.log newname
