module Admin
  class EventattendancesController < Admin::ApplicationController
    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    include EventsHelper
    def create
      @eventattendance = Eventattendance.new(resource_params)
      @event = Event.find_by(id: @eventattendance.event_id)

      if (@eventattendance.character_id.nil?) && (@eventattendance.user.characters.where(status: 'Active').count == 1) && (@eventattendance.registrationtype == 'Player')
        @eventattendance.character_id = @eventattendance.user.characters.find_by(status: 'Active').id
      end

      if @eventattendance.save!
        helpers.add_event_xp(@event, @eventattendance)
      end

      redirect_to admin_eventattendances_path
    end

    def update
      @eventattendance = Eventattendance.find(params[:id])
      @event = Event.find_by(id: @eventattendance.event_id)
      @eventattendance.update(resource_params)

      if (@eventattendance.character_id.nil?) && (@eventattendance.user.characters.where(status: 'Active').count == 1) && (@eventattendance.registrationtype == 'Player')
        @eventattendance.character_id = @eventattendance.user.characters.find_by(status: 'Active').id
        @eventattendance.save!
      end

      @explog = Explog.where('acquiredate BETWEEN ? AND ?', @event.startdate.beginning_of_day, @event.startdate.end_of_day).find_by(
        name: 'Event', user_id: @eventattendance.user_id
      )
      if @explog
        @explog.description = "Exp for attending Event \"#{@eventattendance.event.name}\" as a #{@eventattendance.registrationtype}"
        @explog.save!
      end
      redirect_to admin_eventattendances_path
    end

    def destroy
      @eventattendance = Eventattendance.find(params[:id])
      @event = Event.find_by(id: @eventattendance.event_id)
      @explog = Explog.where('acquiredate BETWEEN ? AND ?', @event.startdate.beginning_of_day, @event.startdate.end_of_day).find_by(
        name: 'Event', user_id: @eventattendance.user_id
      )

      @explog&.destroy
      @eventattendance.destroy
      redirect_to admin_eventattendances_path
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
