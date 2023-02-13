# frozen_string_literal: true

class ResultFile

  OUTPUT_FILE_NAME = 'results.csv'
  PATH = "#{File.dirname(__FILE__)}/../../#{OUTPUT_FILE_NAME}"

  def initialize
    delete if exists?
  end

  def with_csv_file(&block)
    CSV.open(PATH, "w") do |csv_file|
      block.call(csv_file)
    end
  end

  private

  def delete
    puts '-- FOUND PREVIOUS RESULT FILE --'
    puts '-- DELETING --'
    File.delete(PATH)
  end

  def exists?
    File.exists?(PATH)
  end

end
