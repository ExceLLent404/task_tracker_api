module Tasks
  class DeleteOperation < BaseOperation
    def call(id:)
      instance = TaskInstance.find(id)
      instance.destroy!
    end
  end
end
