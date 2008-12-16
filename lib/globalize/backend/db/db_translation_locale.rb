class DbTranslationLocale < ActiveRecord::Base
  set_table_name "translation_locales"
  acts_as_tree
  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"
  has_many :translations, :class_name => "DbTranslation", :foreign_key => "locale_id"
  validates_uniqueness_of :locale
  
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
    "#{locale}-x-#{id}"
  end
end
