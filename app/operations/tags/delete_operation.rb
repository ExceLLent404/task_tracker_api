module Tags
  class DeleteOperation < BaseOperation
    def call(id:)
      tag = Tag.find(id)
      raise DomainError, "System tag cannot be deleted" if tag.system?

      tag.destroy!
    end
  end
end
