class DbTranslation < ActiveRecord::Base
  set_table_name "globalize_translations"
  serialize :value
  belongs_to :locale, :class_name => "DbTranslationLocale", :foreign_key => "locale_id"
  validates_presence_of :key
  validates_presence_of :value
  validates_uniqueness_of :key, :scope => :locale_id
  
  after_save do |record|
    #record.locale.updated_at_will_change!
    record.locale.save(false)
  end
end
