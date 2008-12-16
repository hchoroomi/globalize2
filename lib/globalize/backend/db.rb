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
          @translations[locale.language_tag.to_sym] = locale.translation_hash
          I18n.fallbacks.map locale.language_tag.to_sym => locale.parent.language_tag.to_sym unless locale.parent.nil?
        end
        @initialized = true
      end
    end
  end
end