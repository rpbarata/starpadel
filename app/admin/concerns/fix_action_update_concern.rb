# frozen_string_literal: true

module FixActionUpdateConcern
  extend ActiveSupport::Concern

  def update
    if update_instance
      respond_to do |format|
        format.html do
          flash[:message] =
            flash_message("update.success", title: "Success!",
              message: "The %{lowercase_model_name} was successfully updated.")
          redirect_to_return_location(:update, instance, default: admin.instance_path(instance))
        end
        format.json { render(json: instance, status: :ok) }

        yield format if block_given?
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:error] =
            flash_message("update.failure", title: "Warning!", message: "Please correct the errors below.")
          render("edit", status: :unprocessable_entity)
        end
        format.json { render(json: instance.errors, status: :unprocessable_entity) }

        yield format if block_given?
      end
    end
  end
end
