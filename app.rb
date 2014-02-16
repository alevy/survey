require 'sinatra'
require 'json'
require 'csv'

get '/fields' do
  content_type 'application/json'
  data = Dir.glob('data/*').map! do |filepath|
    JSON.parse(File.read(filepath)).keys
  end.flatten.uniq.to_json
end

get '/filter.?:format?' do
  whitelist_keys = params['fields']
  data = []
  if whitelist_keys
    data = Dir.glob('data/*').map! do |filepath|
      JSON.parse(File.read(filepath)).select do |k,v|
        whitelist_keys.include?(k)
      end
    end
  end

  format = params[:format] || 'json'
  case format
  when 'csv'
    content_type 'text/csv'
    result = ""
    csv = CSV.new(result, headers: whitelist_keys, write_headers: true)
    data.each do |row|
      csv << row
    end
    result
  else
    content_type 'application/json'
    data.to_json
  end
end

post '/submit' do
  submission_id = SecureRandom.uuid
  data = params.select {|k,v| not v.empty? }
  return_to = data.delete("return_to")
  if photo = data[:photo]
    newpath = File.join('photos', submission_id)
    FileUtils.mv(photo[:tempfile].path, File.join('public', newpath))
    data['photo'] = newpath
  end
  File.open(File.join('data', submission_id + '.json'), "w") do |file|
    file.write(data.to_json)
  end
  redirect_to return_to
end
