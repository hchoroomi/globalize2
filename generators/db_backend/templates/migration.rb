class CreateGlobalize2 < ActiveRecord::Migration
  def self.up
    create_table :globalize_translations do |t|
      #t.string :locale, :null => false
      t.string :key, :null => false
      t.text :value
      t.references :locale
      t.timestamps
    end

    create_table :globalize_translation_locales do |t|
      t.string  :locale, :name
    end
    
  end
  
  def self.down
    drop_table :globalize_translations
    drop_table :globalize_translation_locales
  end
end
