require "administrate/base_dashboard"

class ExplogDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ['firstname', 'lastname', 'email'],
    ),
    grantedby: Field::BelongsTo,
    id: Field::Number,
    acquiredate: Field::DateTime,
    name: Field::String,
    name: Field::Select.with_options(
      collection: ['Adjustment', 'Donation', 'Event', 'Feedback Letter', 'Level Up',
        'Profession Purchase', 'Referral Bonus', 'Ritual', 'Season Pass', 'Skill Refund',
        'Volunteer', 'Volunteer - Break down', 'Volunteer - Myth Booth', 'Volunteer - Set up', 
        'XP Store', 'XP Transfer'],
    ),
    description: Field::String,
    amount: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    user
    name
    amount
    acquiredate
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    user
    grantedby
    acquiredate
    name
    description
    amount
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    user
    grantedby
    acquiredate
    name
    description
    amount
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

  # Overwrite this method to customize how explogs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(explog)
  #   "Explog ##{explog.id}"
  # end
end
