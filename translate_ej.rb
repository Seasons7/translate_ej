#!/opt/local/bin/ruby -Ku

require 'rubygems'
require 'mechanize'
require 'scrapi'
require 'pp'

# translate engine
URL = 'http://translation.infoseek.co.jp/?ac=Text&lng=en'

# ========================================================
# translate string
# ========================================================
# 
# ========================================================
def translate sentence

  agent = WWW::Mechanize.new
  agent.user_agent_alias = 'Mac Safari'
  agent.max_history = 1
  agent.get( URL )

  #=> submit translate sentence
  agent.page.forms_with(:name => "text").each do |f|
    f.field_with(:name => "original").value = sentence
  end
  button = agent.page.form_with(:name => "text").button_with(:name => "submit")
  agent.page.form_with(:name => "text").submit( button )

  #=> get submit result
  html = agent.page.body
  links = Scraper.define do
      process 'textarea' , "texts[]" => :text
      result :texts
  end.scrape( html , :parser_options => {:char_encoding=>'utf8'} )

  links.collect!{|i| i.gsub!(/\n/,"") }
  en,jp = links
  printf( "#{en} => #{jp}\n" )

end

if $0 == __FILE__

  exit 1 unless ARGV.size > 0
  translate ARGV.shift

end
