require 'globalize/backend/pluralizing'
require 'globalize/locale/fallbacks'
require 'globalize/translation'
require 'globalize/backend/db/db_translation'
require 'globalize/backend/db/db_translation_locale'

module Globalize
  module Backend
    class Db < Static
      def init_translations
        @translations = Hash.new
        DbTranslationLocale.all.each do |locale|
          @translations[locale.locale.to_sym] = locale.translation_hash
          I18n.fallbacks.map locale.locale.to_sym => locale.parent.locale.to_sym unless locale.parent.nil?
        end
        @initialized = true
      end
    end
  end
end