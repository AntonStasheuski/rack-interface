# frozen_string_literal: true

class App
  def call(env)
    response = Rack::Response.new
    response['Content-Type'] = 'text/plain'
    if correct_path?(env)
      time_formatter = TimeConverter.new(env)
      response.write(time_formatter.call)
      response.status = time_formatter.success ? 200 : 400
    else
      response.status = 404
      response.write('Unknown requset path')
    end
    response.finish
  end

  private

  def correct_path?(env)
    env['REQUEST_PATH'] =~ %r{^/time$}
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
