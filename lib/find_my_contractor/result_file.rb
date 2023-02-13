# frozen_string_literal: true

class ResultFile

  OUTPUT_FILE_NAME = 'results.csv'
  PATH = "#{File.dirname(__FILE__)}/../../#{OUTPUT_FILE_NAME}"

  def initialize
    delete if exists?

    @file = CSV.open("cats.csv", "w")
  end

  def <<(...)
    @file.<<(...)
  end

  def close
    @file.close
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
