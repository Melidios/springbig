require 'csv'
class ProcessCsvJob < ApplicationJob
  attr_reader :csv, :file_name

  def self.call(csv, file_name)
    new(csv, file_name).perform
  end

  def initialize(csv, file_name)
    @csv = csv
    @file_name = file_name
  end

  def perform
    import_and_return_errors
    @error_arr
  end

  private

  def import_and_return_errors
    @error_arr = []
    CSV.foreach(csv.path, headers: true).with_index(1) do |r, i|
      error_hash = { row: i }
      data_hash = r.to_h.merge!(file_name: file_name)
      sanitize_phone(data_hash, @error_arr, error_hash)
      if @error_arr.empty?
        process_new(data_hash, error_hash, @error_arr)
      end
    end
  end

  def process_new(data_hash, error_hash, error_arr)
    return if DataItem.find_by(email: data_hash['email'])
    item = DataItem.new(data_hash)
    item.save
    if !item.save
      error_hash.merge!(message: handle_error_message(item.errors))
      error_arr << error_hash
    end
  end

  def sanitize_phone(hash, error_arr, error_hash)
    error_msg = "Invalid format: must contain only '0-9, (), -, .'"
    if hash['phone'] !~ %r{[!@#$%^&*_+{}\[\]:;'"\/\\?><,]}
      hash['phone'] = hash['phone'].gsub(/[^0-9]/, '')
    else
      error_hash.merge!(message: error_msg)
      error_arr << error_hash
    end
  end

  def handle_error_message(errors)
    column_names = errors.messages.keys
    err = []
    column_names.map do |k|
      errors.details[k].each {|e| err << e[:format][:message] }
    end
    err.join(", ")
  end
end
