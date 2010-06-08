TAGS = [:html, :head, :title, :base, :meta, :link, :style, :script, :noscript, :body, :div, :p, :ul, :ol, :li, :dl, :dt, :dd,
        :address, :hr, :pre, :blockquote, :ins, :del, :a, :span, :bdo, :br, :em, :strong, :dfn, :code, :samp, :kbd, :var, :cite, :abbr,
        :acronym, :q, :sub, :sup, :tt, :i, :b, :big, :small, :object, :param, :img, :map, :area, :form, :label, :input, :select, :optgroup,
        :option, :textarea, :fieldset, :legend, :button, :table, :caption, :colgroup, :col, :thead, :tfoot, :tbody, :tr,
        :th, :td, :h1, :h2, :h3, :h4, :h5, :h6,
]

OUTPUT_EVALS = [:javascript_include_tag, :stylesheet_link_tag, :link_to, :check_box_tag, :text_field_tag, :password_field_tag,
                :submit_tag, :text_area_tag, :hidden_field_tag, :radio_button_tag, :select_tag ]
NON_OUTPUT_EVALS = [:if, :elsif, :else, :for,]

def convert_tags(l)
  converted = l.gsub(/^(\s*)(#{TAGS.join('|')})(\.\w+)?(!?)(\s+)/) do
    out = "#{$1}%#{$2}"
    whitespace = $5.dup

    if $4 == '!'
      classes = $3[1..-1].split('.')
      id = classes.pop
      classes.each { |c| out += ".#{c}" }
      out += "##{id}"
    else
      out += "#{$3}"
    end
    "#{out}#{whitespace}"
  end

  md = converted.match(/(\s*)(%\S+)\s*('|")(.*?)\3\s*$/)
  converted = "#{md[1]}#{md[2]} #{md[4]}" if md

  converted
end

def convert(l)
  l = convert_tags(l)

  # remove trailing do's
  l.gsub!(/\s+do\s*$/, '')

  # convert attrs
  l.gsub!(/(\s+%\S*)\s(.*=>.*)/, '\1{\2}')

  # stuff with - or = at the beginning of the lines
  l.gsub!(/^(\s*)(#{NON_OUTPUT_EVALS.join('|')})(.*)/, '\1-\2\3')
  l.gsub!(/^(\s*)(#{OUTPUT_EVALS.join('|')})(.*)/, '\1=\2\3')

  # convert text
  l.gsub!(/^(\s*)text /, '\1= ')
  l
end


def convert_markaby(lines)
  output_lines = []

  lines.each_with_index do |line, idx|

    next if line.match(/^\s*end\s*$/)

    if line.match(/^\s*#/)
      # comments
      haml = line.gsub(/^(\s*)#/, '\1-#')

    else
      haml = convert(line.dup)

      # put a non-output eval in front of everything else
      if haml == line
        haml.gsub!(/^(\s*)(.*)$/, '\1-\2')
      end
    end

    unless haml.match(/^\s*$/)

      if haml.match(/^.* (if|unless)\b/)

        match_data = haml.match(/^(\s*)(.*) ((if|unless).*)$/)

        output_lines << {
          :line_no => idx,
          :original => line,
          :haml => match_data[1] + '-' + match_data[3]
        }

        output_lines << {
          :line_no => idx,
          :original => line,
          :haml => '  ' + match_data[1] + match_data[2]
        }
      else
        output_lines << {
          :line_no => idx,
          :original => line,
          :haml => haml,
        }
      end
    end
  end
  output_lines
end

def convert_file(fn)

  markaby_lines = []

  File.open(fn) do |ifp|
    ifp.each_line do |line|

      # put {...} blocks on their own line
      match_data = line.match(/(\s*)(.*)\{\s*(.*?)\s*\}\s*$/)
      if match_data
        markaby_lines << match_data[1] + match_data[2]
        markaby_lines << '  ' + match_data[1] + match_data[3]
      else
        markaby_lines << line.dup
      end
    end
  end

  convert_markaby(markaby_lines)
end

def convert_all_files
  Dir.glob('/Users/alon/Projects/freehub/app/views/**/*mab').each do |mab_fn|
    haml_fn = mab_fn.gsub(/\.mab$/, '.haml')
    puts haml_fn

    lines = convert_file(mab_fn)

    File.open(haml_fn, 'w') do |ofp|
      original_source = []
      lines.each do |l|
        ofp.puts(l[:haml])
  #      ofp.puts sprintf("-# %3d: %s", l[:line_no], l[:original])
        original_source << sprintf("-# %3d: %s", l[:line_no], l[:original])
      end

      ofp.puts()
      ofp.puts("-# Original:")
      ofp.puts()
      ofp.puts(original_source)

    end
  end
end
#
#s = <<EOF
#add text here/*.
#EOF
#haml = convert_markaby(s.split("\n"))
#haml.each do |l|
#  puts l[:haml]
#end
convert_all_files