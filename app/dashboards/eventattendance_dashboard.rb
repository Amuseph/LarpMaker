require "administrate/base_dashboard"

class EventattendanceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    event: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ['name'],
    ),
    user: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ['firstname', 'lastname', 'email'],
    ),
    character: Field::BelongsTo,
    cabin: Field::BelongsTo,
    id: Field::Number,
    registrationtype: Field::Select.with_options(
      collection: ['Player', 'Cast', 'Staff'],
    ),
    mealplan: Field::Select.with_options(
      collection: ['', 'No Meal', 'Brew of the Month Club', 'Meat', 'Vegan'],
    ),
    registerdate: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    noshow: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    event
    user
    registrationtype
    mealplan
    character
    cabin
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    event
    user
    mealplan
    character
    cabin
    registrationtype
    registerdate
    created_at
    updated_at
    noshow
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    event
    user
    character
    cabin
    registrationtype
    mealplan
    registerdate
    noshow
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

  # Overwrite this method to customize how eventattendances are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(eventattendance)
  #   "Eventattendance ##{eventattendance.id}"
  # end
end
