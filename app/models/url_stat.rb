require 'pry'

class UrlStat < ActiveRecord::Base
  has_many :payloads
  belongs_to :source

  attr_reader :source,
              :full_url,
              :result,
              :payloads

  def initialize(source, relative_path)
    @source = source
    @full_url = "#{source.rooturl}/#{relative_path}"
  end

  def verify_path_exists?
    if @source.payloads.find_by_url(full_url)
      true
    else
      false
    end
  end

  def longest_response_time
    if @source.payloads.find_by_url(full_url)
      @source.payloads.maximum(:responded_in)
    end
  end

  def shortest_response_time
    if @source.payloads.find_by_url(full_url)
      @source.payloads.minimum(:responded_in)
    end
  end

  def average_response_time
    if @source.payloads.find_by_url(full_url)
      @source.payloads.average(:responded_in)
    end
  end

  def request_types
    if @source.payloads.find_by_url(full_url)
      grouped_request_types = @source.payloads.group_by { |payload| payload[:request_type] }
      sorted_urls = grouped_request_types.map { |request_type, payloads| [request_type, payloads.length] }
      sorted_urls.sort_by { |pair| pair[1] }.reverse
    end
  end

  def popular_referrers
    if @source.payloads.find_by_url(full_url)
      grouped_referrers = @source.payloads.group_by { |payload| payload[:referred_by] }
      sorted_urls = grouped_referrers.map { |referrer, payloads| [referrer, payloads.length] }
      sorted_urls.sort_by { |pair| pair[1] }.reverse
    end
  end

end
