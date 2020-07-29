# frozen_string_literal: true

class TimeConverter
  attr_accessor :success
  AVAILIABLE_PARAMS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%S' }.freeze

  def initialize(env)
    @env = env
    @success = false
  end

  def call
    query_params = get_query_params
    incorrect_params = get_incorrect_query_params(query_params)
    if incorrect_params.empty?
      @success = true
      correct_body(query_params)
    else
      wrong_body(incorrect_params)
    end
  end

  def wrong_body(incorrect_params)
    ["Unknown time format #{incorrect_params}"]
  end

  def get_query_params
    @env['QUERY_STRING'][/format=(.*)/, 1].split('%2C')
  end

  def get_incorrect_query_params(query_params)
    query_params - AVAILIABLE_PARAMS.keys
  end

  def correct_body(query_params)
    keys_for_time = query_params.map do |param|
      AVAILIABLE_PARAMS[param]
    end.join('-')
    Time.now.strftime(keys_for_time)
  end
end
