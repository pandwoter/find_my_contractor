# frozen_string_literal: true

class Parser

  CONTENT_TABLE_PATH = "//table[@id='MainContent_gvZipCodeSearch']"
  ITEM_PATH = "//tr[contains(@class, 'Item')]"
  DATA_PATH = ".//td[contains(@class, 'small-caps')]"

  def initialize(nokogiri_page)
    @nokogiri_page = nokogiri_page
  end

  def extract_info!
    nokogiri_page.xpath("#{CONTENT_TABLE_PATH}#{ITEM_PATH}").map do |item|
      item.xpath(DATA_PATH).map { _1.text }
    end
  end

  private

  attr_reader :nokogiri_page

end
