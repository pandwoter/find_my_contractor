$:.unshift File.dirname(__FILE__)

require 'find_my_contractor/result_file'
require 'find_my_contractor/parser'
require 'find_my_contractor/page_downloader'

require 'yaml'
require 'nokogiri'
require 'httparty'
require 'ruby-progressbar'
require 'csv'

ZIP_CODES = YAML.safe_load(
  IO.read(
    "#{File.dirname(__FILE__)}/find_my_contractor/zip_codes.yml"
  )
).freeze

PROGRESS_BAR = ProgressBar.create(title: "Zips processed", total: ZIP_CODES['codes'].size)

result_file = ResultFile.new
page_downloader = PageDownloader.new
HEADERS = ['License #', 'Name',	'Address', 'City', 'Zip', 'Phone #']

result_file.with_csv_file do |file|
  file << HEADERS

  PROGRESS_BAR.log('STARTING PROCESS!')
  ZIP_CODES['codes'].each do |code|
    PROGRESS_BAR.log("PARSING #{code}")
    nokogiri_page = page_downloader.download(code)
    extracted_info = Parser.new(nokogiri_page).extract_info!

    unless extracted_info.empty?
      PROGRESS_BAR.log("FOUND #{extracted_info.size} records for #{code}")
      extracted_info.each { |item| file << item }
    end

    PROGRESS_BAR.increment
  rescue StandardError => e
    puts "ERROR OCCURED #{e}"
    raise e
  end
end
