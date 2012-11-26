#!/usr/bin/env ruby

# file: dataisland.rb

require 'dynarex'
require 'rexle'
require 'rxfhelper'


class DataIsland

  attr_reader :html_doc

  # e.g. url = 'http://jamesrobertson.eu/index.html'
  #
  def initialize(location)

    buffer, typex = RXFHelper.read(location)
    @html_doc = Rexle.new(buffer)

    #exit
    @html_doc.xpath('//script[@class="dataisland"]').map(&:delete)
    @html_doc.xpath('//div[@datactl]').map(&:delete)

    @html_doc.root.element('body').attributes.delete :onload

    h = @html_doc.element('//object').attributes

    path = { url: -> {File.dirname(location)}, 
            file: -> {File.expand_path(File.dirname(location))}, 
             xml: -> {File.expand_path('.')}}    

    @location = path[typex].call

    @html_doc.xpath("//object[@type='text/xml']").each do |x|

      h = x.attributes

      tmp, type2 = RXFHelper.read(h[:data])
      
      location2 = case h[:data]
        when /^https?:\/\//
          h[:data]
        when /^\//
          @location + h[:data]
        else
          @location +'/' + h[:data]
      end

      dynarex = Dynarex.new location2
      
      records = (h[:order] and h[:order][/^desc|descending$/]) ? 
        dynarex.flat_records.reverse : dynarex.flat_records

      xpath = "//*[@datasrc='" + '#' + h[:id] + "']"

      @html_doc.xpath(xpath).each do |island|      
        render(records, x.attributes, island.element('//*[@datafld]'));
      end
    end
  end

  private

  def node_to_clone(element)

    parent = element.parent
    parentName = parent.name.downcase

    case parentName
      when 'body' 
        return nil
      when 'tr', 'li'
        return parent
      else
        return node_to_clone(parent)
    end
  end

  def render(flat_records, h, node)

    sort_by = h[:sort_by]
    range = h[:range]

    rec_orig = node_to_clone(node)    

    if rec_orig then

      # get a reference to each element containing the datafld attribute
      dest_nodes = {}
                
      if (h[:rows_per_page]) then

        pg = 1
        rpp = h[:rows_per_page].to_i
        range =  (pg > 1) ? 
          Range.new((pg - 1) * rpp,(((pg - 1) * rpp ) + rpp - 1)) : 
            Range.new(0,rpp - 1)
      end

      records = range.is_a?(Range) ? flat_records[range] : flat_records      

      if sort_by then
        if sort_by[/^-/].nil? then
          recs = records.sort_by {|record| record[sort_by] }        
        else 
          recs = records.sort_by {|record| record[sort_by[1..-1]] }.reverse
        end
      else 
        recs = records
      end

      recs.each do |record|

        rec = rec_orig.deep_clone
        a = rec.xpath('.//span[@class]|.//a[@class]')
        a.each do |e|
          r = e.attribute(:class)[/\{([^\}]+)\}$/,1]
          dest_nodes[r.to_sym] = e if r
        end
        
        rec.xpath('.//*[@datafld]').each do |e|
          dest_nodes[e.attribute(:datafld).downcase.to_sym] = e
        end

        dest_nodes.keys.each do |raw_field|

          field = raw_field.to_sym
          next if record[field].nil?

          case dest_nodes[field].name.downcase.to_sym
            
            when :span

              classx = dest_nodes[field].attributes[:class]

              if classx then

                if classx[/{#{field}/] then
                  val = record[field]
                  new_class = classx.sub(/\{[^\}]+\}/,val)
                  dest_nodes[field].attributes[:class] = new_class
                elsif
                  dest_nodes[field].text = record[field]
                end
              elsif
                dest_nodes[field].text = record[field]
              end
              
            when :a
              dest_nodes[field].attributes[:href] = record[field]
              classx = dest_nodes[field].attributes[:class]

              if classx and classx[/{#{field}/] then

                val = record[field]
                new_class = classx.sub(/\{[^\}]+\}/,val)
                dest_nodes[field].attributes[:class] = new_class
              end
            when :img
              dest_nodes[field].attributes[:src] = record[field]
          end
        end    

        rec_orig.parent.add(rec)
      end

      rec_orig.delete

    end
  end

end