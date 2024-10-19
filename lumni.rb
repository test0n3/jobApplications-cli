# frozen_string_literal: true

require 'csv'
require 'shellwords'

directory_path = ARGV[0]
directory_path = directory_path.match?(%r{/$}) ? directory_path : "#{directory_path}/"
application_month = directory_path.split('/').last

files = []
Dir.entries(directory_path).each do |entry|
  next unless File.file?(File.join(directory_path, entry))
  next unless entry.end_with?('.png')

  date = File.birthtime(File.join(directory_path, entry)).strftime('%Y-%m-%d')
  filename = File.basename(entry, File.extname(entry))
  position = filename.split(' - ')[2..].join(' ')
  company =  filename.split(' - ')[1]
  platform = filename.split(' - ')[0]
  files.push({ original_name: entry, date: date, position: position, company: company, platform: platform })
end

files = files.sort_by { |file| file[:date] }
# puts files

csv_file = File.join(directory_path, "postulaciones_#{application_month}.csv")
CSV.open(csv_file, 'w', headers: ['Fecha de postulación', 'Cargo', 'Empresa', 'Plataforma', 'Estado de proceso'],
                        write_headers: true) do |csv|
  files.each do |row|
    csv << [row[:date], row[:position], row[:company], row[:platform], 'en proceso']
  end
end

puts 'CSV file created:', csv_file

files_to_process = files.map { |file| directory_path + Shellwords.escape(file[:original_name]) }.join(' ')
# puts files_to_process

# create file
pdf_images = system("img2pdf #{files_to_process} -o #{directory_path}postulaciones_#{application_month}.pdf")
puts "PDF created: #{pdf_images}"
