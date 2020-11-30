original_prompt = Pry.config.prompt

if Rails.env.development? || Rails.env.test?
  color = :green
  env   = Rails.env.upcase
end

debug = (Rails.env == 'debug' ? ' (DEBUG)' : '')

Pry.config.prompt_name = Pry::Helpers::Text.send(color, env + debug)
