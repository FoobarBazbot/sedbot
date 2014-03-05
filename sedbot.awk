#!/usr/bin/gawk -f
function lineout(old,new,nouser) {
  if(old!=new) print (nouser?"":"<" user "> ") new >outfile; close(outfile);
}
BEGIN {
  outfile=( ENVIRON["HOME"] "/sedbotirc/irc.sylnt.us/#soylent/in");
  line_re="^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2} <([^>]*)> (.*)$";
  blag_re="world wide web|internet|interweb|intersphere|intertubes|interblag|blogosphere|blagonet|blagosphere|blagoblag|webnet|webweb";
  blag_n=split(blag_re,blag_word,/\|/);
  slash_n=split("\1ACTION offers # a /\1|\1ACTION tosses a / to #\1|#, did you know there's three slashes in a proper s/// command?|\1ACTION hurls a / at #!\1|#, you bloody moron, get the syntax straight or get off this channel!!\n\1ACTION peppers # with /s\1",slash_msg,"|");
  srand();
}
$0 ~ line_re {
  user=gensub(line_re,"\\1",1);
  line=gensub(/\001ACTION (.*)\001/,"\\1",1,gensub(line_re,"\\2",1));
  update_line=1;
}
line ~ /^s\/(([^\/\\]|\\.)+)\/(([^\/\\]|\\.)*)[[:space:]]*$/ {
  update_line=0;
  lineout("",gensub("#",user,"g",slash_msg[int(rand()*rand()*slash_n+1)]),1);
}
line ~ /^s/ {
  sep=substr(line,2,1);
  if(sep ~ /[\.\^\$\[\]\|\+\*\(\)\{\}]/) sep="\\"sep;
  desep="\\\\("sep")";
  s_re = "^s" sep "(([^" sep "\\\\]|\\\\.)+)" sep "(([^" sep "\\\\]|\\\\.)*)" sep "(([0-9]*[1-9][0-9]*|g)|([iI]))*[[:space:]]*$";
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
line ~ /^[sS][eE][dD][bB][oO][tT]/ {lineout("","\001ACTION is a 41-line awk script, https://github.com/FoobarBazbot/sedbot\001",1);}
update_line {last_line[user]=line;}
