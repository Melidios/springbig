original_prompt = Pry.config.prompt

# url = ENV['CANONICAL_URL']
if Rails.env.development? || Rails.env.test?
  color = :green
  env   = Rails.env.upcase
else
  color = :magenta
  env   = url.match(/https:\/\/((\w|-)+)/).try(:[], 1)&.upcase || ''
end

debug = (Rails.env == 'debug' ? ' (DEBUG)' : '')

Pry.config.prompt_name = Pry::Helpers::Text.send(color, env + debug)
