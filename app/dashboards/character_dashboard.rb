require "administrate/base_dashboard"

class CharacterDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    characterskills: Field::HasMany,
    characterprofessions: Field::HasMany,
    professions: Field::HasMany,
    professiongroups: Field::HasMany,
    courier: Field::HasMany,
    user: Field::BelongsTo.with_options(
      searchable: true,
      searchable_fields: ['firstname', 'lastname', 'email'],
    ),
    eventattendances: Field::HasMany,
    events: Field::HasMany,
    race: Field::BelongsTo,
    characterclass: Field::BelongsTo,
    deity: Field::BelongsTo,
    house: Field::BelongsTo,
    guild: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    pronouns: Field::Select.with_options(
      collection: ['He/Him', 'She/Her','They/Them'],
    ),
    level: Field::Number,
    totem: Field::Select.with_options(
      collection: ['', 'Bear', 'Lizard', 'Rat', 'Raven', 'Snake', 'Spider', 'Wolf'],
    ),
    status: Field::Select.with_options(
      collection: ['Active', 'Deceased'],
    ),
    levelupdate: Field::Date,
    createdate: Field::Date,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    rewrite: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    user
    characterclass
    race
    deity
    level
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    user
    name
    pronouns
    rewrite
    level
    race
    characterclass
    totem
    deity
    house
    guild
    status
    levelupdate
    createdate
    created_at
    updated_at
    characterskills
    characterprofessions
    eventattendances
    courier
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    user
    name
    pronouns
    rewrite
    level
    levelupdate
    race
    characterclass
    totem
    deity
    house
    guild
    status
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

  # Overwrite this method to customize how characters are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(character)
    character.name
  end
end
