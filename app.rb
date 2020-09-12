# frozen_string_literal: true
require 'pry'
class App
  def call(env)
    if correct_path?(env)
      time_formatter = TimeConverter.new(env)
      body = time_formatter.call
      status = time_formatter.success? ? 200 : 400
      response(status, body)
    else
      response(404, 'Unknown request path')
    end
  end

  private

  def response(code, message)
    response = Rack::Response.new
    response['Content-Type'] = 'text/plain'
    response.status = code
    response.write message
    response.finish
  end

  def correct_path?(env)
    env['REQUEST_PATH'] =~ %r{^/time$}
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
