#!/usr/bin/env ruby 
require 'haml'
require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

module HargraveInfo
    class HTMLRenderer < Redcarpet::Render::HTML 
        include Rouge::Plugins::Redcarpet
    end
end

module Haml::Filters::Redcarpet 
    include Haml::Filters::Base

    def render(text)
        render_config = {
            filter_html:    true
        }

        rc_exts = {
            smarty:             true,
            tables:             true,
            autolink:           true,
            strikethrough:      true,
            superscript:        true,
            hightlight:         true,
            footnotes:          true,
            fenced_code_blocks: true 
        }
        
        renderer  = HargraveInfo::HTMLRenderer.new(render_config)
        redcarpet = Redcarpet::Markdown.new(renderer, rc_exts)

        redcarpet.render(text)
    end 
end 

begin
    engine = Haml::Engine.new(ARGF.read)
    STDOUT.write(engine.render)
end
