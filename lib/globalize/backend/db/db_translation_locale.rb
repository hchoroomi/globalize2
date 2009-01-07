class DbTranslationLocale < ActiveRecord::Base
  set_table_name "globalize_translation_locales"
  acts_as_tree
  #belongs_to :creator, :class_name => "User", :foreign_key => "user_id"
  has_many :translations, :class_name => "DbTranslation", :foreign_key => "locale_id", :dependent => :destroy
  
  validates_presence_of :locale
  validates_uniqueness_of :name
  
  before_create :copy_translations_from_parent
  
  def translation_hash
    return @hash unless @hash.nil?
    
    @hash = Hash.new
    
    translations.each do |translation|
      branch = translation.key.split('.')
      leaf = branch.pop
      
      parent = @hash
      branch.each do |node|
        parent = (parent[node.to_sym] ||= Hash.new)
      end
      parent[leaf.to_sym] = translation.value
    end
    @hash
  end
  
  def language_tag
    new_record? ? locale : "#{locale}-x-#{id}"
  end
  
  def copy_translations_from(other_locale)
    other_locale.translations.each do |other_translation|
      translations << other_translation.clone
    end
  end
  
  def self.from_yaml_file(file, locale)
    data = YAML::load(file)

    translation_locale = DbTranslationLocale.new(:locale => locale)
    add_translations_from_yaml(translation_locale, data[locale])
    translation_locale
  end
  
  def missing_keys(all_keys)
    all_keys - translations.map {|t| t.key}
  end
  
  def complete?(all_keys)
    missing_keys(all_keys).empty?
  end
  
  protected
  
  def copy_translations_from_parent
    copy_translations_from(parent) if parent
  end
  
  def self.add_translations_from_yaml(locale, data, prefix = nil)
    data.each do |key, value|
      full_key = prefix.nil? ? key : "#{prefix}.#{key}"
      if value.is_a?(Hash)
        add_translations_from_yaml(locale, value, full_key)
      else
        locale.translations.build(:key => full_key, :value => value)
      end
    end
  end
end
