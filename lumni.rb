# frozen_string_literal: true

require 'csv'

directory_path = ARGV[0]
directory_path = directory_path.match?(%r{/$}) ? directory_path : "#{directory_path}/"
# puts 'directory:', directory_path

files = []
Dir.entries(directory_path).each do |entry|
  next unless File.file?(File.join(directory_path, entry))
  next unless entry.end_with?('.png')

  # puts 'entry.class:', entry.class, ' entry: ', entry, ' extension-less entry: ', entry[0, entry.length - 4]
  date = File.ctime(File.join(directory_path, entry)).strftime('%Y-%m-%d')
  new_entry = entry[0, entry.length - 4]
  position = new_entry.split(' - ')[2..].join(' ')
  company =  new_entry.split(' - ')[1]
  platform = new_entry.split(' - ')[0]
  files.push({ original_name: entry, date: date, position: position, company: company, platform: platform })
end
# puts files

csv_file = File.join(directory_path, "postulaciones_#{directory_path.split('/').last}.csv")
CSV.open(csv_file, 'w', headers: ['Fecha de postulación', 'Cargo', 'Empresa', 'Plataforma', 'Estado de proceso'],
                        write_headers: true) do |csv|
  files.each do |row|
    csv << [row[:date], row[:position], row[:company], row[:platform], 'en proceso']
  end
end

puts 'CSV file created:', csv_file

# create file
pdf_images = system("img2pdf #{directory_path}*.png -o \
                    #{directory_path}postulaciones_#{directory_path.split('/').last}.pdf")
puts "PDF created: #{pdf_images}"
