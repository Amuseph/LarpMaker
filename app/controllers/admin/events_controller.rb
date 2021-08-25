module Admin
  class EventsController < Admin::ApplicationController
    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    def update
      @event = Event.find(params[:id])
      @oldname = @event.name
      if @event.update(resource_params)
        Explog.where("name = ? AND description like ?", 'Event', "Exp for attending Event \"#{@oldname}\" as a %").each do |explog|
          explog.description = explog.description.sub(@oldname, @event.name)
          explog.amount = @event.eventexp
          explog.save!
        end
      end

      redirect_to admin_event_path
    end


    def order
      @order ||= Administrate::Order.new(
        params.fetch(resource_name, {}).fetch(:order, default_sort[:order]),
        params.fetch(resource_name, {}).fetch(:direction, default_sort[:direction]),
      )
    end

    # override this in specific controllers as needed
    def default_sort
      { order: :startdate, direction: :desc }
    end

    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    # def find_resource(param)
    #   Foo.find_by!(slug: param)
    # end

    # The result of this lookup will be available as `requested_resource`

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    # def scoped_resource
    #   if current_user.super_admin?
    #     resource_class
    #   else
    #     resource_class.with_less_stuff
    #   end
    # end

    # Override `resource_params` if you want to transform the submitted
    # data before it's persisted. For example, the following would turn all
    # empty values into nil values. It uses other APIs such as `resource_class`
    # and `dashboard`:
    #
    # def resource_params
    #   params.require(resource_class.model_name.param_key).
    #     permit(dashboard.permitted_attributes).
    #     transform_values { |value| value == "" ? nil : value }
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
