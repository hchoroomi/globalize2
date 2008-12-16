class DbTranslation < ActiveRecord::Base
  set_table_name "translations"
  serialize :value
  belongs_to :locale, :class_name => "DbTranslationLocale", :foreign_key => "locale_id"
  validates_presence_of :key
  validates_presence_of :value
  validates_uniqueness_of :key, :scope => :locale_id
end
