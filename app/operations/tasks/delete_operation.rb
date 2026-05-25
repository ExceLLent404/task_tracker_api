module Tasks
  class DeleteOperation < BaseOperation
    def call(instance:)
      instance.destroy! if instance.persisted?
    end
  end
end
