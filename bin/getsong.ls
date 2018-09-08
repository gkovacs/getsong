require! {
  process
  fs
}

{exec, mkdir, ls, rm, mv} = require 'shelljs'

main = ->
  title = process.argv[2]
  author = process.argv[3]
  if not title?
    console.log 'need to provide a search query or url'
    return
  if author?
    query = title + ' ' + author
  else
    query = title
  if fs.existsSync('getsongtmp')
    rm '-r', 'getsongtmp'
  mkdir 'getsongtmp'
  process.chdir 'getsongtmp'
  exec "you-get --itag=18 '#{query}'"
  outfile = ls('*.mp4').stdout.trim()
  basename = outfile.substr(0, outfile.length - 4)
  mv outfile, 'tmp.mp4'
  metadata_options = "-metadata title='#{basename}' -metadata artist='Unknown'"
  if author?
    metadata_options = "-metadata title='#{title}' -metadata artist='#{author}'"
  exec "ffmpeg -i tmp.mp4 -acodec copy -vn #{metadata_options} audio.m4a"
  newname = basename + '.m4a'
  mv 'audio.m4a', '../' + newname
  process.chdir '..'
  rm '-r', 'getsongtmp'
  console.log newname

main()
