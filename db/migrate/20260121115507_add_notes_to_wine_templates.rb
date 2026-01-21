class AddNotesToWineTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :wine_templates, :notes, :text
  end
end
