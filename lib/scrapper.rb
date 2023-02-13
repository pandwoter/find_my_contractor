$:.unshift File.dirname(__FILE__)

require 'find_my_contractor/result_file'
require 'find_my_contractor/parser'
require 'find_my_contractor/page_downloader'

require 'yaml'
require 'nokogiri'
require 'HTTParty'
require 'ruby-progressbar'
require 'csv'

ZIP_CODES = YAML.safe_load(
  IO.read(
    "#{File.dirname(__FILE__)}/find_my_contractor/zip_codes.yml"
  )
).freeze

zips_count = ZIP_CODES.values.inject(0) { |acc, curr| acc += curr.size; acc }

PROGRESS_BAR = ProgressBar.create(title: "Zips processed", total: zips_count)

result_file = ResultFile.new
page_downloader = PageDownloader.new
HEADERS = ['License #', 'Name',	'Address', 'City', 'Zip', 'Phone #']

result_file << HEADERS

puts 'Starting process!'
ZIP_CODES.each do |state_name, zip_code|
  puts "Processing #{state_name}, #{zip_code}"
  nokogiri_page = page_downloader.download(zip_code)
  extracted_info = Parser.new(nokogiri_page).extract_info!
  result_file << extracted_info
  PROGRESS_BAR.increment
rescue StandardError => e
  puts "ERROR OCCURED #{e}"
  puts "Flushing result file..."
  raise e
ensure
  result_file.close
end
