# frozen_string_literal: true

class ResultFile

  OUTPUT_FILE_NAME = 'results.csv'
  PATH = "#{File.dirname(__FILE__)}/../../#{OUTPUT_FILE_NAME}"

  def with_csv_file(&block)
    CSV.open(PATH, "w") do |csv_file|
      block.call(csv_file)
    end
  end

end
