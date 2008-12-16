namespace :i18n do
  namespace :db do
    desc "Load translation yaml file into database"
    task :load => :environment do
      file = File.open(File.expand_path("config/locales/#{ENV['locale']}.yml", Rails.root))
      data = YAML::load(file)

      locale = DbTranslationLocale.find_or_create_by_locale(ENV['locale'])
      locale.save
      store_translations(locale, data[ENV['locale']])
    end
  end
end

def store_translations(locale, data, prefix = nil)
  data.each do |key, value|
    full_key = prefix.nil? ? key : "#{prefix}.#{key}"
    puts full_key
    if value.is_a?(Hash)
      store_translations(locale, value, full_key)
    else
      t = locale.translations.find_or_create_by_key(:key => full_key, :value => value)
      t.value = value
      t.save
    end
  end
end
