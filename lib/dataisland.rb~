#!/usr/bin/env ruby

require 'dynarex'
require 'rexle'

class DataIsland

  attr_reader :html_doc

  # e.g. url = 'http://jamesrobertson.eu/index.html'
  #
  def initialize(url)

    useragent = {'UserAgent' => 'Dynarex dataisland to HTML converter'}
    html_buffer = open(url, useragent).read
    @html_doc = Rexle.new html_buffer

    @html_doc.xpath('//script').map(&:delete)
    h = @html_doc.element('//object').attributes

    @location_href = File.dirname(url)

    @html_doc.xpath("//object[@type='text/xml']").each do |x|

      h = x.attributes
      dynarex = Dynarex.new @location_href + '/' + h[:data]

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
        return null
      when 'tr'
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

      records = flat_records[range] if range
      
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

        rec.xpath('//*[@datafld]').each do |e|
          dest_nodes[e.attribute(:datafld).downcase.to_sym] = e
        end

        dest_nodes.keys.each do |raw_field|

          field = raw_field.to_sym
          next if record[field].nil?

          case dest_nodes[field].name.downcase.to_sym
            when :span
              dest_nodes[field].text = record[field]
            when :a
              dest_nodes[field].attributes['href'] = record[field]
          end
        end    

        rec_orig.parent.add(rec)
      end

      rec_orig.delete

    end
  end

end
