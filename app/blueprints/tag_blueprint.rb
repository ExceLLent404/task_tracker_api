class TagBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :system

  field :created_at do |tag|
    tag.created_at.iso8601
  end

  field :updated_at do |tag|
    tag.updated_at.iso8601
  end

  view :index do
    excludes :system, :created_at, :updated_at
  end
end
