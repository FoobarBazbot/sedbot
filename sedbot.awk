#!/usr/bin/gawk -f
function lineout(old,new,nouser) {
  if(old!=new) print (nouser?"":"<" user "> ") new >outfile; close(outfile);
}
BEGIN {
 outfile=( ENVIRON["HOME"] "/sedbotirc/irc.sylnt.us/#soylent/in");
 line_re="^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2} <([^>]*)> (.*)$";
 blag_re="world wide web|internet|interweb|intersphere|intertubes|interblag|blogosphere|blagonet|blagosphere|blagoblag|webnet|webweb";
 blag_n=split(blag_re,blag_word,/\|/);
 srand();
}
$0 ~ line_re {
  user=gensub(line_re,"\\1",1);
  line=gensub(/\001ACTION (.*)\001/,"\\1",1,gensub(line_re,"\\2",1));
  update_line=1;
}
line ~ /^s\/(([^\/]|\\\/)+)\/(([^/]|\\\/)*)$/ {
  update_line=0;
  lineout("","\001ACTION hands " user " a /\001",1);
}
line ~ /^s/ {
  sep=substr(line,2,1);
  if(sep ~ /[\.\^\$\[\]\|\+\*\(\)\{\}]/) sep="\\"sep;
  desep="\\\\("sep")";
  s_re = "^s" sep "(([^" sep "]|\\\\" sep ")+)" sep "(([^" sep "]|\\\\" sep ")*)" sep "(([0-9]*[1-9][0-9]*|g)|([iI]))*$";
  if(line ~ s_re) {
    update_line=0;
    search=gensub(desep,"\\1","g",gensub(s_re,"\\1", 1, line));
    repl  =gensub(desep,"\\1","g",gensub(s_re,"\\3", 1, line));
    count =gensub(desep,"\\1","g",gensub(s_re,"\\6", 1, line));
    casein=gensub(desep,"\\1","g",gensub(s_re,"\\7", 1, line));
    print user ": " line "\n" s_re "\n" search "\n" repl "\n" count "\n" casein >"/dev/stderr";
    if(!count) count=1;
    if(casein) IGNORECASE=1; else IGNORECASE=0;
    newline=gensub(search,repl,count,last_line[user]);
    lineout(last_line[user],gensub(blag_re,blag_word[int(rand()*blag_n+1)],"g",newline));
  }
}
line ~ /^[sS][eE][dD][bB][oO][tT]/ {lineout("","\001ACTION is a 40-line awk script, https://github.com/FoobarBazbot/sedbot\001",1);}
update_line {last_line[user]=line;}
