# frozen_string_literal: true
class TimeConverter

  AVAILIABLE_PARAMS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%S' }.freeze

  def initialize(env)
    @env = env
  end

  def call
    query_params = get_query_params
    incorrect_params = get_incorrect_query_params(query_params)
    if success?
      result(correct_body(query_params))
    else
      wrong_body(incorrect_params)
    end
  end

  def success?
    @invalid_params.empty?
  end

  private

  def wrong_body(incorrect_params)
    ["Unknown time format #{incorrect_params}"]
  end

  def get_query_params
    @env['QUERY_STRING'][/format=(.*)/, 1].split('%2C')
  end

  def get_incorrect_query_params(query_params)
    @invalid_params = query_params - AVAILIABLE_PARAMS.keys
  end

  def correct_body(query_params)
    query_params.map { |param| AVAILIABLE_PARAMS[param] }.join('-')
  end

  def result(keys_for_time)
    Time.now.strftime(keys_for_time)
  end
end
