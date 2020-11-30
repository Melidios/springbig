require 'csv'
class ProcessCsvJob < ApplicationJob
  attr_reader :csv, :file_name, :error_arr

  def self.call(csv, file_name)
    new(csv, file_name).perform
  end

  def initialize(csv, file_name)
    @csv = csv
    @file_name = file_name
    @error_arr = []
  end

  def perform
    import_and_return_errors
    error_arr
  end

  private

  def import_and_return_errors
    CSV.foreach(csv.path, headers: true).with_index(1) do |r, i|
      error_hash = { row: i }
      data_hash = r.to_h.merge!(file_name: file_name)
      sanitize_phone(data_hash, error_arr, error_hash)
      process_new(data_hash, error_arr, i)
    end
  end

  def process_new(data_hash, error_arr, index)
    return if DataItem.find_by(email: data_hash['email'], file_name: file_name)
    item = DataItem.new(data_hash)
    item.save
  rescue
  ensure
    if !item.save
      handle_error_message(item.errors, error_arr, index)
    end
  end

  def sanitize_phone(hash, error_arr, error_hash)
    return if hash['phone'].nil?
    error_msg = "Invalid format: must contain only number 0-9, special charachters: '(), -, .' and be 10 digits"
    if hash['phone'] !~ %r{[!@#$%^&*_+{}\[\]:;'"\/\\?><,]} && hash['phone'].gsub(/[^0-9]/, '').length == 10
      hash['phone'] = hash['phone'].gsub(/[^0-9]/, '').split(/(?<=^.{3})/).join(" ")
    else
      hash['phone'] = ''
      error_hash.merge!(message: error_msg)
      error_arr << error_hash
    end
  end

  def handle_error_message(errors, error_arr, index)
    column_names = errors.messages.keys
    column_names.each do |k|
      hash = {row: index}
      error_arr << hash.merge!(message: errors.messages[k].join(", "))
    end
  end
end
