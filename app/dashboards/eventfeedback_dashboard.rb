require "administrate/base_dashboard"

class EventfeedbackDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    event: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ['name'],
    ),
    user: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ['firstname, lastname, email'],
    ),
    character: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ['name'],
    ),
    created_at: Field::DateTime,
    preeventcommunicationrating: Field::Number,
    eventrating: Field::Number,
    attendnextevent: Field::Number,
    sleepingrating: Field::Number,
    openingmeetingrating: Field::Number,
    closingmeetingrating: Field::Number,
    plotrating: Field::Number,
    feedback: Field::String,
    questions: Field::String,
    standoutplayers: Field::String,
    standoutnpc: Field::String,
    charactergoals: Field::String,
    charactergoalactions: Field::String,
    whatdidyoudo: Field::String,
    nexteventplans: Field::String,
    professions: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    event
    user
    character
    created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    event
    user
    character
    created_at
    preeventcommunicationrating
    eventrating
    attendnextevent
    sleepingrating
    openingmeetingrating
    closingmeetingrating
    plotrating
    feedback
    questions
    standoutplayers
    standoutnpc
    charactergoals
    charactergoalactions
    whatdidyoudo
    nexteventplans
    professions
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how event feedbacks are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(eventfeedback)
    eventfeedback.event.name + ' - ' + eventfeedback.user.firstname + ' ' + eventfeedback.user.lastname
  end
end
