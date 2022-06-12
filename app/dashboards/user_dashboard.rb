require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    explogs: Field::HasMany,
    characters: Field::HasMany,
    eventattendances: Field::HasMany,
    events: Field::HasMany,
    explog: Field::HasOne,
    id: Field::Number,
    email: Field::String,
    encrypted_password: Field::String,
    firstname: Field::String,
    lastname: Field::String,
    usertype: Field::Select.with_options(
      collection: ['Player', 'Cast', 'Admin', 'Banned'],
    ),
    address: Field::String,
    address2: Field::String,
    city: Field::String,
    state: Field::String,
    zipcode: Field::Number,
    phonenumber: Field::Number,
    charactercount: Field::Number,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::String.with_options(searchable: false),
    last_sign_in_ip: Field::String.with_options(searchable: false),
    confirmation_token: Field::String,
    confirmed_at: Field::DateTime,
    confirmation_sent_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    last_character: Field::Number,
    aliaslastname: Field::String,
    mealexempt: Field::Boolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    firstname
    lastname
    email
    usertype
    
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    firstname
    lastname
    aliaslastname
    email
    usertype
    address
    address2
    city
    state
    zipcode
    phonenumber
    charactercount
    mealexempt
    created_at
    explogs
    characters
    eventattendances
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    email
    firstname
    lastname
    usertype
    address
    address2
    city
    state
    zipcode
    phonenumber
    charactercount
    aliaslastname
    mealexempt
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

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
   def display_resource(user)
    user.firstname + ' ' + user.lastname
  end
end
