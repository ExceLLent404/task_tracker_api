module Tasks
  class DeleteOperation < BaseOperation
    def call(instance:)
      instance.destroy!
    end
  end
end
