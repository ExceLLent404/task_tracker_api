module Tags
  class UpdateOperation < BaseOperation
    def call(id:, data:)
      tag = Tag.find(id)
      raise DomainError, "System tag cannot be modified" if tag.system?

      tag.update!(data)
      tag
    end
  end
end
