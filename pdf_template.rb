#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'cairo'
require 'pango'
require 'poppler'

require 'yaml'
require 'erb'

class PdfTemplate
  def initialize(yaml_path)
    @yaml_path = yaml_path
  end

  def publish!
    # This is an example code for drawing data.
    draw_text(25, 25, 70, 'Helvetica,bold 9') { data['example'] }

    context.show_page
  end

  private

  # 1pt = 1/72inch, 1inch = 2.54cm = 25.4mm
  PT_PER_MM = 1 / 25.4 * 72

  def draw_text(x, y, w, fontdesc, align = :left)
    context.save do
      layout = context.create_pango_layout

      layout.text = yield.to_s
      layout.font_description = Pango::FontDescription.new(fontdesc)
      layout.width = w * PT_PER_MM * Pango::SCALE
      layout.spacing = 1 * PT_PER_MM * Pango::SCALE
      layout.alignment = align

      context.move_to x * PT_PER_MM, y * PT_PER_MM
      context.show_pango_layout(layout)
    end
  end

  def context
    @context ||= begin
      page = template_doc.get_page(0)
      size = page.size

      surface = Cairo::PDFSurface.new(output_path, *size)
      context = Cairo::Context.new(surface)

      context.save do
        context.render_poppler_page(page)
      end

      context
    end
  end

  def output_path
    File.expand_path("#{File.basename(@yaml_path, '.*')}.pdf")
  end

  def template_doc
    Poppler::Document.new(template_url)
  end

  def template_url
    GLib.filename_to_uri(template_path)
  end

  def template_path
    File.expand_path(data['template'], File.dirname(@yaml_path))
  end

  def data
    @data ||= YAML.safe_load(File.read(@yaml_path))
  end
end

PdfTemplate.new(ARGV.shift).publish!
