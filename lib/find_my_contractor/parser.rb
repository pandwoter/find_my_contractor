# frozen_string_literal: true

class Parser
  CONTENT_TABLE = "//table[@id='MainContent_gvZipCodeSearch']"
  DATA_FIELD = "//td[contains(@class, 'small-caps')]"

  def initialize(nokogiri_page)
    @nokogiri_page = nokogiri_page
  end

  def extract_info!
    nokogiri_page
      .xpath("#{CONTENT_TABLE}#{DATA_FIELD}")
      .map { _1.text }
  end

  private

  attr_reader :nokogiri_page
end
