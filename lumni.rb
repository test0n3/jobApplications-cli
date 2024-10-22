# frozen_string_literal: true

require 'csv'

def process_directory(directory_path)
  files = []
  Dir.entries(directory_path)
     .select { |entry| entry.end_with?('.png') }
     .sort_by { |entry| File.birthtime(File.join(directory_path, entry)) }
     .each do |entry|
    filename = File.basename(entry, File.extname(entry)).split(' - ')
    files.push({ original_name: directory_path + entry,
                 date: File.birthtime(File.join(directory_path, entry)).strftime('%Y-%m-%d'),
                 position: filename[2..].join(' '),
                 company: filename[1],
                 platform: filename[0] })
  end
  files
end

def create_csv(directory_path, files)
  application_month = directory_path.split('/').last
  csv_file = File.join(directory_path, "postulaciones_#{application_month}.csv")
  CSV.open(csv_file, 'w',
           headers: ['Fecha de postulación', 'Cargo', 'Empresa', 'Plataforma', 'Estado de proceso'],
           write_headers: true) do |csv|
    files.each do |row|
      csv << [row[:date], row[:position], row[:company], row[:platform], 'en proceso']
    end
  end

  puts 'CSV file created:', csv_file
end

def create_pdf(directory_path, files)
  application_month = directory_path.split('/').last
  files_to_process = files.map { |file| file[:original_name] }
  pdf_images = system('img2pdf', *files_to_process, '-o',
                      "#{directory_path}postulaciones_#{application_month}.pdf")

  puts "PDF created: #{pdf_images}"
end

directory_path = ARGV[0]
directory_path = directory_path.match?(%r{/$}) ? directory_path : "#{directory_path}/"
files = process_directory(directory_path)
# puts files
create_csv(directory_path, files)
create_pdf(directory_path, files)
