# frozen_string_literal: true

class App
  AVAILIABLE_PARAMS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%S' }.freeze

  def call(env)
    if correct_path?(env)
      query_params = get_query_params(env)
      incorrect_params = get_incorrect_query_params(query_params)
      if incorrect_params.any?
        [400, headers, ["Unknown time format #{incorrect_params}"]]
      else
        [200, headers, [correct_body(query_params)]]
      end
    else
      [404, headers, ['Unknown requset path']]
    end
  end

  def correct_body(keys)
    keys_for_time = keys.map do |param|
      AVAILIABLE_PARAMS[param]
    end.join('-')
    Time.now.strftime(keys_for_time)
  end

  def get_incorrect_query_params(query_params)
    query_params - AVAILIABLE_PARAMS.keys
  end

  def get_query_params(env)
    env['QUERY_STRING'][/format=(.*)/, 1].split('%2C')
  end

  def correct_path?(env)
    env['REQUEST_PATH'] =~ %r{^/time$}
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
